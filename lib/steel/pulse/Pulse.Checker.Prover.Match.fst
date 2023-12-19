module Pulse.Checker.Prover.Match

open Pulse.Syntax
open Pulse.Typing
open Pulse.Typing.Combinators
open Pulse.Typing.Metatheory
open Pulse.Typing.Util
open Pulse.Checker.VPropEquiv
open Pulse.Checker.Prover.Base
open Pulse.Checker.Prover.Util

module RU = Pulse.RuntimeUtils
module L = FStar.List.Tot
module R = FStar.Reflection.V2
module TermEq = FStar.Reflection.V2.TermEq
module T = FStar.Tactics.V2

module RUtil = Pulse.Reflection.Util
module P = Pulse.Syntax.Printer
module PS = Pulse.Checker.Prover.Substs

let equational (t:term) : bool =
  match t.t with
  | Tm_FStar host_term ->
    (match R.inspect_ln host_term with
     | R.Tv_Match _ _ _ -> true
     | _ -> false)
  | _ -> false

let type_of_fv (g:env) (fv:R.fv)
  : T.Tac (option R.term)
  = let n = R.inspect_fv fv in
    match R.lookup_typ (fstar_env g) n with
    | None -> None
    | Some se ->
      match R.inspect_sigelt se with
      | R.Unk -> None
      | R.Sg_Let _ lbs -> (
        L.tryPick
          (fun lb -> 
            let lbv = R.inspect_lb lb in
            if R.inspect_fv lbv.lb_fv = n
            then Some lbv.lb_typ
            else None)
          lbs
      )
      | R.Sg_Val _ _ t -> Some t
      | R.Sg_Inductive _nm _univs params typ _ -> None

let is_smt_fallback (t:R.term) : bool =
  match R.inspect_ln t with
  | R.Tv_FVar fv ->
    let name = R.inspect_fv fv in
    name = ["Steel";"Effect";"Common";"smt_fallback"] ||
    name = ["Pulse"; "Lib"; "Core"; "equate_by_smt"]
  | _ -> false

(*
  When comparing t0 =?= t1, if they are not syntactically equal, we
  have to decide whether or not we should fire an SMT query to compare
  them for provable equality.

  The criterion is as follows:

  1. We allow an SMT query if either t0 or t1 is "equational". For now, that means
     that either is a match expression.

  2. Otherwise, if they are both applications of `f v0...vn` and `f u0...un`
     of the same head symbol `f`, a top-level constant, then we check if the
     type of `f` decorates any of its binders with the `smt_fallback` attribute. 

        - If none of them are marked as such,
          then we check if `f v0...` is syntactically equal to `f u0...`
          and allow an SMT query to check if vn = vm. That is, the default behavior
          for predicates is that they *last* argument is eligible for SMT equality.

        - Otherwise, for each binder that is NOT marked as `smt_fallback`, we check
          if the corresponding argument is syntactically equal. If so, we allow 
          t0 and t1 to be compared for SMT equality.

          For example, Steel.ST.Reference.pts_to is defined like so:

            /// For instance, [pts_to r (sum_perm (half_perm p) (half_perm p)) (v + 1)]
            /// is unifiable with [pts_to r p (1 + v)]
            val pts_to (#a:Type0)
                      (r:ref a)
                      ([@@@smt_fallback] p:perm)
                      ([@@@smt_fallback] v:a)
              : vprop
*)
let eligible_for_smt_equality (g:env) (t0 t1:term) 
  : T.Tac bool
  = let either_equational () = equational t0 || equational t1 in
    let head_eq (t0 t1:R.term) =
      match R.inspect_ln t0, R.inspect_ln t1 with
      | R.Tv_App h0 _, R.Tv_App h1 _ ->
        TermEq.term_eq h0 h1
      | _ -> false
    in
    match t0.t, t1.t with
    | Tm_FStar t0, Tm_FStar t1 -> (
      let h0, args0 = R.collect_app_ln t0 in
      let h1, args1 = R.collect_app_ln t1 in
      if TermEq.term_eq h0 h1 && L.length args0 = L.length args1
      then (
        match R.inspect_ln h0 with
        | R.Tv_FVar fv
        | R.Tv_UInst fv _ -> (
          match type_of_fv g fv with
          | None -> either_equational()
          | Some t ->
            let bs, _ = R.collect_arr_ln_bs t in
            let is_smt_fallback (b:R.binder) = 
                let bview = R.inspect_binder b in
                L.existsb is_smt_fallback bview.attrs
            in
            let some_fallbacks, fallbacks =
              L.fold_right
                (fun b (some_fallbacks, bs) -> 
                  if is_smt_fallback b
                  then true, true::bs
                  else some_fallbacks, false::bs)
                bs (false, [])
            in
            if not some_fallbacks
            then (
                //if none of the binders are marked fallback
                //then, by default, consider only the last argument as
                //fallback
              head_eq t0 t1
            )
            else (
              let rec aux args0 args1 fallbacks =
                match args0, args1, fallbacks with
                | (a0, _)::args0, (a1, _)::args1, b::fallbacks -> 
                  if b
                  then aux args0 args1 fallbacks
                  else if not (TermEq.term_eq a0 a1)
                  then false
                  else aux args0 args1 fallbacks
                | [], [], [] -> true
                | _ -> either_equational() //unequal lengths
              in
              aux args0 args1 fallbacks
            )
        ) 
        | _ -> either_equational ()
      )
      else either_equational ()
    )
    | Tm_ForallSL _ _ _, Tm_ForallSL _ _ _ -> true
    | _ -> either_equational ()


let refl_uvar (t:R.term) (uvs:env) : option var =
  let open R in
  match inspect_ln t with
  | Tv_Var v ->
    let {uniq=n} = inspect_namedv v in
    if contains uvs n then Some n else None
  | _ -> None

let is_uvar (t:term) (uvs:env) : option var =
  match t.t with
  | Tm_FStar t -> refl_uvar t uvs
  | _ -> None

let contains_uvar (t:term) (uvs:env) (g:env) : T.Tac bool =
  not (check_disjoint uvs (freevars t))

let is_reveal_uvar (t:term) (uvs:env) : option (universe & term & var) =
  match is_pure_app t with
  | Some (hd, None, arg) ->
    (match is_pure_app hd with
     | Some (hd, Some Implicit, ty) ->
       let arg_uvar_index_opt = is_uvar arg uvs in
       (match arg_uvar_index_opt with
        | Some n ->
          (match is_fvar hd with
           | Some (l, [u]) ->
             if l = RUtil.reveal_lid
             then Some (u, ty, n)
             else None
           | _ -> None)
        | _ -> None)
     | _ -> None)
  | _ -> None

let is_reveal (t:term) : bool =
  match leftmost_head t with
  | Some hd ->
    (match is_fvar hd with
     | Some (l, [_]) -> l = RUtil.reveal_lid
     | _ -> false)
  | _ -> false

module RT = FStar.Reflection.Typing

let compose (s0 s1: PS.ss_t)
  : T.Tac 
    (option (s:PS.ss_t {  
      Set.equal (PS.dom s) (Set.union (PS.dom s0) (PS.dom s1))
     }))
  = if PS.check_disjoint s0 s1  // TODO: should implement a better compose
    then (
      let s = PS.push_ss s0 s1 in
      assume (Set.equal (PS.dom s) (Set.union (PS.dom s0) (PS.dom s1)));
      Some s
    ) 
    else None

let maybe_canon_term (x:term) : term = 
  match readback_ty (elab_term x) with
  | None -> x
  | Some x -> x

let rec try_solve_uvars 
          (g:env) (uvs:env { disjoint uvs g })
          (p q:term)
: T.Tac (ss:PS.ss_t { PS.dom ss `Set.subset` freevars q })
= assume (Set.equal (PS.dom PS.empty) Set.empty);
  debug_prover g (fun _ ->
    Printf.sprintf "prover matcher:{\n%s \n=?=\n %s}"
       (P.term_to_string p)
       (P.term_to_string q));
  
  if not (contains_uvar q uvs g)
  then PS.empty
  else begin
    match is_reveal_uvar q uvs, is_reveal p with
    | Some (u, ty, n), false ->
      let w = mk_hide u ty p in
      assume (~ (PS.contains PS.empty n));
      let ss = PS.push PS.empty n (maybe_canon_term w) in
      assume (n `Set.mem` freevars q);
      assume (Set.equal (PS.dom ss) (Set.singleton n));
      ss
    | _ ->
      match is_uvar q uvs with
      | Some n ->
        let w = p in
        assume (~ (PS.contains PS.empty n));
        let ss = PS.push PS.empty n (maybe_canon_term w) in
        assume (n `Set.mem` freevars q);
        assume (Set.equal (PS.dom ss) (Set.singleton n));
        debug_prover g (fun _ ->
          Printf.sprintf "prover matcher: solved uvar %d with %s" n (P.term_to_string w));
        ss
 
      | _ ->
        match p.t, q.t with
        | Tm_Pure p1, Tm_Pure q1 ->
          try_solve_uvars g uvs p1 q1

        | Tm_Star p1 p2, Tm_Star q1 q2 -> (
          let ss1 = try_solve_uvars g uvs p1 q1 in
          let ss2 = try_solve_uvars g uvs p2 q2 in
          match compose ss1 ss2 with
          | None -> PS.empty
          | Some ss -> ss
        )
        
        | Tm_ForallSL u1 b1 body1, Tm_ForallSL u2 b2 body2 -> (
          let ss1 = try_solve_uvars g uvs b1.binder_ty b2.binder_ty in
          let ss2 = try_solve_uvars g uvs body1 body2 in
          if Substs.ln_ss_t ss2
          then
            match compose ss1 ss2 with
            | None -> PS.empty
            | Some ss -> ss
          else PS.empty
        )

        | _, _ ->
          match is_pure_app p, is_pure_app q with
          | Some (head_p, qual_p, arg_p), Some (head_q, qual_q, arg_q) -> (
            assume ((Set.union (freevars head_q) (freevars arg_q)) `Set.subset` freevars q);
            let ss_head = try_solve_uvars g uvs head_p head_q in
            let ss_arg = try_solve_uvars g uvs arg_p arg_q in
            match compose ss_head ss_arg with
            | None -> PS.empty
            | Some ss -> ss
          )
          | _, _ -> PS.empty
  end

let unify (g:env) (uvs:env { disjoint uvs g})
  (p q:term)
  : T.Tac (ss:PS.ss_t { PS.dom ss `Set.subset` freevars q } &
           option (RT.equiv (elab_env g) (elab_term p) (elab_term ss.(q)))) =

  let ss = try_solve_uvars g uvs p q in
  match readback_ty (elab_term ss.(q)) with
  | None -> (| ss, None |)
  | Some q -> 
    if eq_tm p q
    then (| ss, Some (RT.Rel_refl _ _ _) |)
    else if contains_uvar q uvs g
    then (| ss, None |)
    else if eligible_for_smt_equality g p q
    then let v0 = elab_term p in
        let v1 = elab_term q in
        match check_equiv_now (elab_env g) v0 v1 with
        | Some token, _ -> (| ss, Some (RT.Rel_eq_token _ _ _ (FStar.Squash.return_squash token)) |)
        | None, _ -> (| ss, None |)
    else (| ss, None |)

let try_match_pq (g:env) (uvs:env { disjoint uvs g}) (p q:vprop)
  : T.Tac (ss:PS.ss_t { PS.dom ss `Set.subset` freevars q } &
           option (vprop_equiv g p ss.(q))) =

  let r = unify g uvs p q in
  match r with
  | (| ss, None |) -> (| ss, None |)
  | (| ss, Some _ |) -> (| ss, Some (RU.magic #(vprop_equiv _ _ _) ()) |)

let coerce_eq (#a #b:Type) (x:a) (_:squash (a == b)) : y:b{y == x} = x

let match_step (#preamble:preamble) (pst:prover_state preamble)
  (p:vprop) (remaining_ctxt':list vprop)
  (q:vprop) (unsolved':list vprop)
  (_:squash (pst.remaining_ctxt == p::remaining_ctxt' /\
             pst.unsolved == q::unsolved'))
: T.Tac (option (pst':prover_state preamble { pst' `pst_extends` pst })) =

let q_ss = pst.ss.(q) in
assume (freevars q_ss `Set.disjoint` PS.dom pst.ss);

let (| ss_q, ropt |) = try_match_pq pst.pg pst.uvs p q_ss in

debug_prover pst.pg (fun _ ->
  Printf.sprintf "prover matcher: tried to match p %s and q (partially substituted) %s, result: %s"
    (P.term_to_string p) (P.term_to_string (ss_q.(q_ss))) (if None? ropt then "fail" else "success"));

match ropt with
| None -> None
| Some veq ->
  assert (PS.dom ss_q `Set.disjoint` PS.dom pst.ss);
  
  let ss_new = PS.push_ss pst.ss ss_q in

  let veq : vprop_equiv pst.pg p (ss_q.(pst.ss.(q))) = veq in

  assume (ss_q.(pst.ss.(q)) == ss_new.(q));
  let veq : vprop_equiv pst.pg p ss_new.(q) = coerce_eq veq () in

  let remaining_ctxt_new = remaining_ctxt' in
  let solved_new = q * pst.solved in
  let unsolved_new = unsolved' in

  let k
    : continuation_elaborator
        preamble.g0 (preamble.ctxt * preamble.frame)
        pst.pg ((list_as_vprop pst.remaining_ctxt * preamble.frame) * pst.ss.(pst.solved)) = pst.k in

  assume (pst.ss.(pst.solved) == ss_new.(pst.solved));

  let k
    : continuation_elaborator
        preamble.g0 (preamble.ctxt * preamble.frame)
        pst.pg ((list_as_vprop (p::remaining_ctxt_new) * preamble.frame) * ss_new.(pst.solved)) =
    coerce_eq k () in

  let k
    : continuation_elaborator
        preamble.g0 (preamble.ctxt * preamble.frame)
        pst.pg ((list_as_vprop remaining_ctxt_new * preamble.frame) * (ss_new.(q) * ss_new.(pst.solved))) =
    k_elab_equiv k (VE_Refl _ _) (RU.magic ()) in
  
  assume (ss_new.(q) * ss_new.(pst.solved) == ss_new.(q * pst.solved));

  let k
    : continuation_elaborator
        preamble.g0 (preamble.ctxt * preamble.frame)
        pst.pg ((list_as_vprop remaining_ctxt_new * preamble.frame) * (ss_new.(solved_new))) =
    coerce_eq k () in

  assume (freevars ss_new.(solved_new) `Set.subset` dom pst.pg);
  let pst' : prover_state preamble =
    { pst with remaining_ctxt=remaining_ctxt_new;
               remaining_ctxt_frame_typing=RU.magic ();
               ss=ss_new;
               nts=None;
               solved=solved_new;
               unsolved=unsolved_new;
               k;
               goals_inv=RU.magic ();
               solved_inv=() } in

  assume (ss_new `ss_extends` pst.ss);
  Some pst'
