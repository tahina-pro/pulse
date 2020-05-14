(*
   Copyright 2019 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
module Steel.PCM.Memory
open FStar.Ghost
open Steel.PCM

/// Abstract type of memories
val mem  : Type u#(a + 1)
val core_mem (m:mem u#a) : mem u#a

/// A predicate describing non-overlapping memories
val disjoint (m0 m1:mem u#h) : prop

/// disjointness is symmetric
val disjoint_sym (m0 m1:mem u#h)
  : Lemma (disjoint m0 m1 <==> disjoint m1 m0)
          [SMTPat (disjoint m0 m1)]

/// disjoint memories can be combined
val join (m0:mem u#h) (m1:mem u#h{disjoint m0 m1}) : mem u#h

val join_commutative (m0 m1:mem)
  : Lemma
    (requires
      disjoint m0 m1)
    (ensures
      (disjoint_sym m0 m1;
       join m0 m1 == join m1 m0))

/// disjointness distributes over join
val disjoint_join (m0 m1 m2:mem)
  : Lemma (disjoint m1 m2 /\
           disjoint m0 (join m1 m2) ==>
           disjoint m0 m1 /\
           disjoint m0 m2 /\
           disjoint (join m0 m1) m2 /\
           disjoint (join m0 m2) m1)

val join_associative (m0 m1 m2:mem)
  : Lemma
    (requires
      disjoint m1 m2 /\
      disjoint m0 (join m1 m2))
    (ensures
      (disjoint_join m0 m1 m2;
       join m0 (join m1 m2) == join (join m0 m1) m2))

/// The type of mem assertions
//[@@erasable] I would like this to be abstract, but I can't define an abstract abbreviation of an erasable type and have it be erasable too. Need to fix that after which this interface should not expose its dependence on Heap
let slprop = Steel.PCM.Heap.slprop

/// interpreting mem assertions as memory predicates
val interp (p:slprop u#a) (m:mem u#a) : prop

/// A common abbreviation: memories validating p
let hmem (p:slprop u#a) = m:mem u#a {interp p m}

/// Equivalence relation on slprops is just
/// equivalence of their interpretations
let equiv (p1 p2:slprop) =
  forall m. interp p1 m <==> interp p2 m

/// A heap maps a reference to its associated value
val ref (a:Type u#a) (pcm:pcm a) : Type u#0

/// All the standard connectives of separation logic
val emp : slprop u#a
val pts_to (#a:Type u#a) (#pcm:_) (r:ref a pcm) (v:a) : slprop u#a
val h_and (p1 p2:slprop u#a) : slprop u#a
val h_or  (p1 p2:slprop u#a) : slprop u#a
val star  (p1 p2:slprop u#a) : slprop u#a
val wand  (p1 p2:slprop u#a) : slprop u#a
val h_exists (#a:Type u#a) (f: (a -> slprop u#a)) : slprop u#a
val h_forall (#a:Type u#a) (f: (a -> slprop u#a)) : slprop u#a

////////////////////////////////////////////////////////////////////////////////
//properties of equiv
////////////////////////////////////////////////////////////////////////////////

val equiv_symmetric (p1 p2:slprop)
  : squash (p1 `equiv` p2 ==> p2 `equiv` p1)

val equiv_extensional_on_star (p1 p2 p3:slprop)
  : squash (p1 `equiv` p2 ==> (p1 `star` p3) `equiv` (p2 `star` p3))


////////////////////////////////////////////////////////////////////////////////
// pts_to and abbreviations
////////////////////////////////////////////////////////////////////////////////
let ptr #a #pcm (r:ref a pcm) =
    h_exists (pts_to r)

val pts_to_compatible (#a:Type u#a)
                      (#pcm:_)
                      (x:ref a pcm)
                      (v0 v1:a)
                      (m:mem u#a)
  : Lemma
    (requires
      interp (pts_to x v0 `star` pts_to x v1) m)
    (ensures
      composable pcm v0 v1 /\
      interp (pts_to x (op pcm v0 v1)) m)

////////////////////////////////////////////////////////////////////////////////
// star
////////////////////////////////////////////////////////////////////////////////

val intro_star (p q:slprop) (mp:hmem p) (mq:hmem q)
  : Lemma
    (requires
      disjoint mp mq)
    (ensures
      interp (p `star` q) (join mp mq))

val star_commutative (p1 p2:slprop)
  : Lemma ((p1 `star` p2) `equiv` (p2 `star` p1))

val star_associative (p1 p2 p3:slprop)
  : Lemma ((p1 `star` (p2 `star` p3))
           `equiv`
           ((p1 `star` p2) `star` p3))

val star_congruence (p1 p2 p3 p4:slprop)
  : Lemma (requires p1 `equiv` p3 /\ p2 `equiv` p4)
          (ensures (p1 `star` p2) `equiv` (p3 `star` p4))

val affine_star (p q:slprop) (m:mem)
  : Lemma ((interp (p `star` q) m ==> interp p m /\ interp q m))

////////////////////////////////////////////////////////////////////////////////
// Memory invariants
////////////////////////////////////////////////////////////////////////////////
module S = FStar.Set
val iname : eqtype
let inames = S.set iname

val locks_invariant (e:inames) (m:mem u#a) : slprop u#a

let hmem_with_inv_except (e:inames) (fp:slprop u#a) =
  m:mem{interp (fp `star` locks_invariant e m) m}

let hmem_with_inv (fp:slprop u#a) = hmem_with_inv_except S.empty fp

(***** Following lemmas are needed in Steel.Effect *****)

val core_mem_interp (hp:slprop u#a) (m:mem u#a)
    : Lemma
      (requires interp hp m)
      (ensures interp hp (core_mem m))
      [SMTPat (interp hp (core_mem m))]

val interp_depends_only_on (hp:slprop u#a)
    : Lemma
      (forall (m0:hmem hp) (m1:mem u#a{disjoint m0 m1}).
        interp hp m0 <==> interp hp (join m0 m1))

let affine_star_smt (p q:slprop u#a) (m:mem u#a)
    : Lemma (interp (p `star` q) m ==> interp p m /\ interp q m)
      [SMTPat (interp (p `star` q) m)]
    = affine_star p q m

val h_exists_cong (#a:Type) (p q : a -> slprop)
    : Lemma
      (requires (forall x. p x `equiv` q x))
      (ensures (h_exists p `equiv` h_exists q))

////////////////////////////////////////////////////////////////////////////////
// Actions:
// Note, at this point, using the NMSTTotal effect constraints the mem to be
// in universe 2, rather than being universe polymorphic
////////////////////////////////////////////////////////////////////////////////

(** A memory predicate that depends only on fp *)
let mprop (fp:slprop u#a) =
  q:(mem u#a -> prop){
    forall (m0:mem{interp fp m0}) (m1:mem{disjoint m0 m1}).
      q m0 <==> q (join m0 m1)}

val mem_evolves : FStar.Preorder.preorder mem

let preserves_frame (e:inames) (pre post:slprop) (m0 m1:mem) =
  forall (frame:slprop).
    interp ((pre `star` frame) `star` locks_invariant e m0) m0 ==>
    (interp ((post `star` frame) `star` locks_invariant e m1) m1 /\
     (forall (f_frame:mprop frame). f_frame (core_mem m0) == f_frame (core_mem m1)))

effect MstTot (a:Type u#a) (except:inames) (expects:slprop u#1) (provides: a -> slprop u#1) =
  NMSTTotal.NMSTATETOT a (mem u#1) mem_evolves
    (requires fun m0 ->
        interp (expects `star` locks_invariant except m0) m0)
    (ensures fun m0 x m1 ->
        interp (provides x `star` locks_invariant except m0) m0 /\
        preserves_frame except expects (provides x) m0 m1)

let action_except (a:Type u#a) (except:inames) (expects:slprop) (provides: a -> slprop) =
  unit -> MstTot a except expects provides

val sel_action (#a:Type u#1) (#pcm:_) (e:inames) (r:ref a pcm) (v0:erased a)
  : action_except (v:a{compatible pcm v0 v}) e (pts_to r v0) (fun _ -> pts_to r v0)

val upd_action (#a:Type u#1) (#pcm:_) (e:inames)
               (r:ref a pcm)
               (v0:FStar.Ghost.erased a)
               (v1:a {Steel.PCM.frame_preserving pcm v0 v1})
  : action_except unit e (pts_to r v0) (fun _ -> pts_to r v1)

val free_action (#a:Type u#1) (#pcm:pcm a) (e:inames)
                (r:ref a pcm) (x:FStar.Ghost.erased a{Steel.PCM.exclusive pcm x})
  : action_except unit e (pts_to r x) (fun _ -> pts_to r pcm.Steel.PCM.p.one)

val alloc_action (#a:Type u#1) (#pcm:pcm a) (e:inames) (x:a{compatible pcm x x})
  : action_except (ref a pcm) e emp (fun r -> pts_to r x)

val ( >--> ) (i:iname) (p:slprop) : prop
let inv (p:slprop) = i:iname{i >--> p}
val new_invariant (e:inames) (p:slprop)
  : action_except (inv p) e p (fun _ -> emp)
