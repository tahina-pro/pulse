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

module Pulse.PP

include FStar.Stubs.Pprint

open FStar.Tactics
open Pulse.Typing
open Pulse.Syntax.Base

(* A helper to create wrapped text *)
val text : string -> FStar.Stubs.Pprint.document

(* Nests a document 2 levels deep, as a block. It inserts a hardline
before the doc, so if you want to format something as

  hdr
    subdoc
  tail

  you should write  hdr ^^ indent (subdoc) ^/^ tail.  Note the ^^ vs ^/^.
*)
val indent : document -> document

class printable (a:Type) = {
  pp : a -> Tac document;
}

instance val printable_string : printable string
instance val printable_unit   : printable unit
instance val printable_bool   : printable bool
instance val printable_int    : printable int
instance val printable_ctag   : printable ctag

instance val printable_option (a:Type) (_ : printable a) : printable (option a)
instance val printable_list (a:Type) (_ : printable a) : printable (list a)

instance val printable_term     : printable term
instance val printable_universe : printable universe
instance val printable_comp     : printable comp

instance val printable_env : printable env

instance val pp_effect_annot : printable effect_annot

instance val printable_post_hint_t : printable post_hint_t

instance val printable_fstar_term : printable Reflection.V2.term

instance val printable_tuple2 (a b:Type)
          (_:printable a) (_:printable b)
        : printable (a * b)
  
instance val printable_tuple3 (a b c:Type)
          (_:printable a) (_:printable b) (_:printable c)
        : printable (a * b * c)
  
instance val printable_tuple4 (a b c d:Type)
          (_:printable a) (_:printable b) (_:printable c) (_:printable d)
        : printable (a * b * c * d)
