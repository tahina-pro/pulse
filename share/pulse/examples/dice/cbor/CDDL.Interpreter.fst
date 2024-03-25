module CDDL.Interpreter
open Pulse.Lib.Pervasives

open CDDL.Pulse
module Spec = CDDL.Spec
module U64 = FStar.UInt64

type elem_typ =
| TDef: (i: nat) -> elem_typ
| TFalse
| TTrue
| TBool
| TNil
| TUndefined
| TUIntLiteral: (v: U64.t) -> elem_typ
| TArray: (i: nat) -> elem_typ

type typ =
| TElem: (t: elem_typ) -> typ
| TChoice: (l: list elem_typ) -> typ
| TTag: (tag: U64.t) -> (i: elem_typ) -> typ
// | TMap

type atom_array_group =
| TADef: (i: nat) -> atom_array_group
| TAElem: (t: elem_typ) -> atom_array_group

type elem_array_group =
| TAAtom: (t: atom_array_group) -> elem_array_group
| TAZeroOrMore: (t: atom_array_group) -> elem_array_group

type array_group = list (string & elem_array_group)

let nat_up_to (n: nat) = (x: nat { x < n })

noeq
type semenv_elem =
| SEType of Spec.typ
| SEArrayGroup of Spec.array_group3 None

noeq
type semenv = {
  se_bound: nat;
  se_env: (nat_up_to se_bound -> semenv_elem);
}

let se_typ
  (se: semenv)
  (i: nat_up_to se.se_bound)
: Tot Spec.typ
= match se.se_env i with
  | SEType t -> t
  | _ -> Spec.t_always_false

let se_array_group
  (se: semenv)
  (i: nat_up_to se.se_bound)
: Tot (Spec.array_group3 None)
= match se.se_env i with
  | SEArrayGroup t -> t
  | _ -> Spec.array_group3_always_false

let semenv_included (s1 s2: semenv) : Tot prop =
  s1.se_bound <= s2.se_bound /\
  (forall (i: nat_up_to s1.se_bound) . s1.se_env i == s2.se_env i)

[@@"opaque_to_smt"]
let semenv_extend_array_group
  (se: semenv)
  (a: Spec.array_group3 None)
: Pure semenv
    (requires True)
    (ensures fun se' ->
      se'.se_bound = se.se_bound + 1 /\
      semenv_included se se' /\
      se'.se_env se.se_bound == SEArrayGroup a
    )
= {
    se_bound = se.se_bound + 1;
    se_env = (fun i -> if i = se.se_bound then SEArrayGroup a else se.se_env i);
  }

let elem_typ_bounded
  (bound: nat)
  (t: elem_typ)
: Tot bool
= match t with
  | TDef i -> i < bound
  | TArray j -> j < bound
  | _ -> true

let elem_typ_sem
  (env: semenv)
  (t: elem_typ)
: Pure Spec.typ
  (requires elem_typ_bounded env.se_bound t)
  (ensures fun _ -> True)
= match t with
  | TDef i -> se_typ env i
  | TArray i -> Spec.t_array3 (se_array_group env i)
  | TFalse -> Spec.t_false
  | TTrue -> Spec.t_true
  | TBool -> Spec.t_bool
  | TNil -> Spec.t_nil
  | TUndefined -> Spec.t_undefined
  | TUIntLiteral n -> Spec.t_uint_literal n

let elem_typ_sem_included (s1 s2: semenv) (t: elem_typ) : Lemma
  (requires 
    semenv_included s1 s2 /\
    elem_typ_bounded s1.se_bound t
  )
  (ensures
    elem_typ_bounded s1.se_bound t /\
    elem_typ_bounded s2.se_bound t /\
    elem_typ_sem s2 t == elem_typ_sem s1 t
  )
= ()

// module Pull = FStar.Ghost.Pull

let rec sem_typ_choice
  (env: semenv)
  (l: list elem_typ)
: Pure Spec.typ
    (requires List.Tot.for_all (elem_typ_bounded env.se_bound) l)
    (ensures fun _ -> True)
    (decreases l)
= match l with
  | [] -> Spec.t_always_false
  | [t] -> elem_typ_sem env t
  | a :: q -> elem_typ_sem env a `Spec.t_choice` sem_typ_choice env q

let sem_typ_choice_bounded
  (bound: nat)
  (l: list elem_typ)
: Tot bool
= List.Tot.for_all (elem_typ_bounded bound) l

let rec sem_typ_choice_bounded_incr
  (bound1 bound2: nat)
  (l: list elem_typ)
: Lemma
  (requires
    bound1 <= bound2 /\
    sem_typ_choice_bounded bound1 l
  )
  (ensures sem_typ_choice_bounded bound2 l)
  (decreases l)
= match l with
  | [] -> ()
  | _ :: q -> sem_typ_choice_bounded_incr bound1 bound2 q

let rec sem_typ_choice_included (s1 s2: semenv) (t: list elem_typ) : Lemma
  (requires 
    semenv_included s1 s2 /\
    sem_typ_choice_bounded s1.se_bound t
  )
  (ensures
    sem_typ_choice_bounded s1.se_bound t /\
    sem_typ_choice_bounded s2.se_bound t /\
    sem_typ_choice s2 t == sem_typ_choice s1 t
  )
  (decreases t)
= match t with
  | [] -> ()
  | [_] -> ()
  | _ :: q -> sem_typ_choice_included s1 s2 q

let typ_bounded
  (bound: nat)
  (t: typ)
: Tot bool
= match t with
  | TElem t -> elem_typ_bounded bound t
  | TChoice l -> sem_typ_choice_bounded bound l
  | TTag _tag t -> elem_typ_bounded bound t

let typ_bounded_incr
  (bound1 bound2: nat)
  (t: typ)
: Lemma
  (requires
    bound1 <= bound2 /\
    typ_bounded bound1 t
  )
  (ensures typ_bounded bound2 t)
= match t with
  | TChoice l -> sem_typ_choice_bounded_incr bound1 bound2 l
  | _ -> ()

let typ_sem
  (env: semenv)
  (t: typ)
: Pure Spec.typ
  (requires typ_bounded env.se_bound t)
  (ensures fun _ -> True)
= match t with
  | TElem t -> elem_typ_sem env t
  | TChoice l -> sem_typ_choice env l
  | TTag tag t -> Spec.t_tag tag (elem_typ_sem env t)

let typ_sem_included (s1 s2: semenv) (t: typ) : Lemma
  (requires 
    semenv_included s1 s2 /\
    typ_bounded s1.se_bound t
  )
  (ensures
    typ_bounded s1.se_bound t /\
    typ_bounded s2.se_bound t /\
    typ_sem s2 t == typ_sem s1 t
  )
= match t with
  | TChoice l -> sem_typ_choice_included s1 s2 l
  | _ -> ()

let atom_array_group_bounded
  (bound: nat)
  (t: atom_array_group)
: Tot bool
= match t with
  | TADef i -> i < bound
  | TAElem t -> elem_typ_bounded bound t

let elem_array_group_bounded
  (bound: nat)
  (t: elem_array_group)
: Tot bool
= match t with
  | TAAtom t -> atom_array_group_bounded bound t
  | TAZeroOrMore t -> atom_array_group_bounded bound t

let array_group_bounded
  (bound: nat)
  (t: array_group)
: Tot bool
= List.Tot.for_all (elem_array_group_bounded bound) (List.Tot.map snd t)

let rec array_group_bounded_incr
  (bound1 bound2: nat)
  (t: array_group)
: Lemma
  (requires
    bound1 <= bound2 /\
    array_group_bounded bound1 t
  )
  (ensures array_group_bounded bound2 t)
  (decreases t)
= match t with
  | [] -> ()
  | _ :: q -> array_group_bounded_incr bound1 bound2 q

let array_group_bounded_append
  (bound: nat)
  (t1 t2: array_group)
: Lemma
  (ensures
    array_group_bounded bound (t1 `List.Tot.append` t2) <==>
    (array_group_bounded bound t1 /\
       array_group_bounded bound t2
    )
  )
  [SMTPat (array_group_bounded bound (t1 `List.Tot.append` t2))]
= List.Tot.map_append snd t1 t2;
  List.Tot.for_all_append (elem_array_group_bounded bound) (List.Tot.map snd t1) (List.Tot.map snd t2)

let atom_array_group_sem
  (env: semenv)
  (t: atom_array_group)
: Pure (Spec.array_group3 None)
    (requires atom_array_group_bounded env.se_bound t)
    (ensures fun _ -> True)
= match t with
  | TADef i -> se_array_group env i
  | TAElem j -> Spec.array_group3_item (elem_typ_sem env j)

let elem_array_group_sem
  (env: semenv)
  (t: elem_array_group)
: Pure (Spec.array_group3 None)
    (requires elem_array_group_bounded env.se_bound t)
    (ensures fun _ -> True)
= match t with
  | TAAtom i -> atom_array_group_sem env i
  | TAZeroOrMore i -> Spec.array_group3_zero_or_more (atom_array_group_sem env i)

let elem_array_group_sem_included (s1 s2: semenv) (t: elem_array_group) : Lemma
  (requires 
    semenv_included s1 s2 /\
    elem_array_group_bounded s1.se_bound t
  )
  (ensures
    elem_array_group_bounded s1.se_bound t /\
    elem_array_group_bounded s2.se_bound t /\
    elem_array_group_sem s2 t == elem_array_group_sem s1 t
  )
= ()

let rec array_group_sem
  (env: semenv)
  (t: array_group)
: Pure (Spec.array_group3 None)
    (requires array_group_bounded env.se_bound t)
    (ensures fun _ -> True)
    (decreases t)
= match t with
  | [] -> Spec.array_group3_empty
  | [_, t] -> elem_array_group_sem env t
  | (_, t) :: q -> Spec.array_group3_concat (elem_array_group_sem env t) (array_group_sem env q)

let rec array_group_sem_included (s1 s2: semenv) (t: array_group) : Lemma
  (requires 
    semenv_included s1 s2 /\
    array_group_bounded s1.se_bound t
  )
  (ensures
    array_group_bounded s1.se_bound t /\
    array_group_bounded s2.se_bound t /\
    array_group_sem s2 t == array_group_sem s1 t
  )
= match t with
  | [] -> ()
  | [_, a] -> elem_array_group_sem_included s1 s2 a
  | (_, a) :: q ->
    elem_array_group_sem_included s1 s2 a;
    array_group_sem_included s1 s2 q

let spec_close_array_group
  (#b: _)
  (t: Spec.array_group3 b)
: Tot (Spec.array_group3 b)
= fun l ->
    let res = t l in
    match res with
    | Some (_, []) -> res
    | _ -> None

let array_group3_concat_close
  (#b: _)
  (a1 a2: Spec.array_group3 b)
: Lemma
  (Spec.array_group3_equiv
    (spec_close_array_group (Spec.array_group3_concat a1 a2))
    (Spec.array_group3_concat a1 (spec_close_array_group a2))
  )
= ()

let spec_array3_close_array_group
  (#b: _)
  (a: Spec.array_group3 b)
: Lemma
  (Spec.typ_equiv
    (Spec.t_array3 a)
    (Spec.t_array3 (spec_close_array_group a))
  )
= ()

let spec_maybe_close_array_group
  (#b: _)
  (t: Spec.array_group3 b)
  (close: bool)
: Tot (Spec.array_group3 b)
= if close
  then spec_close_array_group t
  else t

let array_group3_concat_assoc
  (#b: _)
  (a1 a2 a3: Spec.array_group3 b)
: Lemma
  (Spec.array_group3_concat a1 (Spec.array_group3_concat a2 a3) `Spec.array_group3_equiv`
    Spec.array_group3_concat (Spec.array_group3_concat a1 a2) a3)
  [SMTPatOr [
    [SMTPat (Spec.array_group3_concat a1 (Spec.array_group3_concat a2 a3))];
    [SMTPat (Spec.array_group3_concat (Spec.array_group3_concat a1 a2) a3)]
  ]]
= let prf
    (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b})
  : Lemma
    (Spec.array_group3_concat a1 (Spec.array_group3_concat a2 a3) l ==
      Spec.array_group3_concat (Spec.array_group3_concat a1 a2) a3 l)
  = match a1 l with
    | None -> ()
    | Some (l1, lr1) ->
      begin match a2 lr1 with
      | None -> ()
      | Some (l2, lr2) ->
        begin match a3 lr2 with
        | None -> ()
        | Some (l3, lr3) -> List.Tot.append_assoc l1 l2 l3
        end
      end
  in
  Classical.forall_intro prf

let array_group_sem_alt
  (env: semenv)
  (t: array_group)
: Pure (Spec.array_group3 None)
    (requires array_group_bounded env.se_bound t)
    (ensures fun y -> y `Spec.array_group3_equiv` array_group_sem env t)
    (decreases t)
= match t with
  | [] -> Spec.array_group3_empty
  | (_, t) :: q -> Spec.array_group3_concat (elem_array_group_sem env t) (array_group_sem env q)

let rec array_group_sem_append
  (env: semenv)
  (t1 t2: array_group)
: Lemma
  (requires
    array_group_bounded env.se_bound t1 /\
    array_group_bounded env.se_bound t2
  )
  (ensures
    array_group_bounded env.se_bound (t1 `List.Tot.append` t2) /\
    Spec.array_group3_equiv
      (array_group_sem env (t1 `List.Tot.append` t2))
      (Spec.array_group3_concat
        (array_group_sem env t1)
        (array_group_sem env t2)
      )
  )
  (decreases t1)
  [SMTPat (array_group_sem env (t1 `List.Tot.append` t2))]
= match t1 with
  | [] -> ()
  | [_] -> ()
  | _ :: q1 -> array_group_sem_append env q1 t2

noeq
type env = {
  e_semenv: semenv;
  e_typ: (i: nat_up_to e_semenv.se_bound { SEType? (e_semenv.se_env i) } -> (t: typ { 
    typ_bounded e_semenv.se_bound t /\
    Spec.typ_equiv (typ_sem e_semenv t) (se_typ e_semenv i)
  }));
  e_array_group: (i: nat_up_to e_semenv.se_bound { SEArrayGroup? (e_semenv.se_env i) } -> (a: array_group {
    array_group_bounded e_semenv.se_bound a /\
    Spec.array_group3_equiv (array_group_sem e_semenv a) (se_array_group e_semenv i)
  }));
}

[@@"opaque_to_smt"]
let env_extend_array_group
  (e: env)
  (a: array_group)
: Pure env
    (requires array_group_bounded e.e_semenv.se_bound a)
    (ensures fun e' ->
      e'.e_semenv.se_bound > e.e_semenv.se_bound /\
      semenv_included e.e_semenv e'.e_semenv /\
      SEArrayGroup? (e'.e_semenv.se_env e.e_semenv.se_bound) /\
      e'.e_array_group e.e_semenv.se_bound == a
    )
= let sa = array_group_sem e.e_semenv a in
  let se' = semenv_extend_array_group e.e_semenv sa in
  {
    e_semenv = se';
    e_typ = (fun i ->
      typ_sem_included e.e_semenv se' (e.e_typ i);
      e.e_typ i
    );
    e_array_group = (fun i ->
      let a' : array_group = if i = e.e_semenv.se_bound then a else e.e_array_group i in
      array_group_sem_included e.e_semenv se' a';
      a'
    );
  }

let spec_array_group3_zero_or_more_equiv #b
 (a1 a2: Spec.array_group3 b)
: Lemma
  (requires Spec.array_group3_equiv a1 a2)
  (ensures Spec.array_group3_equiv (Spec.array_group3_zero_or_more a1) (Spec.array_group3_zero_or_more a2))
  [SMTPat (Spec.array_group3_equiv (Spec.array_group3_zero_or_more a1) (Spec.array_group3_zero_or_more a2))]
= assert (Spec.array_group3_equiv a1 a2);
  let rec phi
    (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b })
  : Lemma
    (ensures (Spec.array_group3_zero_or_more a1 l == Spec.array_group3_zero_or_more a2 l))
    (decreases (List.Tot.length l))
  = assert (a1 l == a2 l);
    match a1 l with
    | None -> ()
    | Some (l1, l2) ->
      List.Tot.append_length l1 l2;
      if Nil? l1
      then ()
      else phi l2
  in
  Classical.forall_intro phi

// This is nothing more than delta-equivalence

#push-options "--z3rlimit 16"

let rec typ_equiv
  (e: env)
  (fuel: nat)
  (t1: typ)
  (t2: typ)
: Pure bool
  (requires (
    typ_bounded e.e_semenv.se_bound t1 /\
    typ_bounded e.e_semenv.se_bound t2
  ))
  (ensures (fun b ->
    typ_bounded e.e_semenv.se_bound t1 /\
    typ_bounded e.e_semenv.se_bound t2 /\
    (b == true ==> Spec.typ_equiv (typ_sem e.e_semenv t1) (typ_sem e.e_semenv t2))
  ))
  (decreases fuel)
= if t1 = t2
  then true
  else if fuel = 0
  then false
  else let fuel' : nat = fuel - 1 in
  match t1, t2 with
  | TElem (TDef i), _ ->
    let s1 = e.e_semenv.se_env i in
    if SEType? s1
    then
      let t1' = e.e_typ i in
      typ_equiv e fuel' t1' t2
    else false
  | _, TElem (TDef _) ->
    typ_equiv e fuel' t2 t1
  | TChoice [], TChoice [] -> true
  | TChoice (t1' :: q1'), TChoice (t2' :: q2') ->
    if typ_equiv e fuel' (TElem t1') (TElem t2')
    then typ_equiv e fuel' (TChoice q1') (TChoice q2')
    else false
  | TTag tag1 t1, TTag tag2 t2 ->
    if tag1 <> tag2
    then false
    else typ_equiv e fuel' (TElem t1) (TElem t2)
  | TElem (TArray i1), TElem (TArray i2) ->
    let s1 = e.e_semenv.se_env i1 in
    let s2 = e.e_semenv.se_env i2 in
    if SEArrayGroup? s1 && SEArrayGroup? s2
    then
      let t1' = e.e_array_group i1 in
      let t2' = e.e_array_group i2 in
      array_group_equiv e fuel' t1' t2'
    else false
  | _ -> false

and array_group_equiv
  (e: env)
  (fuel: nat)
  (t1: array_group)
  (t2: array_group)
: Pure bool
  (requires (
    array_group_bounded e.e_semenv.se_bound t1 /\
    array_group_bounded e.e_semenv.se_bound t2
  ))
  (ensures (fun b ->
    array_group_bounded e.e_semenv.se_bound t1 /\
    array_group_bounded e.e_semenv.se_bound t2 /\
    (b == true ==> Spec.array_group3_equiv (array_group_sem e.e_semenv t1) (array_group_sem e.e_semenv t2))
  ))
  (decreases fuel)
= if t1 = t2
  then true
  else if fuel = 0
  then false
  else let fuel' : nat = fuel - 1 in
  match t1, t2 with
  | [], [] -> true
  | (_, TAAtom (TADef i1)) :: q1', _ ->
    let s1 = e.e_semenv.se_env i1 in
    if SEArrayGroup? s1
    then
      let t1' = e.e_array_group i1 in
      array_group_equiv e fuel' (t1' `List.Tot.append` q1') t2
    else false
  | _, (_, TAAtom (TADef _)) :: _ ->
    array_group_equiv e fuel' t2 t1
  | (_, TAAtom (TAElem t1)) :: q1, (_, TAAtom (TAElem t2)) :: q2 ->
    if typ_equiv e fuel' (TElem t1) (TElem t2)
    then array_group_equiv e fuel' q1 q2
    else false
  | (s1, TAZeroOrMore t1) :: q1, (s2, TAZeroOrMore t2) :: q2 ->
    if array_group_equiv e fuel' [s1, TAAtom t1] [s2, TAAtom t2]
    then begin
       assert (Spec.array_group3_equiv (atom_array_group_sem e.e_semenv t1) (atom_array_group_sem e.e_semenv t2));
       assert (Spec.array_group3_equiv (Spec.array_group3_zero_or_more (atom_array_group_sem e.e_semenv t1)) (Spec.array_group3_zero_or_more (atom_array_group_sem e.e_semenv t2)));
       array_group_equiv e fuel' q1 q2
    end
    else false
  | _ -> false

#pop-options

let spec_typ_disjoint (a1 a2: Spec.typ) : Tot prop
= (forall (l: CBOR.Spec.raw_data_item) . ~ (a1 l /\ a2 l))

#push-options "--z3rlimit 64"

#restart-solver
let rec typ_disjoint
  (e: env)
  (fuel: nat)
  (t1: typ)
  (t2: typ)
: Pure bool
  (requires (
    typ_bounded e.e_semenv.se_bound t1 /\
    typ_bounded e.e_semenv.se_bound t2
  ))
  (ensures (fun b ->
    typ_bounded e.e_semenv.se_bound t1 /\
    typ_bounded e.e_semenv.se_bound t2 /\
    (b == true ==> spec_typ_disjoint (typ_sem e.e_semenv t1) (typ_sem e.e_semenv t2))
  ))
  (decreases fuel)
= if fuel = 0
  then false
  else let fuel' : nat = fuel - 1 in
  match t1, t2 with
  | TElem (TDef i), _ ->
    let s1 = e.e_semenv.se_env i in
    if SEType? s1
    then
      let t1' = e.e_typ i in
      typ_disjoint e fuel' t1' t2
    else true
  | _, TElem (TDef _) ->
    typ_disjoint e fuel' t2 t1
  | TChoice [], _ -> true
  | TChoice (t1' :: q1'), _ ->
    if not (typ_disjoint e fuel' (TElem t1') t2)
    then false
    else typ_disjoint e fuel' (TChoice q1') t2
  | _, TChoice _ ->
    typ_disjoint e fuel' t2 t1
  | TTag tag1 t1, TTag tag2 t2 ->
    if tag1 <> tag2
    then true
    else typ_disjoint e fuel' (TElem t1) (TElem t2)
  | _, TTag _ _
  | TTag _ _, _ -> true
  | TElem (TArray i1), TElem (TArray i2) ->
    let s1 = e.e_semenv.se_env i1 in
    let s2 = e.e_semenv.se_env i2 in
    if SEArrayGroup? s1 && SEArrayGroup? s2
    then begin
      let t1' = e.e_array_group i1 in
      let t2' = e.e_array_group i2 in
      spec_array3_close_array_group (SEArrayGroup?._0 s1);
      spec_array3_close_array_group (SEArrayGroup?._0 s2);
      array_group_disjoint e fuel' true t1' t2'
    end
    else true
  | TElem TBool, TElem TFalse
  | TElem TBool, TElem TTrue -> false
  | _, TElem TBool ->
    typ_disjoint e fuel' t2 t1
  | TElem e1, TElem e2 -> e1 <> e2

and array_group_disjoint
  (e: env)
  (fuel: nat)
  (close: bool)
  (t1: array_group)
  (t2: array_group)
: Pure bool
  (requires (
    array_group_bounded e.e_semenv.se_bound t1 /\
    array_group_bounded e.e_semenv.se_bound t2
  ))
  (ensures (fun b ->
    array_group_bounded e.e_semenv.se_bound t1 /\
    array_group_bounded e.e_semenv.se_bound t2 /\
    (b == true ==> Spec.array_group3_disjoint
      (spec_maybe_close_array_group (array_group_sem e.e_semenv t1) close)
      (spec_maybe_close_array_group (array_group_sem e.e_semenv t2) close)
  )))
  (decreases fuel)
= if fuel = 0
  then false
  else let fuel' : nat = fuel - 1 in
  match t1, t2 with
  | (_, TAAtom (TADef i1)) :: q1, _ ->
    let s1 = e.e_semenv.se_env i1 in
    if SEArrayGroup? s1
    then
      let t1' = e.e_array_group i1 in
      array_group_disjoint e fuel' close (t1' `List.Tot.append` q1) t2
    else true
  | _, (_, TAAtom (TADef _)) :: _ ->
    array_group_disjoint e fuel' close t2 t1
  | (name, TAZeroOrMore t1') :: q, _ ->
    if not (array_group_disjoint e fuel' close q t2)
    then false
    else if array_group_disjoint e fuel' false [name, TAAtom t1'] t2 // loop-free shortcut, but will miss things like "disjoint? (a*) (ab)"
    then true
    else array_group_disjoint e fuel' close ((name, TAAtom t1') :: (name, TAZeroOrMore t1') :: q) t2 // general rule, possible source of loops
  | _, (_, TAZeroOrMore _) :: _ ->
    array_group_disjoint e fuel' close t2 t1
  | [], [] -> false
  | _, [] -> close
  | [], _ ->
    array_group_disjoint e fuel' close t2 t1
  | (_, TAAtom (TAElem t1')) :: q1, (_, TAAtom (TAElem t2')) :: q2 ->
    if typ_disjoint e fuel' (TElem t1') (TElem t2')
    then true
    else if typ_equiv e fuel' (TElem t1') (TElem t2')
    then array_group_disjoint e fuel' close q1 q2
    else false
//  | _ -> false

let rec spec_array_group_splittable
  (e: semenv)
  (a: array_group)
: Tot prop
= array_group_bounded e.se_bound a /\
  begin match a with
  | [] -> True
  | [_] -> True
  | (_, t) :: q ->
    Spec.array_group3_concat_unique_weak
      (elem_array_group_sem e t)
      (array_group_sem e q) /\
    spec_array_group_splittable e q
  end

let rec spec_array_group_splittable_included
  (e1 e2: semenv)
  (a: array_group)
: Lemma
  (requires
     semenv_included e1 e2 /\
     array_group_bounded e1.se_bound a
  )
  (ensures
    spec_array_group_splittable e1 a <==> spec_array_group_splittable e2 a
  )
= match a with
  | [] -> ()
  | [_] -> ()
  | (_, t) :: q ->
    elem_array_group_sem_included e1 e2 t;
    array_group_sem_included e1 e2 q;
    spec_array_group_splittable_included e1 e2 q

let spec_array_group3_concat_unique_weak_intro
  #b (a1 a3: Spec.array_group3 b)
  (prf1:
    (l: (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b })) ->
    Lemma
    (requires Spec.array_group3_concat a1 a3 l == Some (l, []))
    (ensures
      (exists (l1 l2: list CBOR.Spec.raw_data_item) .
        a1 l == Some (l1, l2) /\
        a1 l1 == Some (l1, []) /\
        a3 l2 == Some (l2, [])
    ))
//    [SMTPat (Spec.array_group3_concat a1 a3 l)]
  )
  (prf2:
    (l1: (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b })) ->
    (l2: (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b })) ->
    Lemma
    (requires
        a1 l1 == Some (l1, []) /\ a3 l2 == Some (l2, [])
    )
    (ensures       
      a1 (l1 `List.Tot.append` l2) == Some (l1, l2)
    )
//    [SMTPat (a1 (l1 `List.Tot.append` l2))]
  )
: Lemma
  (Spec.array_group3_concat_unique_weak a1 a3)
= let prf1'
    (l: (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b }))
  : Lemma
    (Spec.array_group3_concat a1 a3 l == Some (l, []) ==>
      (exists (l1 l2: list CBOR.Spec.raw_data_item) .
        a1 l == Some (l1, l2) /\
        a1 l1 == Some (l1, []) /\
        a3 l2 == Some (l2, [])
    ))
  = Classical.move_requires prf1 l
  in
  Classical.forall_intro prf1';
  let prf2'
    (l1: (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b }))
    (l2: (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b }))
  : Lemma
    ((
        a1 l1 == Some (l1, []) /\ a3 l2 == Some (l2, [])
    ) ==>
    (
      a1 (l1 `List.Tot.append` l2) == Some (l1, l2)
    ))
  = Classical.move_requires (prf2 l1) l2
  in
  Classical.forall_intro_2 prf2'

let rec spec_array_group_splittable_fold
  (e: semenv)
  (g1 g2: array_group)
: Lemma
  (requires
    spec_array_group_splittable e g1 /\
    spec_array_group_splittable e (g1 `List.Tot.append` g2)
  )
  (ensures
    spec_array_group_splittable e g2 /\
    Spec.array_group3_concat_unique_weak
      (array_group_sem e g1)
      (array_group_sem e g2)
  )
  (decreases g1)
= match g1 with
  | [] -> ()
  | [_] -> ()
  | (n1, t1) :: g1' ->
    spec_array_group_splittable_fold e g1' g2;
    let a1 = array_group_sem e g1 in
    let a3 = array_group_sem e g2 in
    spec_array_group3_concat_unique_weak_intro a1 a3
      (fun l -> ())
      (fun l1 l2 ->
        let Some (l1l, l1r) = elem_array_group_sem e t1 l1 in
        List.Tot.append_assoc l1l l1r l2
      );
    assert (Spec.array_group3_concat_unique_weak a1 a3)

// the converse does not hold: consider a* b* a*, then [a] has two decompositions: [a] [] [] and [] [] [a]

let rec spec_array_group_splittable_fold_gen
  (e: semenv)
  (g1 g2 g3: array_group)
  (n2: string)
  (g2': elem_array_group)
: Lemma
  (requires
    spec_array_group_splittable e g2 /\
    spec_array_group_splittable e (g1 `List.Tot.append` (g2 `List.Tot.append` g3)) /\
    elem_array_group_bounded e.se_bound g2' /\
    elem_array_group_sem e g2' `Spec.array_group3_equiv` array_group_sem e g2
  )
  (ensures
    spec_array_group_splittable e g3 /\
    spec_array_group_splittable e (g1 `List.Tot.append` ((n2, g2') :: g3))
  )
  (decreases g1)
= match g1 with
  | [] -> spec_array_group_splittable_fold e g2 g3
  | _ :: g1' ->
    spec_array_group_splittable_fold_gen e g1' g2 g3 n2 g2';
    assert (
      array_group_sem e ((n2, g2') :: g3) `Spec.array_group3_equiv`
      array_group_sem e (g2 `List.Tot.append` g3)
    );
//    array_group_bounded_append e.se_bound g1' (g2 `List.Tot.append` g3);
    array_group_sem_append e g1' ((n2, g2') :: g3);
    array_group_sem_append e g1' (g2 `List.Tot.append` g3);
    assert (Spec.array_group3_equiv
      (array_group_sem e (g1' `List.Tot.append` ((n2, g2') :: g3)))
      (array_group_sem e (g1' `List.Tot.append` (g2 `List.Tot.append` g3)))
    )

let spec_array_group3_concat_unique_strong'_concat_left
  (#b: _)
  (g1 g2 g3: Spec.array_group3 b)
: Lemma
  (requires
    Spec.array_group3_concat_unique_strong' g1 (Spec.array_group3_concat g2 g3) /\
    Spec.array_group3_concat_unique_strong' g2 g3 /\
    Spec.array_group3_concat_unique_weak g1 g2
  )
  (ensures
    Spec.array_group3_concat_unique_strong' (Spec.array_group3_concat g1 g2) g3
  )
= let a1 = Spec.array_group3_concat g1 g2 in
  let a3 = g3 in
  let prf
    (l1 l2:
      (l: list CBOR.Spec.raw_data_item { Spec.opt_precedes_list l b })
    )
  : Lemma
    (Some? (a3 l2) ==> (a1 (l1 `List.Tot.append` l2) == Some (l1, l2) <==> a1 l1 == Some (l1, [])))
  = if Some? (a3 l2)
    then begin
      if FStar.StrongExcludedMiddle.strong_excluded_middle (a1 (l1 `List.Tot.append` l2) == Some (l1, l2))
      then assert (a1 l1 == Some (l1, []))
      else if FStar.StrongExcludedMiddle.strong_excluded_middle (a1 l1 == Some (l1, []))
      then begin
        let Some (lg1, lg2) = g1 l1 in
        assert (g1 lg1 == Some (lg1, []));
        assert (g2 lg2 == Some (lg2, []));
        List.Tot.append_assoc lg1 lg2 l2
      end
    end
  in
  Classical.forall_intro_2 prf

let spec_array_group3_concat_unique_strong_concat_left
  (#b: _)
  (g1 g2 g3: Spec.array_group3 b)
: Lemma
  (requires
    Spec.array_group3_concat_unique_strong g1 (Spec.array_group3_concat g2 g3) /\
    Spec.array_group3_concat_unique_strong g2 g3 /\
    Spec.array_group3_concat_unique_weak g1 g2
  )
  (ensures
    Spec.array_group3_concat_unique_strong (Spec.array_group3_concat g1 g2) g3
  )
= spec_array_group3_concat_unique_strong'_concat_left g1 g2 g3

#restart-solver
let rec array_group_concat_unique_strong
  (e: env)
  (e_thr: nat {
    forall (i: nat_up_to e.e_semenv.se_bound { i < e_thr /\ SEArrayGroup? (e.e_semenv.se_env i) }) .
      spec_array_group_splittable e.e_semenv (e.e_array_group i)
  })
  (fuel: nat)
  (a1 a2: array_group)
: Pure bool
  (requires
    spec_array_group_splittable e.e_semenv a1 /\
    array_group_bounded e.e_semenv.se_bound a2
  )
  (ensures fun b ->
    b == true ==> Spec.array_group3_concat_unique_strong
      (array_group_sem e.e_semenv a1)
      (array_group_sem e.e_semenv a2)
  )
  (decreases fuel)
= if fuel = 0
  then false
  else let fuel' : nat = fuel - 1 in
  match a1, a2 with
  | [], _ -> true
  | (n1, t1l) :: t1r :: q, _ ->
    let a1' = t1r :: q in
    if not (array_group_concat_unique_strong e e_thr fuel' a1' a2)
    then false
    else if not (array_group_concat_unique_strong e e_thr fuel' [n1, t1l] (a1' `List.Tot.append` a2))
    then false
    else begin
      spec_array_group3_concat_unique_strong_concat_left (elem_array_group_sem e.e_semenv t1l) (array_group_sem e.e_semenv a1') (array_group_sem e.e_semenv a2);
      true
    end
  | [_, TAAtom (TAElem _)], _ -> true
  | [n1, TAAtom (TADef i)], _ ->
    if SEArrayGroup? (e.e_semenv.se_env i)
    then
      if i >= e_thr
      then false
      else
        let t1 = e.e_array_group i in
        array_group_concat_unique_strong e e_thr fuel' t1 a2
    else true
  | _, (n2, TAAtom (TADef i)) :: a2' ->
    if SEArrayGroup? (e.e_semenv.se_env i)
    then
      let t1 = e.e_array_group i in
      array_group_concat_unique_strong e e_thr fuel' a1 (t1 `List.Tot.append` a2')
    else true
  | [n1, TAZeroOrMore t1], _ ->
    if not (array_group_disjoint e fuel false [n1, TAAtom t1] a2)
    then false
    else if not (array_group_concat_unique_strong e e_thr fuel' [n1, TAAtom t1] [n1, TAAtom t1])
    then false
    else if not (array_group_concat_unique_strong e e_thr fuel' [n1, TAAtom t1] a2)
    then false
    else begin
      Spec.array_group3_concat_unique_strong_zero_or_more_left
        (atom_array_group_sem e.e_semenv t1)
        (array_group_sem e.e_semenv a2);
      true
    end
//  | _ -> false

let rec array_group_splittable
  (e: env)
  (e_thr: nat {
    forall (i: nat_up_to e.e_semenv.se_bound { i < e_thr /\ SEArrayGroup? (e.e_semenv.se_env i) }) .
      spec_array_group_splittable e.e_semenv (e.e_array_group i)
  })
  (fuel: nat)
  (a1 a2: array_group)
: Pure bool
  (requires spec_array_group_splittable e.e_semenv a2 /\
    array_group_bounded e.e_semenv.se_bound a1
  )
  (ensures fun b ->
    array_group_bounded e.e_semenv.se_bound (a1 `List.Tot.append` a2) /\
    (b == true ==> spec_array_group_splittable e.e_semenv (a1 `List.Tot.append` a2))
  )
  (decreases fuel)
= if fuel = 0
  then false
  else let fuel' : nat = fuel - 1 in
  match a1, a2 with
  | [], _ -> true
  | t1l :: t1r :: q1, _ ->
    let a1' = t1r :: q1 in
    if array_group_splittable e e_thr fuel' a1' a2
    then array_group_splittable e e_thr fuel' [t1l] (a1' `List.Tot.append` a2)
    else false
  | _, [] -> true
  | [_, TAAtom (TADef i)], _ ->
    if SEArrayGroup? (e.e_semenv.se_env i)
    then
      if i >= e_thr
      then false
      else
        let t1 = e.e_array_group i in
        if array_group_splittable e e_thr fuel' t1 a2
        then begin
          spec_array_group_splittable_fold e.e_semenv t1 a2;
          true
        end
        else false
    else true
  | [_, TAAtom (TAElem _)], _ -> true
  | _, (n2, TAAtom (TADef i)) :: a2' ->
    if SEArrayGroup? (e.e_semenv.se_env i)
    then
      if i >= e_thr
      then false
      else
        let t1 = e.e_array_group i in
        if array_group_splittable e e_thr fuel' t1 a2' // necessary because of the infamous a* b* a* counterexample
        then
          if array_group_splittable e e_thr fuel' a1 (t1 `List.Tot.append` a2')
          then begin
            spec_array_group_splittable_fold_gen e.e_semenv a1 t1 a2' n2 (TAAtom (TADef i));
            true
          end
          else false
        else false
    else true
  | [n1, TAZeroOrMore t1], _ ->
    if not (array_group_disjoint e fuel false [n1, TAAtom t1] a2)
    then false
    else if not (array_group_concat_unique_strong e e_thr fuel [n1, TAAtom t1] [n1, TAAtom t1])
    then false
    else if not (array_group_splittable e e_thr fuel' [n1, TAAtom t1] a2)
    then false
    else begin
      Spec.array_group3_concat_unique_weak_zero_or_more_left
        (atom_array_group_sem e.e_semenv t1)
        (array_group_sem e.e_semenv a2);
      true
    end
//  | _ -> false

#pop-options