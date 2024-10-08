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
module Example.Slice
#lang-pulse
open Pulse
open Pulse.Lib.Slice
module A = Pulse.Lib.Array

fn test (arr: A.array UInt8.t)
    requires A.pts_to arr seq![0uy; 1uy; 2uy; 3uy; 4uy; 5uy]
    ensures exists* s. A.pts_to arr s ** pure (s `Seq.equal` seq![0uy; 4uy; 4uy; 5uy; 4uy; 5uy]) {
  A.pts_to_len arr;
  let slice = from_array arr 6sz;
  let SlicePair s1 s2 = split slice 2sz;
  share s2;
  let x = s2.(2sz);
  s1.(1sz) <- x;
  gather s2;
  let SlicePair s3 s4 = split s2 2sz;
  pts_to_len s3;
  pts_to_len s4;
  copy s3 s4;
  join s3 s4 s2;
  join s1 s2 slice;
  to_array slice;
}