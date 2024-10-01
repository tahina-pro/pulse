module Pulse.Lib.MonotonicGhostRef
#lang-pulse
open Pulse.Lib.Pervasives
open Pulse.Lib.GhostPCMReference
open FStar.Preorder
module GR = Pulse.Lib.GhostPCMReference
module FP = Pulse.Lib.PCM.FractionalPreorder
module PP = PulseCore.Preorder

let as_prop (t:Type0) = t <==> True

[@@erasable]
val mref (#t:Type0) (p:preorder t) : Type0

instance val non_informative_mref
  (t:Type u#0) (p:preorder t)
  : NonInformative.non_informative (mref p)

val pts_to (#t:Type) 
           (#p:preorder t) 
           (r:mref p)
           (#f:perm)
           (v:t)
: slprop2

val snapshot (#t:Type)
             (#p:preorder t) 
             (r:mref p)
             (v:t)
: slprop2
  
ghost
fn alloc (#t:Type0) (#p:preorder t) (v:t)
requires emp
returns r:mref p
ensures pts_to r #1.0R v

ghost
fn take_snapshot (#t:Type) (#p:preorder t) (r:mref p) (#f:perm) (v:t)
requires pts_to r #f v
ensures pts_to r #f v ** snapshot r v
 
ghost
fn recall_snapshot (#t:Type) (#p:preorder t) (r:mref p) (#f:perm) (#v #u:t)
requires pts_to r #f v ** snapshot r u
ensures  pts_to r #f v ** snapshot r u ** pure (as_prop (p u v))

ghost
fn dup_snapshot (#t:Type) (#p:preorder t) (r:mref p) (#u:t)
requires snapshot r u
ensures snapshot r u ** snapshot r u

ghost
fn update (#t:Type) (#p:preorder t) (r:mref p) (#u:t) (v:t)
requires pts_to r #1.0R u ** pure (as_prop (p u v))
ensures pts_to r #1.0R v
