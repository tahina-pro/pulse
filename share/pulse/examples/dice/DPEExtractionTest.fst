module DPEExtractionTest
open Pulse.Lib.Pervasives

module U8 = FStar.UInt8

```pulse
fn replace' (#a:Type0) (r:ref a) (x:a) (#v:erased a)
  requires pts_to r v
  returns y:a
  ensures pts_to r x ** pure (y == reveal v)
{
  let y = !r;
  r := x;
  y
}
```

```pulse
fn replace (r:ref U8.t) (x:U8.t) (#v:FStar.Ghost.erased U8.t)
requires
      (pts_to r v)
returns res: U8.t
ensures
      (pts_to r x ** pure (res == reveal v))
{
  replace' r x
}
```
