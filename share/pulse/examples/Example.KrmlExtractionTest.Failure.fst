module Example.KrmlExtractionTest.Failure
open Pulse.Lib.Pervasives

module U8 = FStar.UInt8

```pulse
fn replace (r:ref U8.t) (x:U8.t) (#v:FStar.Ghost.erased U8.t)
requires
      (pts_to r v)
returns res: U8.t
ensures
      (pts_to r x ** pure (res == reveal v))
{
  Pulse.Lib.Reference.replace r x
}
```
