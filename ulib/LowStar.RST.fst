(*
   Copyright 2008-2019 Microsoft Research

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
module LowStar.RST

open FStar.HyperStack.ST
module HS = FStar.HyperStack
module HST = FStar.HyperStack.ST

open LowStar.Array
open LowStar.Resource

(* Abstract modifies clause for the resource-indexed state effect *)

let frame_usedness_preservation (l1 l2:loc) (h0 h1:HS.mem)
  = forall (frame: loc) .
      (loc_disjoint frame l1 /\
      loc_includes (loc_used_in h0) frame)
      ==>
      (loc_disjoint frame l2 /\
      loc_includes (loc_used_in h1) frame)

let frame_usedness_preservation_intro (l1 l2: loc) (h0 h1:HS.mem)
  (lemma: (frame: loc) -> Lemma
    (requires ((loc_disjoint frame l1) /\ loc_includes (loc_used_in h0) frame))
    (ensures (loc_disjoint frame l2 /\ loc_includes (loc_used_in h1) frame))
  ) : Lemma (frame_usedness_preservation l1 l2 h0 h1)
  =
  let aux (frame: loc) : Lemma ( (loc_disjoint frame l1 /\
      loc_includes (loc_used_in h0) frame)
      ==>
      (loc_disjoint frame l2 /\
      loc_includes (loc_used_in h1) frame))
    =
    let aux (_: squash (loc_disjoint frame l1 /\  loc_includes (loc_used_in h0) frame)) :
      Lemma (loc_disjoint frame l2 /\ loc_includes (loc_used_in h1) frame)
      = lemma frame
    in Classical.impl_intro aux
  in
  Classical.forall_intro aux

let frame_usedness_preservation_elim (l1 l2: loc) (h0 h1:HS.mem) (frame: loc) : Lemma
  (requires (frame_usedness_preservation l1 l2 h0 h1 /\ (loc_disjoint frame l1) /\ loc_includes (loc_used_in h0) frame))
  (ensures (loc_disjoint frame l2 /\ loc_includes (loc_used_in h1) frame))
  = ()

abstract
let modifies (res0 res1:resource) (h0 h1:HS.mem) =
    modifies (as_loc (fp res0)) h0 h1 /\
    frame_usedness_preservation (as_loc (fp res0)) (as_loc (fp res1)) h0 h1

let modifies_refl (res:resource) (h:HS.mem)
  : Lemma (modifies res res h h)
           [SMTPat (modifies res res h h)] =
  ()

let modifies_trans (res0 res1 res2:resource) (h0 h1 h2:HS.mem)
  : Lemma (requires
             modifies res0 res1 h0 h1 /\
             modifies res1 res2 h1 h2)
           (ensures
             modifies res0 res2 h0 h2)
           [SMTPat (modifies res0 res2 h0 h2);
            SMTPat (modifies res0 res1 h0 h1)] =
  modifies_loc_disjoint (as_loc (fp res0)) (as_loc (fp res1)) h0 h1 h2

let reveal_modifies ()
  : Lemma (forall res0 res1 h0 h1.{:pattern modifies res0 res1 h0 h1}
             modifies res0 res1 h0 h1 <==>
             LowStar.Array.modifies (as_loc (fp res0)) h0 h1 /\
             frame_usedness_preservation (as_loc (fp res0)) (as_loc (fp res1)) h0 h1
          )
  = ()

(* State effect indexed by resources *)

let r_pre (res:resource) = imem (inv res) -> Type0
let r_post res0 a res1 = imem (inv res0) -> x:a -> imem (inv (res1 x)) -> Type0

abstract
let rst_inv (res:resource) (h:HS.mem) : GTot prop =
  loc_includes (loc_used_in  h) (as_loc (fp res)) /\ True

let reveal_rst_inv ()
  : Lemma (forall res h .
             rst_inv res h
             <==>
             loc_includes (loc_used_in  h) (as_loc (fp res)))
  = ()

let rst_inv_star (res0 res1: resource) (h: HS.mem) : Lemma
  (rst_inv (res0 <*> res1) h <==> rst_inv (res1 <*> res0) h)
  [SMTPat (rst_inv (res0 <*> res1) h)]
  = reveal_star ()

// Monotonic WPs for RSTATE
let rstate_wp (a:Type) (res0:resource) (res1:a -> resource) =
  wp:((x:a -> imem (inv (res1 x)) -> Type0) -> imem (inv res0) -> Type0){
      forall (p q:(x:a -> imem (inv (res1 x)) -> Type0)) h0 .
        (forall x h1 . p x h1 ==> q x h1) ==> wp p h0 ==> wp q h0
    }

effect RSTATE (a:Type)
              (res0:resource)                                   // Pre-resource (expected from the caller)
              (res1:a -> resource)                              // Post-resource (returned back to the caller)
              (wp:rstate_wp a res0 res1) =
       STATE a
           (fun (p:a -> HS.mem -> Type)
              (h0:HS.mem) ->
                inv res0 h0 /\                                  // Require the pre-resource invariant
                rst_inv res0 h0 /\                              // Require the additional footprints invariant
                wp (fun x h1 ->
                     inv (res1 x) h1 /\                         // Ensure the post-resource invariant
                     rst_inv (res1 x) h1 /\                     // Ensure the additional footprints invariant
                     modifies res0 (res1 x) h0 h1 ==>           // Ensure that at most resources' footprints are modified
                     p x h1) h0)                                // Prove the continuation under this hypothesis

(* Pre- and postcondition style effect RST *)

effect RST (a:Type)
           (res0:resource)
           (res1:a -> resource)
           (pre:r_pre res0)
           (post:r_post res0 a res1) =
       RSTATE a res0 res1 (fun p h0 ->
         pre h0 /\ (forall x h1 . post h0 x h1 ==> p x h1))

(* Bind operation for RSTATE *)

let bind (#a #b:Type)
         (#res0:resource)
         (#res1:a -> resource)
         (#res2:b -> resource)
         (#wp0:rstate_wp a res0 res1)
         (#wp1:(x:a -> rstate_wp b (res1 x) res2))
         (f:unit -> RSTATE a res0 res1 wp0)
         (g:(x:a -> RSTATE b (res1 x) res2 (wp1 x)))
       : RSTATE b res0 res2 (fun p h0 -> wp0 (fun x h1 -> wp1 x p h1) h0) =
  g (f ())

open LowStar.RST.Tactics

let frame_wp (#outer0:resource)
             (#inner0:resource)
             (#a:Type)
             (#outer1:a -> resource)
             (#inner1:a -> resource)
             (delta:resource{frame_delta outer0 inner0 outer1 inner1 delta})
             (wp:rstate_wp a inner0 inner1)
           : rstate_wp a outer0 outer1 =
  fun p h0 ->
    wp (fun x (h1:imem (inv (inner1 x))) ->
          inv (outer1 x) h1 /\
          sel (view_of delta) h0 == sel (view_of delta) h1
          ==>
          p x h1) h0

inline_for_extraction noextract let frame (outer0:resource)
          (#inner0:resource)
          (#a:Type)
          (outer1:a -> resource)
          (#inner1:a -> resource)
          (#[resolve_delta ()]
                   delta:resource{frame_delta outer0 inner0 outer1 inner1 delta})
          (#wp:rstate_wp a inner0 inner1)
          ($f:unit -> RSTATE a inner0 inner1 wp)
        : RSTATE a outer0 outer1 (frame_wp delta wp) =
  reveal_view ();
  reveal_can_be_split_into ();
  f ()

(* Generic framing operation for RST (through resource inclusion) *)

unfold
let frame_pre (#outer0:resource)
              (#inner0:resource)
              (delta:resource{frame_delta_pre outer0 inner0 delta})
              (pre:r_pre inner0)
              (h:imem (inv outer0)) =
  pre h

unfold
let frame_post (#outer0:resource)
               (#inner0:resource)
               (#a:Type)
               (#outer1:a -> resource)
               (#inner1:a -> resource)
               (delta:resource{frame_delta outer0 inner0 outer1 inner1 delta})
               (post:r_post inner0 a inner1)
               (h0:imem (inv outer0))
               (x:a)
               (h1:imem (inv (outer1 x))) =
  post h0 x h1 /\
  sel (view_of delta) h0 == sel (view_of delta) h1

#set-options "--no_tactics"

// [DA: should be definable directly using RSTATE frame, but get
//      an error about unexpected unification variable remaining]
inline_for_extraction noextract let rst_frame (outer0:resource)
              (#inner0:resource)
              (#a:Type)
              (outer1:a -> resource)
              (#inner1:a -> resource)
              (#[resolve_delta ()]
                   delta:resource{FStar.Tactics.with_tactic
                                         resolve_frame_delta
                                         (frame_delta outer0 inner0 outer1 inner1 delta)
                                         })
              (#pre:r_pre inner0)
              (#post:r_post inner0 a inner1)
              ($f:unit -> RST a inner0 inner1 pre post)
            : RST a outer0 outer1
                    (FStar.Tactics.by_tactic_seman resolve_frame_delta (frame_delta outer0 inner0 outer1 inner1 delta);
                      frame_pre delta pre)
                    (frame_post delta post) =
  reveal_view ();
  reveal_can_be_split_into ();
  FStar.Tactics.by_tactic_seman resolve_frame_delta (frame_delta outer0 inner0 outer1 inner1 delta);
  f ()
