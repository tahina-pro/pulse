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

module PulseCorePaper.S2.Lock
open Pulse.Lib.Pervasives
module U32 = FStar.UInt32
module Box = Pulse.Lib.Box
// let storable = is_big
// let sprop = s:slprop { storable s }

noeq
type lock = { r:Pulse.Lib.Box.box U32.t; i:iname }
let maybe b p = if b then p else emp
let lock_inv r p : v:slprop { is_slprop2 p ==> is_slprop2 v } = exists* v. Box.pts_to r v ** (maybe (v = 0ul) p)
let protects l p = inv l.i (lock_inv l.r p)

```pulse
fn create (p:storable)
requires p
returns l:lock
ensures protects l p
{
   let r = Box.alloc 0ul; 
   fold (maybe true p); (* proof hint *)
   fold lock_inv; (* proof hint *)
   let i = new_invariant (lock_inv r p);
   let l = {r;i};
   rewrite each r as l.r, i as l.i; (* proof hint *)
   fold protects; (* proof hint  *)
   l
}
```

```pulse
fn release (#p:slprop) (l:lock)
requires protects l p ** p
ensures protects l p
{
  unfold protects;
  with_invariants l.i
    //requires inv l.i (lock_inv l.r p) ** p  //we be nice to add this optionally
    returns _ : unit //would be nice to avoid this
    ensures lock_inv l.r p
    opens [l.i]
  { 
    unfold lock_inv; drop_ (maybe _ _);
    Pulse.Lib.Primitives.write_atomic_box l.r 0ul;
    fold (maybe true p); fold lock_inv;
  }; //$\label{line:release-block-end}$
  fold protects;
}
```


```pulse
fn rec acquire #p (l:lock)
requires protects l p
ensures protects l p ** p
{
  unfold protects;
  let b = with_invariants l.i
    returns b:bool //can we avoid annotating this?
    ensures lock_inv l.r p ** maybe b p //and this?
  { unfold lock_inv;
    let b = cas_box l.r 0ul 1ul;
    if b {
     elim_cond_true _ _ _;  //can we avoid this?
     unfold (maybe true p); //how many of this folds can we avoid
     fold (maybe false p);
     fold (lock_inv l.r p);
     fold (maybe true p);
     true
    } else { 
      elim_cond_false _ _ _; //can we avoid this?
      fold (lock_inv l.r p);  fold (maybe false p);
      false }};
  fold protects;
  if b { unfold (maybe true p)  }
  else { unfold (maybe false p); acquire l }}
```