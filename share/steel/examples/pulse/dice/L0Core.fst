module L0Core
module R = Steel.ST.Reference
module A = Steel.ST.Array
module T = FStar.Tactics
module PM = Pulse.Main
open Steel.ST.Util 
open Steel.ST.Array
open Steel.FractionalPermission
open FStar.Ghost
open Pulse.Steel.Wrapper
module A = Steel.ST.Array
module US = FStar.SizeT
module U8 = FStar.UInt8
module U32 = FStar.UInt32
open HACL
open L0Types

// assume val ex (x:US.t) : 
//   stt unit
//   (x > 0)
//   (fun _ -> emp)

assume 
val deviceid_len_is_valid (len:US.t)
  : valid_hkdf_lbl_len len

assume 
val aliaskey_len_is_valid (len:US.t)
  : valid_hkdf_lbl_len len

assume
val derive_key_pair_spec
  // (ikm_len: hkdf_ikm_len)
  (ikm_len: US.t)
  // (ikm: Seq.lseq U8.t (US.v ikm_len))
  (ikm: Seq.seq U8.t)
  // (lbl_len: hkdf_lbl_len)
  (lbl_len: US.t)
  // (lbl: Seq.lseq U8.t (US.v lbl_len))
  (lbl: Seq.seq U8.t)
  : Seq.seq U8.t & Seq.seq U8.t (* should be length 32 *)

let derive_AliasKey_spec
  (cdi: Seq.seq U8.t)  (* should be length 32 *)
  (fwid: Seq.seq U8.t) (* should be length 32 *)
  // (l0_label_AliasKey_len: hkdf_lbl_len)
  (l0_label_AliasKey_len: US.t)
  // (l0_label_AliasKey: Seq.lseq U8.t (US.v l0_label_AliasKey_len))
  (l0_label_AliasKey: Seq.seq U8.t)
: Seq.seq U8.t & Seq.seq U8.t (* should be length 32 *)
= let cdigest = spec_hash dice_hash_alg cdi in
  let adigest = spec_hmac dice_hash_alg cdigest fwid in
  derive_key_pair_spec
    (* ikm *) dice_digest_len adigest
    (* lbl *) l0_label_AliasKey_len l0_label_AliasKey

let derive_DeviceID_spec
  (cdi: Seq.seq U8.t) (* should be length 32 *)
  // (l0_label_DeviceID_len: hkdf_lbl_len)
  (l0_label_DeviceID_len: US.t)
  // (l0_label_DeviceID: Seq.lseq U8.t (US.v l0_label_DeviceID_len))
  (l0_label_DeviceID: Seq.seq U8.t)
: Seq.seq U8.t & Seq.seq U8.t (* should be length 32 *)
= let cdigest = spec_hash dice_hash_alg cdi in
  derive_key_pair_spec
    (* ikm *) dice_digest_len cdigest
    (* lbl *) l0_label_DeviceID_len l0_label_DeviceID

let derive_authKeyID_spec
  (deviceIDPub: Seq.seq U8.t) (* should be length 32 *)
: Seq.seq U8.t (* should be length 20 *)
= spec_hash dice_hash_alg deviceIDPub

let l0_core_step1_post
  (l0: l0_record)
  (vl0: l0_repr)
  : vprop = 
  pure (
    derive_DeviceID_spec vl0.cdi l0.deviceID_label_len vl0.deviceID_label 
      == (vl0.deviceID_pub, vl0.deviceID_priv) /\
    derive_AliasKey_spec vl0.cdi vl0.fwid l0.aliasKey_label_len vl0.aliasKey_label
      == (vl0.aliasKey_pub, vl0.aliasKey_priv) /\
    derive_authKeyID_spec vl0.deviceID_pub
      == vl0.authKeyID 
  )

```pulse 
fn derive_DeviceID
  (deviceID_pub: A.larray U8.t 32)
  (deviceID_priv: A.larray U8.t 32)
  (cdi: A.larray U8.t 32)
  (deviceID_label_len: US.t)
  (deviceID_label: A.larray U8.t (US.v deviceID_label_len))
  (#cdi0 #deviceID_label0 #deviceID_pub0 #deviceID_priv0: Seq.seq U8.t)
  requires (
    A.pts_to cdi full_perm cdi0 `star`
    A.pts_to deviceID_label full_perm deviceID_label0 `star`
    A.pts_to deviceID_pub full_perm deviceID_pub0 `star`
    A.pts_to deviceID_priv full_perm deviceID_priv0
  )
  ensures (
    A.pts_to cdi full_perm cdi0 `star`
    A.pts_to deviceID_label full_perm deviceID_label0 `star`
    (exists (deviceID_pub1:Seq.seq U8.t) (deviceID_priv1:Seq.seq U8.t). (
        A.pts_to deviceID_pub full_perm deviceID_pub1 `star`
        A.pts_to deviceID_priv full_perm deviceID_priv1 `star`
        pure (derive_DeviceID_spec cdi0 deviceID_label_len deviceID_label0 == (deviceID_pub1, deviceID_priv1))
      ))
  )
{
  admit()
}
```

```pulse
fn l0_core_step1
  (l0: l0_record)
  (vl0: l0_repr)
  requires (
    l0_perm l0 vl0 `star`
    pure( valid_hkdf_lbl_len l0.deviceID_label_len /\
          valid_hkdf_lbl_len l0.aliasKey_label_len)
  )
  ensures (
    l0_perm l0 vl0 `star`
    l0_core_step1_post l0 vl0
  )
{
  // is_valid_hkdf_ikm_len dice_digest_len;
  // is_valid_hkdf_lbl_len l0.deviceID_label_len;

  rewrite (l0_perm l0 vl0)
    as (
      A.pts_to l0.cdi full_perm vl0.cdi `star`
      A.pts_to l0.fwid full_perm vl0.fwid `star`
      A.pts_to l0.deviceID_label full_perm vl0.deviceID_label `star`
      A.pts_to l0.aliasKey_label full_perm vl0.aliasKey_label `star`
      A.pts_to l0.deviceID_pub full_perm vl0.deviceID_pub `star`
      A.pts_to l0.deviceID_priv full_perm vl0.deviceID_priv `star`
      A.pts_to l0.aliasKey_pub full_perm vl0.aliasKey_pub `star`
      A.pts_to l0.aliasKey_priv full_perm vl0.aliasKey_priv `star`
      A.pts_to l0.deviceIDCSR_buf full_perm vl0.deviceIDCSR_buf `star`
      A.pts_to l0.aliasKeyCRT_buf full_perm vl0.aliasKeyCRT_buf `star`
      A.pts_to l0.authKeyID full_perm vl0.authKeyID
    );

  derive_DeviceID l0.deviceID_pub l0.deviceID_priv l0.cdi l0.deviceID_label_len l0.deviceID_label;
  
  // derive_AliasKey l0.aliasKey_pub l0.aliasKey_priv l0.cdi l0.fwid l0.aliasKey_label_len l0.aliasKey_label;

  admit()

//   classify_public_buffer 32ul deviceID_pub deviceID_pub_sec;

//   derive_authKeyID
//     authKeyID
//     deviceID_pub_sec;

//   (**) let hsf = HST.get () in
//   HST.pop_frame ();
//   (**) let hf = HST.get () in
//   (**) B.popped_modifies hsf hf;
// ()
}
```

assume
val deviceIDCRI_pre (v:deviceIDCSR_ingredients_t) : vprop

assume
val deviceIDCSR_pre (v:deviceIDCSR_ingredients_t) (l:US.t) : vprop

assume
val aliasKeyCRT_pre (v:aliasKeyCRT_ingredients_t) (l:US.t) : vprop

let l0_pre
  // (#a:Type)
  (l0: l0_record)
  (vl0: l0_repr)
  : vprop =
  deviceIDCRI_pre l0.deviceIDCSR_ingredients `star`
  deviceIDCSR_pre l0.deviceIDCSR_ingredients l0.deviceIDCSR_len `star`
  aliasKeyCRT_pre l0.aliasKeyCRT_ingredients l0.aliasKeyCRT_len `star`
  pure (valid_hkdf_lbl_len l0.deviceID_label_len /\
        valid_hkdf_lbl_len l0.aliasKey_label_len)

assume
val aliasKey_post 
  (cdi: A.larray U8.t 32)
  (fwid: A.larray U8.t 32)
  (aliasKey_label_len: US.t)
  (aliasKey_label: A.larray U8.t (US.v aliasKey_label_len))
  (aliasKey_pub: A.larray U8.t 32)
  (aliasKey_priv: A.larray U8.t 32)
  : vprop

assume
val deviceIDCSR_post
  (cdi: A.larray U8.t 32)
  (deviceID_label_len: US.t)
  (deviceID_label: A.larray U8.t (US.v deviceID_label_len))
  (deviceIDCSR_ingredients: deviceIDCSR_ingredients_t)
  (deviceIDCSR_len: US.t)
  (deviceIDCSR_buf: A.larray U8.t (US.v deviceIDCSR_len))
  : vprop

assume
val aliasKeyCRT_post
  (cdi: A.larray U8.t 32)
  (fwid: A.larray U8.t 32)
  (deviceID_label_len: US.t)
  (deviceID_label: A.larray U8.t (US.v deviceID_label_len))
  (aliasKeyCRT_ingredients: aliasKeyCRT_ingredients_t)
  (aliasKeyCRT_len: US.t)
  (aliasKeyCRT_buf: A.larray U8.t (US.v aliasKeyCRT_len))
  (aliasKey_pub: A.larray U8.t 32)
  : vprop

let l0_post
  (l0: l0_record)
  (vl0: l0_repr)
  : vprop
  = aliasKey_post 
      l0.cdi l0.fwid l0.aliasKey_label_len l0.aliasKey_label 
      l0.aliasKey_pub l0.aliasKey_priv `star`
    deviceIDCSR_post 
      l0.cdi l0.deviceID_label_len l0.deviceID_label l0.deviceIDCSR_ingredients 
      l0.deviceIDCSR_len l0.deviceIDCSR_buf `star`
    aliasKeyCRT_post 
      l0.cdi l0.fwid l0.deviceID_label_len l0.deviceID_label l0.aliasKeyCRT_ingredients 
      l0.aliasKeyCRT_len l0.aliasKeyCRT_buf l0.aliasKey_pub

```pulse
fn l0
  (l0: l0_record)
  (vl0: l0_repr)
  // (#pcdi #pfwid #pdeviceID_label #paliasKey_label: perm)
  requires (l0_perm l0 vl0 `star`
            l0_pre l0 vl0)
   ensures exists (vl0': l0_repr). (
                      l0_perm l0 vl0' `star`
                      l0_post l0 vl0)
{
(* Derive DeviceID *)

  rewrite (l0_pre l0 vl0)
    as (deviceIDCRI_pre l0.deviceIDCSR_ingredients `star`
        deviceIDCSR_pre l0.deviceIDCSR_ingredients l0.deviceIDCSR_len `star`
        aliasKeyCRT_pre l0.aliasKeyCRT_ingredients l0.aliasKeyCRT_len `star`
        pure (valid_hkdf_lbl_len l0.deviceID_label_len /\
              valid_hkdf_lbl_len l0.aliasKey_label_len));

  l0_core_step1 l0 vl0;

  admit()

//   l0_core_step2
//     (* version   *) deviceIDCSR_ingredients.deviceIDCSR_version
//                     deviceIDCSR_ingredients.deviceIDCSR_s_common
//                     deviceIDCSR_ingredients.deviceIDCSR_s_org
//                     deviceIDCSR_ingredients.deviceIDCSR_s_country
//     (* key usage *) deviceIDCSR_ingredients.deviceIDCSR_ku
//     (* DeviceID  *) deviceID_pub
//                     deviceID_priv
//     (*DeviceIDCRI*) deviceIDCSR_len
//                     deviceIDCSR_buf;
//   let _h_step2_post = HST.get () in

//   (**) B.modifies_trans (
//     B.loc_buffer deviceID_pub  `B.loc_union`
//     B.loc_buffer deviceID_priv `B.loc_union`
//     B.loc_buffer aliasKey_pub  `B.loc_union`
//     B.loc_buffer aliasKey_priv `B.loc_union`
//     B.loc_buffer authKeyID
//   ) h0 _h_step2_pre (
//     B.loc_buffer deviceIDCSR_buf
//   ) _h_step2_post;

//   let _h_step3_pre = _h_step2_post in

//   (**) B.modifies_buffer_elim fwid (
//          B.loc_buffer deviceID_pub  `B.loc_union`
//          B.loc_buffer deviceID_priv `B.loc_union`
//          B.loc_buffer aliasKey_pub  `B.loc_union`
//          B.loc_buffer aliasKey_priv `B.loc_union`
//          B.loc_buffer authKeyID     `B.loc_union`
//          B.loc_buffer deviceIDCSR_buf
//   ) h0 _h_step3_pre;
//   (**) B.modifies_buffer_elim authKeyID     (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;
//   (**) B.modifies_buffer_elim deviceID_pub  (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;
//   (**) B.modifies_buffer_elim deviceID_priv (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;
//   (**) B.modifies_buffer_elim aliasKey_pub  (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;

//   l0_core_step3
//     (aliasKeyCRT_ingredients.aliasKeyCrt_version)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_serialNumber)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_i_common)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_i_org)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_i_country)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_notBefore)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_notAfter)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_s_common)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_s_org)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_s_country)
//     (fwid)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_ku)
//     (authKeyID)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_l0_version)
//     (* DeviceID  *) deviceID_pub
//                     deviceID_priv
//     (* AliasKey  *) aliasKey_pub
//     (*AliasKeyTBS*) aliasKeyCRT_len
//                     aliasKeyCRT_buf;
//   let _h_step3_post = HST.get () in

//   (**) B.modifies_trans (
//     B.loc_buffer deviceID_pub  `B.loc_union`
//     B.loc_buffer deviceID_priv `B.loc_union`
//     B.loc_buffer aliasKey_pub  `B.loc_union`
//     B.loc_buffer aliasKey_priv `B.loc_union`
//     B.loc_buffer authKeyID     `B.loc_union`
//     B.loc_buffer deviceIDCSR_buf
//   ) h0 _h_step3_pre (
//     B.loc_buffer aliasKeyCRT_buf
//   ) _h_step3_post;

//   (**) B.modifies_buffer_elim aliasKey_pub (
//          B.loc_buffer deviceIDCSR_buf `B.loc_union`
//          B.loc_buffer aliasKeyCRT_buf
//   ) _h_step1_post _h_step3_post;

// (* hsf *) let hsf = HST.get () in
//   HST.pop_frame ();
// (* hf *) let hf = HST.get () in
//   (**) B.popped_modifies hsf hf;
//   (**) B.modifies_buffer_elim deviceID_pub    (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim aliasKey_pub    (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim aliasKey_priv   (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim deviceIDCSR_buf (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim aliasKeyCRT_buf (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   lemma_l0_modifies
//     (byte_pub) (byte_sec)
//     (0x00uy) (u8 0x00)
//     (h0) (hf)
//     (deviceID_pub) (aliasKey_pub) (aliasKey_priv)
//     (deviceIDCSR_buf) (aliasKeyCRT_buf)
//     (hs0) (hs01) (hs02) (_h_step1_post) (_h_step2_post) (_h_step3_post) (hsf)
//     (deviceID_priv) (authKeyID);

//   assert (HST.equal_domains h0 hf)
}
```