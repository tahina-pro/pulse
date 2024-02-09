(*
   Copyright 2023 Microsoft Research

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

module Pulse.Typing.Combinators

module L = FStar.List.Tot
module T = FStar.Tactics.V2
open FStar.List.Tot
open Pulse.Syntax
open Pulse.Typing

let st_comp_with_pre (st:st_comp) (pre:term) : st_comp = { st with pre }

let nvar_as_binder (x:nvar) (t:term) : binder =
  mk_binder_ppname t (fst x)

val vprop_equiv_typing (#g:_) (#t0 #t1:term) (v:vprop_equiv g t0 t1)
  : GTot ((tot_typing g t0 tm_vprop -> tot_typing g t1 tm_vprop) &
          (tot_typing g t1 tm_vprop -> tot_typing g t0 tm_vprop))

val mk_bind (g:env)
            (pre:term)
            (e1:st_term)
            (e2:st_term)
            (c1:comp_st)
            (c2:comp_st)
            (px:nvar { ~ (Set.mem (snd px) (dom g)) })
            (d_e1:st_typing g e1 c1)
            (d_c1res:tot_typing g (comp_res c1) (tm_type (comp_u c1)))
            (d_e2:st_typing (push_binding g (snd px) (fst px) (comp_res c1)) (open_st_term_nv e2 px) c2)
            (res_typing:universe_of g (comp_res c2) (comp_u c2))
            (post_typing:tot_typing (push_binding g (snd px) (fst px) (comp_res c2))
                                     (open_term_nv (comp_post c2) px)
                                     tm_vprop)
            (bias_towards_continuation:bool)
  : T.TacH (t:st_term &
            c:comp_st { st_comp_of_comp c == st_comp_with_pre (st_comp_of_comp c2) pre /\
                        (bias_towards_continuation ==> effect_annot_of_comp c == effect_annot_of_comp c2) } &
            st_typing g t c)
           (requires fun _ ->
              let _, x = px in
              comp_pre c1 == pre /\
              None? (lookup g x) /\
              (~(x `Set.mem` freevars_st e2)) /\
              open_term (comp_post c1) x == comp_pre c2 /\
              (~ (x `Set.mem` freevars (comp_post c2))))
           (ensures fun _ _ -> True)


val bind_res_and_post_typing (g:env) (s2:comp_st) (x:var { fresh_wrt x g (freevars (comp_post s2)) })
                             (post_hint:post_hint_opt g { comp_post_matches_hint s2 post_hint })
  : T.Tac (universe_of g (comp_res s2) (comp_u s2) &
           tot_typing (push_binding g x ppname_default (comp_res s2)) (open_term_nv (comp_post s2) (v_as_nv x)) tm_vprop)

val add_frame (#g:env) (#t:st_term) (#c:comp_st) (t_typing:st_typing g t c)
  (#frame:vprop)
  (frame_typing:tot_typing g frame tm_vprop)
  : t':st_term &
    c':comp_st { c' == add_frame c frame } &
    st_typing g t' c'

let frame_for_req_in_ctxt (g:env) (ctxt:term) (req:term)
   = (frame:term &
      tot_typing g frame tm_vprop &
      vprop_equiv g (tm_star req frame) ctxt)

let frame_of #g #ctxt #req (f:frame_for_req_in_ctxt g ctxt req) =
  let (| frame, _, _ |) = f in frame

val apply_frame (#g:env)
                (#t:st_term)
                (#ctxt:term)
                (ctxt_typing: tot_typing g ctxt tm_vprop)
                (#c:comp { stateful_comp c })
                (t_typing: st_typing g t c)
                (frame_t:frame_for_req_in_ctxt g ctxt (comp_pre c))
  : Tot (c':comp_st { comp_pre c' == ctxt /\
                      comp_res c' == comp_res c /\
                      comp_u c' == comp_u c /\
                      comp_post c' == tm_star (comp_post c) (frame_of frame_t) } &
         st_typing g t c')

type st_typing_in_ctxt (g:env) (ctxt:vprop) (post_hint:post_hint_opt g) =
  t:st_term &
  c:comp_st { comp_pre c == ctxt /\ comp_post_matches_hint c post_hint } &
  st_typing g t c

let rec vprop_as_list (vp:term)
  : list term
  = match vp.t with
    | Tm_Emp -> []
    | Tm_Star vp0 vp1 -> vprop_as_list vp0 @ vprop_as_list vp1
    | _ -> [vp]

let rec list_as_vprop (vps:list term)
  : term
  = match vps with
    | [] -> tm_emp
    | [hd] -> hd
    | hd::tl -> tm_star hd (list_as_vprop tl)
