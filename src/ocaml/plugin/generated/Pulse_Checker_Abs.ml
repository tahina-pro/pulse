open Prims
let (debug_abs :
  Pulse_Typing_Env.env ->
    (unit -> (Prims.string, unit) FStar_Tactics_Effect.tac_repr) ->
      (unit, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun uu___1 ->
    fun uu___ ->
      (fun g ->
         fun s ->
           if
             Pulse_RuntimeUtils.debug_at_level (Pulse_Typing_Env.fstar_env g)
               "pulse.abs"
           then
             Obj.magic
               (Obj.repr
                  (FStar_Tactics_Effect.tac_bind
                     (FStar_Sealed.seal
                        (Obj.magic
                           (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                              (Prims.of_int (22)) (Prims.of_int (15))
                              (Prims.of_int (22)) (Prims.of_int (21)))))
                     (FStar_Sealed.seal
                        (Obj.magic
                           (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                              (Prims.of_int (22)) (Prims.of_int (7))
                              (Prims.of_int (22)) (Prims.of_int (21)))))
                     (Obj.magic (s ()))
                     (fun uu___ ->
                        (fun uu___ ->
                           Obj.magic (FStar_Tactics_V2_Builtins.print uu___))
                          uu___)))
           else
             Obj.magic
               (Obj.repr
                  (FStar_Tactics_Effect.lift_div_tac (fun uu___1 -> ()))))
        uu___1 uu___
let (range_of_st_comp : Pulse_Syntax_Base.st_comp -> FStar_Range.range) =
  fun st ->
    Pulse_RuntimeUtils.union_ranges
      (st.Pulse_Syntax_Base.pre).Pulse_Syntax_Base.range1
      (st.Pulse_Syntax_Base.post).Pulse_Syntax_Base.range1
let (range_of_comp : Pulse_Syntax_Base.comp -> FStar_Range.range) =
  fun c ->
    match c with
    | Pulse_Syntax_Base.C_Tot t -> t.Pulse_Syntax_Base.range1
    | Pulse_Syntax_Base.C_ST st -> range_of_st_comp st
    | Pulse_Syntax_Base.C_STAtomic (uu___, st) -> range_of_st_comp st
    | Pulse_Syntax_Base.C_STGhost (uu___, st) -> range_of_st_comp st
let rec (arrow_of_abs :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      (Pulse_Syntax_Base.term, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun env ->
    fun t ->
      FStar_Tactics_Effect.tac_bind
        (FStar_Sealed.seal
           (Obj.magic
              (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                 (Prims.of_int (38)) (Prims.of_int (44)) (Prims.of_int (38))
                 (Prims.of_int (50)))))
        (FStar_Sealed.seal
           (Obj.magic
              (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                 (Prims.of_int (38)) (Prims.of_int (3)) (Prims.of_int (93))
                 (Prims.of_int (5)))))
        (FStar_Tactics_Effect.lift_div_tac
           (fun uu___ -> t.Pulse_Syntax_Base.term1))
        (fun uu___ ->
           (fun uu___ ->
              match uu___ with
              | Pulse_Syntax_Base.Tm_Abs
                  { Pulse_Syntax_Base.b = b; Pulse_Syntax_Base.q = q;
                    Pulse_Syntax_Base.ascription = ascription;
                    Pulse_Syntax_Base.body = body;_}
                  ->
                  Obj.magic
                    (FStar_Tactics_Effect.tac_bind
                       (FStar_Sealed.seal
                          (Obj.magic
                             (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                (Prims.of_int (39)) (Prims.of_int (12))
                                (Prims.of_int (39)) (Prims.of_int (21)))))
                       (FStar_Sealed.seal
                          (Obj.magic
                             (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                (Prims.of_int (39)) (Prims.of_int (24))
                                (Prims.of_int (93)) (Prims.of_int (5)))))
                       (FStar_Tactics_Effect.lift_div_tac
                          (fun uu___1 -> Pulse_Typing_Env.fresh env))
                       (fun uu___1 ->
                          (fun x ->
                             Obj.magic
                               (FStar_Tactics_Effect.tac_bind
                                  (FStar_Sealed.seal
                                     (Obj.magic
                                        (FStar_Range.mk_range
                                           "Pulse.Checker.Abs.fst"
                                           (Prims.of_int (40))
                                           (Prims.of_int (13))
                                           (Prims.of_int (40))
                                           (Prims.of_int (31)))))
                                  (FStar_Sealed.seal
                                     (Obj.magic
                                        (FStar_Range.mk_range
                                           "Pulse.Checker.Abs.fst"
                                           (Prims.of_int (40))
                                           (Prims.of_int (34))
                                           (Prims.of_int (93))
                                           (Prims.of_int (5)))))
                                  (FStar_Tactics_Effect.lift_div_tac
                                     (fun uu___1 ->
                                        ((b.Pulse_Syntax_Base.binder_ppname),
                                          x)))
                                  (fun uu___1 ->
                                     (fun px ->
                                        Obj.magic
                                          (FStar_Tactics_Effect.tac_bind
                                             (FStar_Sealed.seal
                                                (Obj.magic
                                                   (FStar_Range.mk_range
                                                      "Pulse.Checker.Abs.fst"
                                                      (Prims.of_int (41))
                                                      (Prims.of_int (14))
                                                      (Prims.of_int (41))
                                                      (Prims.of_int (53)))))
                                             (FStar_Sealed.seal
                                                (Obj.magic
                                                   (FStar_Range.mk_range
                                                      "Pulse.Checker.Abs.fst"
                                                      (Prims.of_int (41))
                                                      (Prims.of_int (56))
                                                      (Prims.of_int (93))
                                                      (Prims.of_int (5)))))
                                             (FStar_Tactics_Effect.lift_div_tac
                                                (fun uu___1 ->
                                                   Pulse_Typing_Env.push_binding
                                                     env x
                                                     (FStar_Pervasives_Native.fst
                                                        px)
                                                     b.Pulse_Syntax_Base.binder_ty))
                                             (fun uu___1 ->
                                                (fun env1 ->
                                                   Obj.magic
                                                     (FStar_Tactics_Effect.tac_bind
                                                        (FStar_Sealed.seal
                                                           (Obj.magic
                                                              (FStar_Range.mk_range
                                                                 "Pulse.Checker.Abs.fst"
                                                                 (Prims.of_int (42))
                                                                 (Prims.of_int (15))
                                                                 (Prims.of_int (42))
                                                                 (Prims.of_int (38)))))
                                                        (FStar_Sealed.seal
                                                           (Obj.magic
                                                              (FStar_Range.mk_range
                                                                 "Pulse.Checker.Abs.fst"
                                                                 (Prims.of_int (42))
                                                                 (Prims.of_int (41))
                                                                 (Prims.of_int (93))
                                                                 (Prims.of_int (5)))))
                                                        (FStar_Tactics_Effect.lift_div_tac
                                                           (fun uu___1 ->
                                                              Pulse_Syntax_Naming.open_st_term_nv
                                                                body px))
                                                        (fun uu___1 ->
                                                           (fun body1 ->
                                                              Obj.magic
                                                                (FStar_Tactics_Effect.tac_bind
                                                                   (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (43))
                                                                    (Prims.of_int (30))
                                                                    (Prims.of_int (45))
                                                                    (Prims.of_int (29)))))
                                                                   (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (46))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (93))
                                                                    (Prims.of_int (5)))))
                                                                   (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    fun
                                                                    uu___2 ->
                                                                    match uu___2
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    FStar_Pervasives_Native.None
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    a ->
                                                                    a.Pulse_Syntax_Base.annotated))
                                                                   (fun
                                                                    uu___1 ->
                                                                    (fun
                                                                    annot_of_ascription
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (47))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (47))
                                                                    (Prims.of_int (46)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (48))
                                                                    (Prims.of_int (4))
                                                                    (Prims.of_int (93))
                                                                    (Prims.of_int (5)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    annot_of_ascription
                                                                    ascription))
                                                                    (fun
                                                                    uu___1 ->
                                                                    (fun
                                                                    annot ->
                                                                    if
                                                                    Pulse_Syntax_Base.uu___is_Tm_Abs
                                                                    body1.Pulse_Syntax_Base.term1
                                                                    then
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (match annot
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (53))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (53))
                                                                    (Prims.of_int (39)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (55))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (55))
                                                                    (Prims.of_int (91)))))
                                                                    (Obj.magic
                                                                    (arrow_of_abs
                                                                    env1
                                                                    body1))
                                                                    (fun arr
                                                                    ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    {
                                                                    Pulse_Syntax_Base.t
                                                                    =
                                                                    ((Pulse_Syntax_Pure.tm_arrow
                                                                    b q
                                                                    (Pulse_Syntax_Base.C_Tot
                                                                    (Pulse_Syntax_Naming.close_term
                                                                    arr x))).Pulse_Syntax_Base.t);
                                                                    Pulse_Syntax_Base.range1
                                                                    =
                                                                    (Pulse_RuntimeUtils.union_ranges
                                                                    (b.Pulse_Syntax_Base.binder_ty).Pulse_Syntax_Base.range1
                                                                    (Pulse_Syntax_Naming.close_term
                                                                    arr x).Pulse_Syntax_Base.range1)
                                                                    }))
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    c ->
                                                                    FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (58))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (58))
                                                                    (Prims.of_int (52)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (59))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (82))
                                                                    (Prims.of_int (37)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    Pulse_Syntax_Naming.open_comp_with
                                                                    c
                                                                    (Pulse_Syntax_Pure.term_of_nvar
                                                                    px)))
                                                                    (fun
                                                                    uu___1 ->
                                                                    (fun c1
                                                                    ->
                                                                    match c1
                                                                    with
                                                                    | 
                                                                    Pulse_Syntax_Base.C_Tot
                                                                    tannot ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (61))
                                                                    (Prims.of_int (24))
                                                                    (Prims.of_int (61))
                                                                    (Prims.of_int (69)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (65))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (74))
                                                                    (Prims.of_int (93)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    Pulse_RuntimeUtils.whnf_lax
                                                                    (Pulse_Typing.elab_env
                                                                    env1)
                                                                    (Pulse_Elaborate_Pure.elab_term
                                                                    tannot)))
                                                                    (fun
                                                                    uu___1 ->
                                                                    (fun
                                                                    tannot'
                                                                    ->
                                                                    match 
                                                                    Pulse_Readback.readback_ty
                                                                    tannot'
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (70))
                                                                    (Prims.of_int (14))
                                                                    (Prims.of_int (71))
                                                                    (Prims.of_int (45)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (67))
                                                                    (Prims.of_int (12))
                                                                    (Prims.of_int (71))
                                                                    (Prims.of_int (45)))))
                                                                    (Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (71))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (71))
                                                                    (Prims.of_int (44)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "prims.fst"
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (31)))))
                                                                    (Obj.magic
                                                                    (FStar_Tactics_V2_Builtins.term_to_string
                                                                    tannot'))
                                                                    (fun
                                                                    uu___1 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___2 ->
                                                                    Prims.strcat
                                                                    "Unexpected type of abstraction, expected an arrow, got: "
                                                                    (Prims.strcat
                                                                    uu___1 "")))))
                                                                    (fun
                                                                    uu___1 ->
                                                                    (fun
                                                                    uu___1 ->
                                                                    Obj.magic
                                                                    (Pulse_Typing_Env.fail
                                                                    env1
                                                                    (FStar_Pervasives_Native.Some
                                                                    (t.Pulse_Syntax_Base.range2))
                                                                    uu___1))
                                                                    uu___1)))
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    t1 ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    {
                                                                    Pulse_Syntax_Base.t
                                                                    =
                                                                    ((Pulse_Syntax_Pure.tm_arrow
                                                                    b q
                                                                    (Pulse_Syntax_Base.C_Tot
                                                                    (Pulse_Syntax_Naming.close_term
                                                                    t1 x))).Pulse_Syntax_Base.t);
                                                                    Pulse_Syntax_Base.range1
                                                                    =
                                                                    (Pulse_RuntimeUtils.union_ranges
                                                                    (b.Pulse_Syntax_Base.binder_ty).Pulse_Syntax_Base.range1
                                                                    (Pulse_Syntax_Naming.close_term
                                                                    t1 x).Pulse_Syntax_Base.range1)
                                                                    }))))
                                                                    uu___1))
                                                                    | 
                                                                    uu___1 ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (81))
                                                                    (Prims.of_int (12))
                                                                    (Prims.of_int (82))
                                                                    (Prims.of_int (37)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (78))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (82))
                                                                    (Prims.of_int (37)))))
                                                                    (Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (82))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (82))
                                                                    (Prims.of_int (36)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "prims.fst"
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (31)))))
                                                                    (Obj.magic
                                                                    (Pulse_Syntax_Printer.comp_to_string
                                                                    c1))
                                                                    (fun
                                                                    uu___2 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___3 ->
                                                                    Prims.strcat
                                                                    "Unexpected type of abstraction: "
                                                                    (Prims.strcat
                                                                    uu___2 "")))))
                                                                    (fun
                                                                    uu___2 ->
                                                                    (fun
                                                                    uu___2 ->
                                                                    Obj.magic
                                                                    (Pulse_Typing_Env.fail
                                                                    env1
                                                                    (FStar_Pervasives_Native.Some
                                                                    (t.Pulse_Syntax_Base.range2))
                                                                    uu___2))
                                                                    uu___2)))
                                                                    uu___1)))
                                                                    else
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (match annot
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    Obj.repr
                                                                    (Pulse_Typing_Env.fail
                                                                    env1
                                                                    (FStar_Pervasives_Native.Some
                                                                    (t.Pulse_Syntax_Base.range2))
                                                                    "Unannotated function body")
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    c ->
                                                                    Obj.repr
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___2 ->
                                                                    {
                                                                    Pulse_Syntax_Base.t
                                                                    =
                                                                    ((Pulse_Syntax_Pure.tm_arrow
                                                                    b q c).Pulse_Syntax_Base.t);
                                                                    Pulse_Syntax_Base.range1
                                                                    =
                                                                    (Pulse_RuntimeUtils.union_ranges
                                                                    (b.Pulse_Syntax_Base.binder_ty).Pulse_Syntax_Base.range1
                                                                    (range_of_comp
                                                                    c))
                                                                    })))))
                                                                    uu___1)))
                                                                    uu___1)))
                                                             uu___1))) uu___1)))
                                       uu___1))) uu___1))) uu___)
let rec (rebuild_abs :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      FStar_Tactics_NamedView.term ->
        (Pulse_Syntax_Base.st_term, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun t ->
      fun annot ->
        FStar_Tactics_Effect.tac_bind
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                   (Prims.of_int (98)) (Prims.of_int (4))
                   (Prims.of_int (100)) (Prims.of_int (41)))))
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                   (Prims.of_int (101)) (Prims.of_int (4))
                   (Prims.of_int (154)) (Prims.of_int (47)))))
          (Obj.magic
             (debug_abs g
                (fun uu___ ->
                   FStar_Tactics_Effect.tac_bind
                     (FStar_Sealed.seal
                        (Obj.magic
                           (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                              (Prims.of_int (100)) (Prims.of_int (16))
                              (Prims.of_int (100)) (Prims.of_int (40)))))
                     (FStar_Sealed.seal
                        (Obj.magic
                           (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                              (Prims.of_int (98)) (Prims.of_int (26))
                              (Prims.of_int (100)) (Prims.of_int (40)))))
                     (Obj.magic
                        (FStar_Tactics_V2_Builtins.term_to_string annot))
                     (fun uu___1 ->
                        (fun uu___1 ->
                           Obj.magic
                             (FStar_Tactics_Effect.tac_bind
                                (FStar_Sealed.seal
                                   (Obj.magic
                                      (FStar_Range.mk_range
                                         "Pulse.Checker.Abs.fst"
                                         (Prims.of_int (98))
                                         (Prims.of_int (26))
                                         (Prims.of_int (100))
                                         (Prims.of_int (40)))))
                                (FStar_Sealed.seal
                                   (Obj.magic
                                      (FStar_Range.mk_range
                                         "Pulse.Checker.Abs.fst"
                                         (Prims.of_int (98))
                                         (Prims.of_int (26))
                                         (Prims.of_int (100))
                                         (Prims.of_int (40)))))
                                (Obj.magic
                                   (FStar_Tactics_Effect.tac_bind
                                      (FStar_Sealed.seal
                                         (Obj.magic
                                            (FStar_Range.mk_range
                                               "Pulse.Checker.Abs.fst"
                                               (Prims.of_int (99))
                                               (Prims.of_int (16))
                                               (Prims.of_int (99))
                                               (Prims.of_int (39)))))
                                      (FStar_Sealed.seal
                                         (Obj.magic
                                            (FStar_Range.mk_range
                                               "FStar.Printf.fst"
                                               (Prims.of_int (121))
                                               (Prims.of_int (8))
                                               (Prims.of_int (123))
                                               (Prims.of_int (44)))))
                                      (Obj.magic
                                         (Pulse_Syntax_Printer.st_term_to_string
                                            t))
                                      (fun uu___2 ->
                                         FStar_Tactics_Effect.lift_div_tac
                                           (fun uu___3 ->
                                              fun x ->
                                                Prims.strcat
                                                  (Prims.strcat
                                                     "rebuild_abs\n\t"
                                                     (Prims.strcat uu___2
                                                        "\n\t"))
                                                  (Prims.strcat x "\n")))))
                                (fun uu___2 ->
                                   FStar_Tactics_Effect.lift_div_tac
                                     (fun uu___3 -> uu___2 uu___1)))) uu___1))))
          (fun uu___ ->
             (fun uu___ ->
                match ((t.Pulse_Syntax_Base.term1),
                        (FStar_Reflection_V2_Builtins.inspect_ln annot))
                with
                | (Pulse_Syntax_Base.Tm_Abs
                   { Pulse_Syntax_Base.b = b; Pulse_Syntax_Base.q = q;
                     Pulse_Syntax_Base.ascription = asc;
                     Pulse_Syntax_Base.body = body;_},
                   FStar_Reflection_V2_Data.Tv_Arrow (b', c')) ->
                    Obj.magic
                      (FStar_Tactics_Effect.tac_bind
                         (FStar_Sealed.seal
                            (Obj.magic
                               (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                  (Prims.of_int (103)) (Prims.of_int (15))
                                  (Prims.of_int (103)) (Prims.of_int (53)))))
                         (FStar_Sealed.seal
                            (Obj.magic
                               (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                  (Prims.of_int (103)) (Prims.of_int (56))
                                  (Prims.of_int (128)) (Prims.of_int (41)))))
                         (FStar_Tactics_Effect.lift_div_tac
                            (fun uu___1 ->
                               Pulse_Readback.readback_ty
                                 (FStar_Reflection_V2_Builtins.inspect_binder
                                    b').FStar_Reflection_V2_Data.sort2))
                         (fun uu___1 ->
                            (fun ty ->
                               Obj.magic
                                 (FStar_Tactics_Effect.tac_bind
                                    (FStar_Sealed.seal
                                       (Obj.magic
                                          (FStar_Range.mk_range
                                             "Pulse.Checker.Abs.fst"
                                             (Prims.of_int (104))
                                             (Prims.of_int (17))
                                             (Prims.of_int (104))
                                             (Prims.of_int (34)))))
                                    (FStar_Sealed.seal
                                       (Obj.magic
                                          (FStar_Range.mk_range
                                             "Pulse.Checker.Abs.fst"
                                             (Prims.of_int (105))
                                             (Prims.of_int (6))
                                             (Prims.of_int (128))
                                             (Prims.of_int (41)))))
                                    (FStar_Tactics_Effect.lift_div_tac
                                       (fun uu___1 ->
                                          FStar_Reflection_V2_Builtins.inspect_comp
                                            c'))
                                    (fun uu___1 ->
                                       (fun comp ->
                                          match (ty, comp) with
                                          | (FStar_Pervasives_Native.Some
                                             ty1,
                                             FStar_Reflection_V2_Data.C_Total
                                             res_ty) ->
                                              Obj.magic
                                                (Obj.repr
                                                   (if
                                                      Pulse_Syntax_Base.uu___is_Tm_Abs
                                                        body.Pulse_Syntax_Base.term1
                                                    then
                                                      Obj.repr
                                                        (FStar_Tactics_Effect.tac_bind
                                                           (FStar_Sealed.seal
                                                              (Obj.magic
                                                                 (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (109))
                                                                    (Prims.of_int (20))
                                                                    (Prims.of_int (109))
                                                                    (Prims.of_int (68)))))
                                                           (FStar_Sealed.seal
                                                              (Obj.magic
                                                                 (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (109))
                                                                    (Prims.of_int (73))
                                                                    (Prims.of_int (111))
                                                                    (Prims.of_int (65)))))
                                                           (FStar_Tactics_Effect.lift_div_tac
                                                              (fun uu___1 ->
                                                                 {
                                                                   Pulse_Syntax_Base.binder_ty
                                                                    = ty1;
                                                                   Pulse_Syntax_Base.binder_ppname
                                                                    =
                                                                    (b.Pulse_Syntax_Base.binder_ppname)
                                                                 }))
                                                           (fun uu___1 ->
                                                              (fun b1 ->
                                                                 Obj.magic
                                                                   (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (110))
                                                                    (Prims.of_int (21))
                                                                    (Prims.of_int (110))
                                                                    (Prims.of_int (46)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (111))
                                                                    (Prims.of_int (12))
                                                                    (Prims.of_int (111))
                                                                    (Prims.of_int (64)))))
                                                                    (Obj.magic
                                                                    (rebuild_abs
                                                                    g body
                                                                    res_ty))
                                                                    (fun
                                                                    body1 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___1 ->
                                                                    {
                                                                    Pulse_Syntax_Base.term1
                                                                    =
                                                                    (Pulse_Syntax_Base.Tm_Abs
                                                                    {
                                                                    Pulse_Syntax_Base.b
                                                                    = b1;
                                                                    Pulse_Syntax_Base.q
                                                                    = q;
                                                                    Pulse_Syntax_Base.ascription
                                                                    =
                                                                    FStar_Pervasives_Native.None;
                                                                    Pulse_Syntax_Base.body
                                                                    = body1
                                                                    });
                                                                    Pulse_Syntax_Base.range2
                                                                    =
                                                                    (t.Pulse_Syntax_Base.range2);
                                                                    Pulse_Syntax_Base.effect_tag
                                                                    =
                                                                    (t.Pulse_Syntax_Base.effect_tag)
                                                                    }))))
                                                                uu___1))
                                                    else
                                                      Obj.repr
                                                        (match Pulse_Readback.readback_comp
                                                                 res_ty
                                                         with
                                                         | FStar_Pervasives_Native.None
                                                             ->
                                                             Obj.repr
                                                               (FStar_Tactics_Effect.tac_bind
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (117))
                                                                    (Prims.of_int (14))
                                                                    (Prims.of_int (118))
                                                                    (Prims.of_int (44)))))
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (116))
                                                                    (Prims.of_int (12))
                                                                    (Prims.of_int (118))
                                                                    (Prims.of_int (44)))))
                                                                  (Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (118))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (118))
                                                                    (Prims.of_int (43)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "prims.fst"
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (31)))))
                                                                    (Obj.magic
                                                                    (FStar_Tactics_V2_Builtins.term_to_string
                                                                    res_ty))
                                                                    (fun
                                                                    uu___2 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___3 ->
                                                                    Prims.strcat
                                                                    "Expected a computation type; got "
                                                                    (Prims.strcat
                                                                    uu___2 "")))))
                                                                  (fun uu___2
                                                                    ->
                                                                    (fun
                                                                    uu___2 ->
                                                                    Obj.magic
                                                                    (Pulse_Typing_Env.fail
                                                                    g
                                                                    (FStar_Pervasives_Native.Some
                                                                    (FStar_Reflection_V2_Builtins.range_of_term
                                                                    res_ty))
                                                                    uu___2))
                                                                    uu___2))
                                                         | FStar_Pervasives_Native.Some
                                                             c ->
                                                             Obj.repr
                                                               (FStar_Tactics_Effect.lift_div_tac
                                                                  (fun uu___2
                                                                    ->
                                                                    {
                                                                    Pulse_Syntax_Base.term1
                                                                    =
                                                                    (Pulse_Syntax_Base.Tm_Abs
                                                                    {
                                                                    Pulse_Syntax_Base.b
                                                                    =
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = ty1;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    =
                                                                    (b.Pulse_Syntax_Base.binder_ppname)
                                                                    };
                                                                    Pulse_Syntax_Base.q
                                                                    = q;
                                                                    Pulse_Syntax_Base.ascription
                                                                    =
                                                                    (FStar_Pervasives_Native.Some
                                                                    {
                                                                    Pulse_Syntax_Base.annotated
                                                                    =
                                                                    FStar_Pervasives_Native.None;
                                                                    Pulse_Syntax_Base.elaborated
                                                                    = c
                                                                    });
                                                                    Pulse_Syntax_Base.body
                                                                    = body
                                                                    });
                                                                    Pulse_Syntax_Base.range2
                                                                    =
                                                                    (t.Pulse_Syntax_Base.range2);
                                                                    Pulse_Syntax_Base.effect_tag
                                                                    =
                                                                    (t.Pulse_Syntax_Base.effect_tag)
                                                                    })))))
                                          | uu___1 ->
                                              Obj.magic
                                                (Obj.repr
                                                   (FStar_Tactics_Effect.tac_bind
                                                      (FStar_Sealed.seal
                                                         (Obj.magic
                                                            (FStar_Range.mk_range
                                                               "Pulse.Checker.Abs.fst"
                                                               (Prims.of_int (127))
                                                               (Prims.of_int (12))
                                                               (Prims.of_int (128))
                                                               (Prims.of_int (41)))))
                                                      (FStar_Sealed.seal
                                                         (Obj.magic
                                                            (FStar_Range.mk_range
                                                               "Pulse.Checker.Abs.fst"
                                                               (Prims.of_int (126))
                                                               (Prims.of_int (8))
                                                               (Prims.of_int (128))
                                                               (Prims.of_int (41)))))
                                                      (Obj.magic
                                                         (FStar_Tactics_Effect.tac_bind
                                                            (FStar_Sealed.seal
                                                               (Obj.magic
                                                                  (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (128))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (128))
                                                                    (Prims.of_int (40)))))
                                                            (FStar_Sealed.seal
                                                               (Obj.magic
                                                                  (FStar_Range.mk_range
                                                                    "prims.fst"
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (31)))))
                                                            (Obj.magic
                                                               (FStar_Tactics_V2_Builtins.term_to_string
                                                                  annot))
                                                            (fun uu___2 ->
                                                               FStar_Tactics_Effect.lift_div_tac
                                                                 (fun uu___3
                                                                    ->
                                                                    Prims.strcat
                                                                    "Unexpected type of abstraction: "
                                                                    (Prims.strcat
                                                                    uu___2 "")))))
                                                      (fun uu___2 ->
                                                         (fun uu___2 ->
                                                            Obj.magic
                                                              (Pulse_Typing_Env.fail
                                                                 g
                                                                 (FStar_Pervasives_Native.Some
                                                                    (
                                                                    t.Pulse_Syntax_Base.range2))
                                                                 uu___2))
                                                           uu___2)))) uu___1)))
                              uu___1))
                | uu___1 ->
                    Obj.magic
                      (FStar_Tactics_Effect.tac_bind
                         (FStar_Sealed.seal
                            (Obj.magic
                               (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                  (Prims.of_int (153)) (Prims.of_int (16))
                                  (Prims.of_int (154)) (Prims.of_int (47)))))
                         (FStar_Sealed.seal
                            (Obj.magic
                               (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                  (Prims.of_int (152)) (Prims.of_int (6))
                                  (Prims.of_int (154)) (Prims.of_int (47)))))
                         (Obj.magic
                            (FStar_Tactics_Effect.tac_bind
                               (FStar_Sealed.seal
                                  (Obj.magic
                                     (FStar_Range.mk_range
                                        "Pulse.Checker.Abs.fst"
                                        (Prims.of_int (154))
                                        (Prims.of_int (22))
                                        (Prims.of_int (154))
                                        (Prims.of_int (46)))))
                               (FStar_Sealed.seal
                                  (Obj.magic
                                     (FStar_Range.mk_range "prims.fst"
                                        (Prims.of_int (590))
                                        (Prims.of_int (19))
                                        (Prims.of_int (590))
                                        (Prims.of_int (31)))))
                               (Obj.magic
                                  (FStar_Tactics_V2_Builtins.term_to_string
                                     annot))
                               (fun uu___2 ->
                                  FStar_Tactics_Effect.lift_div_tac
                                    (fun uu___3 ->
                                       Prims.strcat
                                         "Unexpected arity of abstraction: expected a term of type "
                                         (Prims.strcat uu___2 "")))))
                         (fun uu___2 ->
                            (fun uu___2 ->
                               Obj.magic
                                 (Pulse_Typing_Env.fail g
                                    (FStar_Pervasives_Native.Some
                                       (t.Pulse_Syntax_Base.range2)) uu___2))
                              uu___2))) uu___)
let (preprocess_abs :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      (Pulse_Syntax_Base.st_term, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun t ->
      FStar_Tactics_Effect.tac_bind
        (FStar_Sealed.seal
           (Obj.magic
              (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                 (Prims.of_int (160)) (Prims.of_int (16))
                 (Prims.of_int (160)) (Prims.of_int (32)))))
        (FStar_Sealed.seal
           (Obj.magic
              (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                 (Prims.of_int (161)) (Prims.of_int (4)) (Prims.of_int (171))
                 (Prims.of_int (51))))) (Obj.magic (arrow_of_abs g t))
        (fun uu___ ->
           (fun annot ->
              Obj.magic
                (FStar_Tactics_Effect.tac_bind
                   (FStar_Sealed.seal
                      (Obj.magic
                         (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                            (Prims.of_int (161)) (Prims.of_int (4))
                            (Prims.of_int (161)) (Prims.of_int (88)))))
                   (FStar_Sealed.seal
                      (Obj.magic
                         (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                            (Prims.of_int (161)) (Prims.of_int (89))
                            (Prims.of_int (171)) (Prims.of_int (51)))))
                   (Obj.magic
                      (debug_abs g
                         (fun uu___ ->
                            FStar_Tactics_Effect.tac_bind
                              (FStar_Sealed.seal
                                 (Obj.magic
                                    (FStar_Range.mk_range
                                       "Pulse.Checker.Abs.fst"
                                       (Prims.of_int (161))
                                       (Prims.of_int (63))
                                       (Prims.of_int (161))
                                       (Prims.of_int (87)))))
                              (FStar_Sealed.seal
                                 (Obj.magic
                                    (FStar_Range.mk_range "prims.fst"
                                       (Prims.of_int (590))
                                       (Prims.of_int (19))
                                       (Prims.of_int (590))
                                       (Prims.of_int (31)))))
                              (Obj.magic
                                 (Pulse_Syntax_Printer.term_to_string annot))
                              (fun uu___1 ->
                                 FStar_Tactics_Effect.lift_div_tac
                                   (fun uu___2 ->
                                      Prims.strcat "arrow_of_abs = "
                                        (Prims.strcat uu___1 "\n"))))))
                   (fun uu___ ->
                      (fun uu___ ->
                         Obj.magic
                           (FStar_Tactics_Effect.tac_bind
                              (FStar_Sealed.seal
                                 (Obj.magic
                                    (FStar_Range.mk_range
                                       "Pulse.Checker.Abs.fst"
                                       (Prims.of_int (162))
                                       (Prims.of_int (19))
                                       (Prims.of_int (162))
                                       (Prims.of_int (72)))))
                              (FStar_Sealed.seal
                                 (Obj.magic
                                    (FStar_Range.mk_range
                                       "Pulse.Checker.Abs.fst"
                                       (Prims.of_int (161))
                                       (Prims.of_int (89))
                                       (Prims.of_int (171))
                                       (Prims.of_int (51)))))
                              (Obj.magic
                                 (Pulse_Checker_Pure.instantiate_term_implicits
                                    g annot))
                              (fun uu___1 ->
                                 (fun uu___1 ->
                                    match uu___1 with
                                    | (annot1, uu___2) ->
                                        (match annot1.Pulse_Syntax_Base.t
                                         with
                                         | Pulse_Syntax_Base.Tm_FStar annot2
                                             ->
                                             Obj.magic
                                               (FStar_Tactics_Effect.tac_bind
                                                  (FStar_Sealed.seal
                                                     (Obj.magic
                                                        (FStar_Range.mk_range
                                                           "Pulse.Checker.Abs.fst"
                                                           (Prims.of_int (165))
                                                           (Prims.of_int (16))
                                                           (Prims.of_int (165))
                                                           (Prims.of_int (37)))))
                                                  (FStar_Sealed.seal
                                                     (Obj.magic
                                                        (FStar_Range.mk_range
                                                           "Pulse.Checker.Abs.fst"
                                                           (Prims.of_int (166))
                                                           (Prims.of_int (6))
                                                           (Prims.of_int (167))
                                                           (Prims.of_int (9)))))
                                                  (Obj.magic
                                                     (rebuild_abs g t annot2))
                                                  (fun uu___3 ->
                                                     (fun abs ->
                                                        Obj.magic
                                                          (FStar_Tactics_Effect.tac_bind
                                                             (FStar_Sealed.seal
                                                                (Obj.magic
                                                                   (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (166))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (166))
                                                                    (Prims.of_int (90)))))
                                                             (FStar_Sealed.seal
                                                                (Obj.magic
                                                                   (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (165))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (165))
                                                                    (Prims.of_int (13)))))
                                                             (Obj.magic
                                                                (debug_abs g
                                                                   (fun
                                                                    uu___3 ->
                                                                    FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (166))
                                                                    (Prims.of_int (64))
                                                                    (Prims.of_int (166))
                                                                    (Prims.of_int (89)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "prims.fst"
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (31)))))
                                                                    (Obj.magic
                                                                    (Pulse_Syntax_Printer.st_term_to_string
                                                                    abs))
                                                                    (fun
                                                                    uu___4 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___5 ->
                                                                    Prims.strcat
                                                                    "rebuild_abs = "
                                                                    (Prims.strcat
                                                                    uu___4
                                                                    "\n"))))))
                                                             (fun uu___3 ->
                                                                FStar_Tactics_Effect.lift_div_tac
                                                                  (fun uu___4
                                                                    -> abs))))
                                                       uu___3))
                                         | uu___3 ->
                                             Obj.magic
                                               (FStar_Tactics_Effect.tac_bind
                                                  (FStar_Sealed.seal
                                                     (Obj.magic
                                                        (FStar_Range.mk_range
                                                           "Pulse.Checker.Abs.fst"
                                                           (Prims.of_int (170))
                                                           (Prims.of_int (17))
                                                           (Prims.of_int (171))
                                                           (Prims.of_int (51)))))
                                                  (FStar_Sealed.seal
                                                     (Obj.magic
                                                        (FStar_Range.mk_range
                                                           "Pulse.Checker.Abs.fst"
                                                           (Prims.of_int (169))
                                                           (Prims.of_int (6))
                                                           (Prims.of_int (171))
                                                           (Prims.of_int (51)))))
                                                  (Obj.magic
                                                     (FStar_Tactics_Effect.tac_bind
                                                        (FStar_Sealed.seal
                                                           (Obj.magic
                                                              (FStar_Range.mk_range
                                                                 "Pulse.Checker.Abs.fst"
                                                                 (Prims.of_int (171))
                                                                 (Prims.of_int (26))
                                                                 (Prims.of_int (171))
                                                                 (Prims.of_int (50)))))
                                                        (FStar_Sealed.seal
                                                           (Obj.magic
                                                              (FStar_Range.mk_range
                                                                 "prims.fst"
                                                                 (Prims.of_int (590))
                                                                 (Prims.of_int (19))
                                                                 (Prims.of_int (590))
                                                                 (Prims.of_int (31)))))
                                                        (Obj.magic
                                                           (Pulse_Syntax_Printer.term_to_string
                                                              annot1))
                                                        (fun uu___4 ->
                                                           FStar_Tactics_Effect.lift_div_tac
                                                             (fun uu___5 ->
                                                                Prims.strcat
                                                                  "Expected an arrow type as an annotation, got "
                                                                  (Prims.strcat
                                                                    uu___4 "")))))
                                                  (fun uu___4 ->
                                                     (fun uu___4 ->
                                                        Obj.magic
                                                          (Pulse_Typing_Env.fail
                                                             g
                                                             (FStar_Pervasives_Native.Some
                                                                (t.Pulse_Syntax_Base.range2))
                                                             uu___4)) uu___4))))
                                   uu___1))) uu___))) uu___)
let (check_effect_annotation :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.range ->
      Pulse_Syntax_Base.comp_ascription FStar_Pervasives_Native.option ->
        Pulse_Syntax_Base.comp -> (unit, unit) FStar_Tactics_Effect.tac_repr)
  =
  fun uu___3 ->
    fun uu___2 ->
      fun uu___1 ->
        fun uu___ ->
          (fun g ->
             fun r ->
               fun c_annot ->
                 fun c_computed ->
                   match c_annot with
                   | FStar_Pervasives_Native.None ->
                       Obj.magic
                         (Obj.repr
                            (FStar_Tactics_Effect.lift_div_tac
                               (fun uu___ -> ())))
                   | FStar_Pervasives_Native.Some
                       { Pulse_Syntax_Base.annotated = uu___;
                         Pulse_Syntax_Base.elaborated = c_annot1;_}
                       ->
                       Obj.magic
                         (Obj.repr
                            (match (c_annot1, c_computed) with
                             | (Pulse_Syntax_Base.C_Tot uu___1,
                                Pulse_Syntax_Base.C_Tot uu___2) ->
                                 Obj.repr
                                   (FStar_Tactics_Effect.lift_div_tac
                                      (fun uu___3 -> ()))
                             | (Pulse_Syntax_Base.C_ST uu___1,
                                Pulse_Syntax_Base.C_ST uu___2) ->
                                 Obj.repr
                                   (FStar_Tactics_Effect.lift_div_tac
                                      (fun uu___3 -> ()))
                             | (Pulse_Syntax_Base.C_STAtomic (i, uu___1),
                                Pulse_Syntax_Base.C_STAtomic (j, uu___2)) ->
                                 Obj.repr
                                   (if Pulse_Syntax_Base.eq_tm i j
                                    then
                                      Obj.repr
                                        (FStar_Tactics_Effect.lift_div_tac
                                           (fun uu___3 -> ()))
                                    else
                                      Obj.repr
                                        (FStar_Tactics_Effect.tac_bind
                                           (FStar_Sealed.seal
                                              (Obj.magic
                                                 (FStar_Range.mk_range
                                                    "Pulse.Checker.Abs.fst"
                                                    (Prims.of_int (185))
                                                    (Prims.of_int (18))
                                                    (Prims.of_int (187))
                                                    (Prims.of_int (41)))))
                                           (FStar_Sealed.seal
                                              (Obj.magic
                                                 (FStar_Range.mk_range
                                                    "Pulse.Checker.Abs.fst"
                                                    (Prims.of_int (184))
                                                    (Prims.of_int (11))
                                                    (Prims.of_int (187))
                                                    (Prims.of_int (41)))))
                                           (Obj.magic
                                              (FStar_Tactics_Effect.tac_bind
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Abs.fst"
                                                          (Prims.of_int (187))
                                                          (Prims.of_int (20))
                                                          (Prims.of_int (187))
                                                          (Prims.of_int (40)))))
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Abs.fst"
                                                          (Prims.of_int (185))
                                                          (Prims.of_int (18))
                                                          (Prims.of_int (187))
                                                          (Prims.of_int (41)))))
                                                 (Obj.magic
                                                    (Pulse_Syntax_Printer.term_to_string
                                                       j))
                                                 (fun uu___4 ->
                                                    (fun uu___4 ->
                                                       Obj.magic
                                                         (FStar_Tactics_Effect.tac_bind
                                                            (FStar_Sealed.seal
                                                               (Obj.magic
                                                                  (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (185))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (187))
                                                                    (Prims.of_int (41)))))
                                                            (FStar_Sealed.seal
                                                               (Obj.magic
                                                                  (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (185))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (187))
                                                                    (Prims.of_int (41)))))
                                                            (Obj.magic
                                                               (FStar_Tactics_Effect.tac_bind
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (186))
                                                                    (Prims.of_int (20))
                                                                    (Prims.of_int (186))
                                                                    (Prims.of_int (40)))))
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "FStar.Printf.fst"
                                                                    (Prims.of_int (121))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (123))
                                                                    (Prims.of_int (44)))))
                                                                  (Obj.magic
                                                                    (Pulse_Syntax_Printer.term_to_string
                                                                    i))
                                                                  (fun uu___5
                                                                    ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___6 ->
                                                                    fun x ->
                                                                    Prims.strcat
                                                                    (Prims.strcat
                                                                    "Annotated effect expects only invariants in "
                                                                    (Prims.strcat
                                                                    uu___5
                                                                    " to be opened; but computed effect claims that invariants "))
                                                                    (Prims.strcat
                                                                    x
                                                                    " are opened")))))
                                                            (fun uu___5 ->
                                                               FStar_Tactics_Effect.lift_div_tac
                                                                 (fun uu___6
                                                                    ->
                                                                    uu___5
                                                                    uu___4))))
                                                      uu___4)))
                                           (fun uu___4 ->
                                              (fun uu___4 ->
                                                 Obj.magic
                                                   (Pulse_Typing_Env.fail g
                                                      (FStar_Pervasives_Native.Some
                                                         (i.Pulse_Syntax_Base.range1))
                                                      uu___4)) uu___4)))
                             | (Pulse_Syntax_Base.C_STGhost (i, uu___1),
                                Pulse_Syntax_Base.C_STGhost (j, uu___2)) ->
                                 Obj.repr
                                   (if Pulse_Syntax_Base.eq_tm i j
                                    then
                                      Obj.repr
                                        (FStar_Tactics_Effect.lift_div_tac
                                           (fun uu___3 -> ()))
                                    else
                                      Obj.repr
                                        (FStar_Tactics_Effect.tac_bind
                                           (FStar_Sealed.seal
                                              (Obj.magic
                                                 (FStar_Range.mk_range
                                                    "Pulse.Checker.Abs.fst"
                                                    (Prims.of_int (185))
                                                    (Prims.of_int (18))
                                                    (Prims.of_int (187))
                                                    (Prims.of_int (41)))))
                                           (FStar_Sealed.seal
                                              (Obj.magic
                                                 (FStar_Range.mk_range
                                                    "Pulse.Checker.Abs.fst"
                                                    (Prims.of_int (184))
                                                    (Prims.of_int (11))
                                                    (Prims.of_int (187))
                                                    (Prims.of_int (41)))))
                                           (Obj.magic
                                              (FStar_Tactics_Effect.tac_bind
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Abs.fst"
                                                          (Prims.of_int (187))
                                                          (Prims.of_int (20))
                                                          (Prims.of_int (187))
                                                          (Prims.of_int (40)))))
                                                 (FStar_Sealed.seal
                                                    (Obj.magic
                                                       (FStar_Range.mk_range
                                                          "Pulse.Checker.Abs.fst"
                                                          (Prims.of_int (185))
                                                          (Prims.of_int (18))
                                                          (Prims.of_int (187))
                                                          (Prims.of_int (41)))))
                                                 (Obj.magic
                                                    (Pulse_Syntax_Printer.term_to_string
                                                       j))
                                                 (fun uu___4 ->
                                                    (fun uu___4 ->
                                                       Obj.magic
                                                         (FStar_Tactics_Effect.tac_bind
                                                            (FStar_Sealed.seal
                                                               (Obj.magic
                                                                  (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (185))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (187))
                                                                    (Prims.of_int (41)))))
                                                            (FStar_Sealed.seal
                                                               (Obj.magic
                                                                  (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (185))
                                                                    (Prims.of_int (18))
                                                                    (Prims.of_int (187))
                                                                    (Prims.of_int (41)))))
                                                            (Obj.magic
                                                               (FStar_Tactics_Effect.tac_bind
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (186))
                                                                    (Prims.of_int (20))
                                                                    (Prims.of_int (186))
                                                                    (Prims.of_int (40)))))
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "FStar.Printf.fst"
                                                                    (Prims.of_int (121))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (123))
                                                                    (Prims.of_int (44)))))
                                                                  (Obj.magic
                                                                    (Pulse_Syntax_Printer.term_to_string
                                                                    i))
                                                                  (fun uu___5
                                                                    ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___6 ->
                                                                    fun x ->
                                                                    Prims.strcat
                                                                    (Prims.strcat
                                                                    "Annotated effect expects only invariants in "
                                                                    (Prims.strcat
                                                                    uu___5
                                                                    " to be opened; but computed effect claims that invariants "))
                                                                    (Prims.strcat
                                                                    x
                                                                    " are opened")))))
                                                            (fun uu___5 ->
                                                               FStar_Tactics_Effect.lift_div_tac
                                                                 (fun uu___6
                                                                    ->
                                                                    uu___5
                                                                    uu___4))))
                                                      uu___4)))
                                           (fun uu___4 ->
                                              (fun uu___4 ->
                                                 Obj.magic
                                                   (Pulse_Typing_Env.fail g
                                                      (FStar_Pervasives_Native.Some
                                                         (i.Pulse_Syntax_Base.range1))
                                                      uu___4)) uu___4)))
                             | (uu___1, uu___2) ->
                                 Obj.repr
                                   (FStar_Tactics_Effect.tac_bind
                                      (FStar_Sealed.seal
                                         (Obj.magic
                                            (FStar_Range.mk_range
                                               "Pulse.Checker.Abs.fst"
                                               (Prims.of_int (190))
                                               (Prims.of_int (12))
                                               (Prims.of_int (192))
                                               (Prims.of_int (47)))))
                                      (FStar_Sealed.seal
                                         (Obj.magic
                                            (FStar_Range.mk_range
                                               "Pulse.Checker.Abs.fst"
                                               (Prims.of_int (189))
                                               (Prims.of_int (6))
                                               (Prims.of_int (192))
                                               (Prims.of_int (47)))))
                                      (Obj.magic
                                         (FStar_Tactics_Effect.tac_bind
                                            (FStar_Sealed.seal
                                               (Obj.magic
                                                  (FStar_Range.mk_range
                                                     "Pulse.Checker.Abs.fst"
                                                     (Prims.of_int (192))
                                                     (Prims.of_int (20))
                                                     (Prims.of_int (192))
                                                     (Prims.of_int (46)))))
                                            (FStar_Sealed.seal
                                               (Obj.magic
                                                  (FStar_Range.mk_range
                                                     "Pulse.Checker.Abs.fst"
                                                     (Prims.of_int (190))
                                                     (Prims.of_int (12))
                                                     (Prims.of_int (192))
                                                     (Prims.of_int (47)))))
                                            (Obj.magic
                                               (Pulse_Syntax_Printer.tag_of_comp
                                                  c_computed))
                                            (fun uu___3 ->
                                               (fun uu___3 ->
                                                  Obj.magic
                                                    (FStar_Tactics_Effect.tac_bind
                                                       (FStar_Sealed.seal
                                                          (Obj.magic
                                                             (FStar_Range.mk_range
                                                                "Pulse.Checker.Abs.fst"
                                                                (Prims.of_int (190))
                                                                (Prims.of_int (12))
                                                                (Prims.of_int (192))
                                                                (Prims.of_int (47)))))
                                                       (FStar_Sealed.seal
                                                          (Obj.magic
                                                             (FStar_Range.mk_range
                                                                "Pulse.Checker.Abs.fst"
                                                                (Prims.of_int (190))
                                                                (Prims.of_int (12))
                                                                (Prims.of_int (192))
                                                                (Prims.of_int (47)))))
                                                       (Obj.magic
                                                          (FStar_Tactics_Effect.tac_bind
                                                             (FStar_Sealed.seal
                                                                (Obj.magic
                                                                   (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (191))
                                                                    (Prims.of_int (20))
                                                                    (Prims.of_int (191))
                                                                    (Prims.of_int (43)))))
                                                             (FStar_Sealed.seal
                                                                (Obj.magic
                                                                   (FStar_Range.mk_range
                                                                    "FStar.Printf.fst"
                                                                    (Prims.of_int (121))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (123))
                                                                    (Prims.of_int (44)))))
                                                             (Obj.magic
                                                                (Pulse_Syntax_Printer.tag_of_comp
                                                                   c_annot1))
                                                             (fun uu___4 ->
                                                                FStar_Tactics_Effect.lift_div_tac
                                                                  (fun uu___5
                                                                    ->
                                                                    fun x ->
                                                                    Prims.strcat
                                                                    (Prims.strcat
                                                                    "Expected effect "
                                                                    (Prims.strcat
                                                                    uu___4
                                                                    " but this function body has effect "))
                                                                    (Prims.strcat
                                                                    x "")))))
                                                       (fun uu___4 ->
                                                          FStar_Tactics_Effect.lift_div_tac
                                                            (fun uu___5 ->
                                                               uu___4 uu___3))))
                                                 uu___3)))
                                      (fun uu___3 ->
                                         (fun uu___3 ->
                                            Obj.magic
                                              (Pulse_Typing_Env.fail g
                                                 (FStar_Pervasives_Native.Some
                                                    r) uu___3)) uu___3)))))
            uu___3 uu___2 uu___1 uu___
let rec (check_abs_core :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Checker_Base.check_t ->
        ((Pulse_Syntax_Base.st_term, Pulse_Syntax_Base.comp,
           (unit, unit, unit) Pulse_Typing.st_typing)
           FStar_Pervasives.dtuple3,
          unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun t ->
      fun check ->
        FStar_Tactics_Effect.tac_bind
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                   (Prims.of_int (201)) (Prims.of_int (14))
                   (Prims.of_int (201)) (Prims.of_int (21)))))
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                   (Prims.of_int (202)) (Prims.of_int (2))
                   (Prims.of_int (273)) (Prims.of_int (29)))))
          (FStar_Tactics_Effect.lift_div_tac
             (fun uu___ -> t.Pulse_Syntax_Base.range2))
          (fun uu___ ->
             (fun range ->
                match t.Pulse_Syntax_Base.term1 with
                | Pulse_Syntax_Base.Tm_Abs
                    {
                      Pulse_Syntax_Base.b =
                        { Pulse_Syntax_Base.binder_ty = t1;
                          Pulse_Syntax_Base.binder_ppname = ppname;_};
                      Pulse_Syntax_Base.q = qual;
                      Pulse_Syntax_Base.ascription = c;
                      Pulse_Syntax_Base.body = body;_}
                    ->
                    Obj.magic
                      (FStar_Tactics_Effect.tac_bind
                         (FStar_Sealed.seal
                            (Obj.magic
                               (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                  (Prims.of_int (206)) (Prims.of_int (24))
                                  (Prims.of_int (206)) (Prims.of_int (42)))))
                         (FStar_Sealed.seal
                            (Obj.magic
                               (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                                  (Prims.of_int (203)) (Prims.of_int (84))
                                  (Prims.of_int (273)) (Prims.of_int (29)))))
                         (Obj.magic (Pulse_Checker_Pure.check_tot_term g t1))
                         (fun uu___ ->
                            (fun uu___ ->
                               match uu___ with
                               | FStar_Pervasives.Mkdtuple3
                                   (t2, uu___1, uu___2) ->
                                   Obj.magic
                                     (FStar_Tactics_Effect.tac_bind
                                        (FStar_Sealed.seal
                                           (Obj.magic
                                              (FStar_Range.mk_range
                                                 "Pulse.Checker.Abs.fst"
                                                 (Prims.of_int (207))
                                                 (Prims.of_int (28))
                                                 (Prims.of_int (207))
                                                 (Prims.of_int (46)))))
                                        (FStar_Sealed.seal
                                           (Obj.magic
                                              (FStar_Range.mk_range
                                                 "Pulse.Checker.Abs.fst"
                                                 (Prims.of_int (206))
                                                 (Prims.of_int (45))
                                                 (Prims.of_int (273))
                                                 (Prims.of_int (29)))))
                                        (Obj.magic
                                           (Pulse_Checker_Pure.check_universe
                                              g t2))
                                        (fun uu___3 ->
                                           (fun uu___3 ->
                                              match uu___3 with
                                              | Prims.Mkdtuple2 (u, t_typing)
                                                  ->
                                                  Obj.magic
                                                    (FStar_Tactics_Effect.tac_bind
                                                       (FStar_Sealed.seal
                                                          (Obj.magic
                                                             (FStar_Range.mk_range
                                                                "Pulse.Checker.Abs.fst"
                                                                (Prims.of_int (208))
                                                                (Prims.of_int (12))
                                                                (Prims.of_int (208))
                                                                (Prims.of_int (19)))))
                                                       (FStar_Sealed.seal
                                                          (Obj.magic
                                                             (FStar_Range.mk_range
                                                                "Pulse.Checker.Abs.fst"
                                                                (Prims.of_int (208))
                                                                (Prims.of_int (22))
                                                                (Prims.of_int (273))
                                                                (Prims.of_int (29)))))
                                                       (FStar_Tactics_Effect.lift_div_tac
                                                          (fun uu___4 ->
                                                             Pulse_Typing_Env.fresh
                                                               g))
                                                       (fun uu___4 ->
                                                          (fun x ->
                                                             Obj.magic
                                                               (FStar_Tactics_Effect.tac_bind
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (209))
                                                                    (Prims.of_int (13))
                                                                    (Prims.of_int (209))
                                                                    (Prims.of_int (22)))))
                                                                  (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (209))
                                                                    (Prims.of_int (25))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                  (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___4 ->
                                                                    (ppname,
                                                                    x)))
                                                                  (fun uu___4
                                                                    ->
                                                                    (fun px
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (210))
                                                                    (Prims.of_int (14))
                                                                    (Prims.of_int (210))
                                                                    (Prims.of_int (50)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (210))
                                                                    (Prims.of_int (53))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___4 ->
                                                                    Pulse_Syntax_Pure.tm_var
                                                                    {
                                                                    Pulse_Syntax_Base.nm_index
                                                                    = x;
                                                                    Pulse_Syntax_Base.nm_ppname
                                                                    = ppname
                                                                    }))
                                                                    (fun
                                                                    uu___4 ->
                                                                    (fun var
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (211))
                                                                    (Prims.of_int (13))
                                                                    (Prims.of_int (211))
                                                                    (Prims.of_int (38)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (211))
                                                                    (Prims.of_int (41))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___4 ->
                                                                    Pulse_Typing_Env.push_binding
                                                                    g x
                                                                    ppname t2))
                                                                    (fun
                                                                    uu___4 ->
                                                                    (fun g'
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (212))
                                                                    (Prims.of_int (22))
                                                                    (Prims.of_int (212))
                                                                    (Prims.of_int (45)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (213))
                                                                    (Prims.of_int (4))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___4 ->
                                                                    Pulse_Syntax_Naming.open_st_term_nv
                                                                    body px))
                                                                    (fun
                                                                    uu___4 ->
                                                                    (fun
                                                                    body_opened
                                                                    ->
                                                                    match 
                                                                    body_opened.Pulse_Syntax_Base.term1
                                                                    with
                                                                    | 
                                                                    Pulse_Syntax_Base.Tm_Abs
                                                                    uu___4 ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (215))
                                                                    (Prims.of_int (44))
                                                                    (Prims.of_int (215))
                                                                    (Prims.of_int (79)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (214))
                                                                    (Prims.of_int (17))
                                                                    (Prims.of_int (223))
                                                                    (Prims.of_int (29)))))
                                                                    (Obj.magic
                                                                    (check_abs_core
                                                                    g'
                                                                    body_opened
                                                                    check))
                                                                    (fun
                                                                    uu___5 ->
                                                                    (fun
                                                                    uu___5 ->
                                                                    match uu___5
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    (body1,
                                                                    c_body,
                                                                    body_typing)
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (216))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (216))
                                                                    (Prims.of_int (52)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (223))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (223))
                                                                    (Prims.of_int (29)))))
                                                                    (Obj.magic
                                                                    (check_effect_annotation
                                                                    g'
                                                                    body1.Pulse_Syntax_Base.range2
                                                                    c c_body))
                                                                    (fun
                                                                    uu___6 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___7 ->
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    ((Pulse_Typing.wtag
                                                                    FStar_Pervasives_Native.None
                                                                    (Pulse_Syntax_Base.Tm_Abs
                                                                    {
                                                                    Pulse_Syntax_Base.b
                                                                    =
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = t2;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    = ppname
                                                                    };
                                                                    Pulse_Syntax_Base.q
                                                                    = qual;
                                                                    Pulse_Syntax_Base.ascription
                                                                    =
                                                                    FStar_Pervasives_Native.None;
                                                                    Pulse_Syntax_Base.body
                                                                    =
                                                                    (Pulse_Syntax_Naming.close_st_term
                                                                    body1 x)
                                                                    })),
                                                                    (Pulse_Syntax_Base.C_Tot
                                                                    (Pulse_Syntax_Pure.tm_arrow
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = t2;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    = ppname
                                                                    } qual
                                                                    (Pulse_Syntax_Naming.close_comp
                                                                    c_body x))),
                                                                    (Pulse_Typing.T_Abs
                                                                    (g, x,
                                                                    qual,
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = t2;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    = ppname
                                                                    }, u,
                                                                    (Pulse_Syntax_Naming.close_st_term
                                                                    body1 x),
                                                                    c_body,
                                                                    (),
                                                                    body_typing)))))))
                                                                    uu___5))
                                                                    | 
                                                                    uu___4 ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (226))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (241))
                                                                    (Prims.of_int (47)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (224))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (match c
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (Pulse_Typing_Env.fail
                                                                    g
                                                                    (FStar_Pervasives_Native.Some
                                                                    (body.Pulse_Syntax_Base.range2))
                                                                    "Missing annotation on a function body"))
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    {
                                                                    Pulse_Syntax_Base.annotated
                                                                    = uu___5;
                                                                    Pulse_Syntax_Base.elaborated
                                                                    =
                                                                    Pulse_Syntax_Base.C_Tot
                                                                    r;_} ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (233))
                                                                    (Prims.of_int (12))
                                                                    (Prims.of_int (235))
                                                                    (Prims.of_int (43)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (232))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (235))
                                                                    (Prims.of_int (43)))))
                                                                    (Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (235))
                                                                    (Prims.of_int (14))
                                                                    (Prims.of_int (235))
                                                                    (Prims.of_int (42)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "prims.fst"
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (590))
                                                                    (Prims.of_int (31)))))
                                                                    (Obj.magic
                                                                    (Pulse_Syntax_Printer.comp_to_string
                                                                    (Pulse_Syntax_Base.C_Tot
                                                                    r)))
                                                                    (fun
                                                                    uu___6 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___7 ->
                                                                    Prims.strcat
                                                                    "Incorrect annotation on a function body: "
                                                                    (Prims.strcat
                                                                    uu___6 "")))))
                                                                    (fun
                                                                    uu___6 ->
                                                                    (fun
                                                                    uu___6 ->
                                                                    Obj.magic
                                                                    (Pulse_Typing_Env.fail
                                                                    g
                                                                    (FStar_Pervasives_Native.Some
                                                                    (body.Pulse_Syntax_Base.range2))
                                                                    uu___6))
                                                                    uu___6)))
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    {
                                                                    Pulse_Syntax_Base.annotated
                                                                    = uu___5;
                                                                    Pulse_Syntax_Base.elaborated
                                                                    = c1;_}
                                                                    ->
                                                                    Obj.magic
                                                                    (Obj.repr
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___6 ->
                                                                    (c1,
                                                                    (Pulse_Syntax_Naming.open_term_nv
                                                                    (Pulse_Syntax_Base.comp_pre
                                                                    c1) px),
                                                                    (FStar_Pervasives_Native.Some
                                                                    (Pulse_Syntax_Naming.open_term_nv
                                                                    (Pulse_Syntax_Base.comp_res
                                                                    c1) px)),
                                                                    (FStar_Pervasives_Native.Some
                                                                    (Pulse_Syntax_Naming.open_term'
                                                                    (Pulse_Syntax_Base.comp_post
                                                                    c1) var
                                                                    Prims.int_one)))))))
                                                                    (fun
                                                                    uu___5 ->
                                                                    (fun
                                                                    uu___5 ->
                                                                    match uu___5
                                                                    with
                                                                    | 
                                                                    (elab_c,
                                                                    pre_opened,
                                                                    ret_ty,
                                                                    post_hint_body)
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (243))
                                                                    (Prims.of_int (41))
                                                                    (Prims.of_int (243))
                                                                    (Prims.of_int (66)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (242))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (Obj.magic
                                                                    (Pulse_Checker_Pure.check_vprop
                                                                    g'
                                                                    pre_opened))
                                                                    (fun
                                                                    uu___6 ->
                                                                    (fun
                                                                    uu___6 ->
                                                                    match uu___6
                                                                    with
                                                                    | 
                                                                    Prims.Mkdtuple2
                                                                    (pre_opened1,
                                                                    pre_typing)
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (244))
                                                                    (Prims.of_int (16))
                                                                    (Prims.of_int (244))
                                                                    (Prims.of_int (39)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (244))
                                                                    (Prims.of_int (42))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___7 ->
                                                                    Pulse_Syntax_Naming.close_term
                                                                    pre_opened1
                                                                    x))
                                                                    (fun
                                                                    uu___7 ->
                                                                    (fun pre
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (246))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (257))
                                                                    (Prims.of_int (31)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (258))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (match post_hint_body
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives_Native.None
                                                                    ->
                                                                    Obj.magic
                                                                    (Pulse_Typing_Env.fail
                                                                    g
                                                                    (FStar_Pervasives_Native.Some
                                                                    (body.Pulse_Syntax_Base.range2))
                                                                    "Top-level functions must be annotated with pre and post conditions")
                                                                    | 
                                                                    FStar_Pervasives_Native.Some
                                                                    post ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (251))
                                                                    (Prims.of_int (14))
                                                                    (Prims.of_int (255))
                                                                    (Prims.of_int (22)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (257))
                                                                    (Prims.of_int (10))
                                                                    (Prims.of_int (257))
                                                                    (Prims.of_int (31)))))
                                                                    (Obj.magic
                                                                    (Pulse_Checker_Base.intro_post_hint
                                                                    (Pulse_Checker_Pure.push_context
                                                                    "post_hint_typing"
                                                                    range g')
                                                                    (FStar_Pervasives_Native.Some
                                                                    (Pulse_Syntax_Base.ctag_of_comp_st
                                                                    elab_c))
                                                                    ret_ty
                                                                    post))
                                                                    (fun
                                                                    post_hint_typing
                                                                    ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___7 ->
                                                                    FStar_Pervasives_Native.Some
                                                                    post_hint_typing))))
                                                                    (fun
                                                                    uu___7 ->
                                                                    (fun post
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (260))
                                                                    (Prims.of_int (19))
                                                                    (Prims.of_int (260))
                                                                    (Prims.of_int (45)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (260))
                                                                    (Prims.of_int (48))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___7 ->
                                                                    Pulse_Syntax_Base.mk_ppname_no_range
                                                                    "_fret"))
                                                                    (fun
                                                                    uu___7 ->
                                                                    (fun
                                                                    ppname1
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (261))
                                                                    (Prims.of_int (15))
                                                                    (Prims.of_int (261))
                                                                    (Prims.of_int (69)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (261))
                                                                    (Prims.of_int (73))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (Obj.magic
                                                                    (check g'
                                                                    pre_opened1
                                                                    () post
                                                                    ppname1
                                                                    body_opened))
                                                                    (fun
                                                                    uu___7 ->
                                                                    (fun r ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (263))
                                                                    (Prims.of_int (8))
                                                                    (Prims.of_int (263))
                                                                    (Prims.of_int (61)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (261))
                                                                    (Prims.of_int (73))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (Obj.magic
                                                                    (Pulse_Checker_Base.apply_checker_result_k
                                                                    g'
                                                                    pre_opened1
                                                                    (FStar_Pervasives_Native.__proj__Some__item__v
                                                                    post) r
                                                                    ppname1))
                                                                    (fun
                                                                    uu___7 ->
                                                                    (fun
                                                                    uu___7 ->
                                                                    match uu___7
                                                                    with
                                                                    | 
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    (body1,
                                                                    c_body,
                                                                    body_typing)
                                                                    ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (265))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (265))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___8 ->
                                                                    uu___7))
                                                                    (fun
                                                                    uu___8 ->
                                                                    (fun
                                                                    uu___8 ->
                                                                    Obj.magic
                                                                    (FStar_Tactics_Effect.tac_bind
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (265))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (265))
                                                                    (Prims.of_int (52)))))
                                                                    (FStar_Sealed.seal
                                                                    (Obj.magic
                                                                    (FStar_Range.mk_range
                                                                    "Pulse.Checker.Abs.fst"
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (6))
                                                                    (Prims.of_int (273))
                                                                    (Prims.of_int (29)))))
                                                                    (Obj.magic
                                                                    (check_effect_annotation
                                                                    g'
                                                                    body1.Pulse_Syntax_Base.range2
                                                                    c c_body))
                                                                    (fun
                                                                    uu___9 ->
                                                                    FStar_Tactics_Effect.lift_div_tac
                                                                    (fun
                                                                    uu___10
                                                                    ->
                                                                    FStar_Pervasives.Mkdtuple3
                                                                    ((Pulse_Typing.wtag
                                                                    FStar_Pervasives_Native.None
                                                                    (Pulse_Syntax_Base.Tm_Abs
                                                                    {
                                                                    Pulse_Syntax_Base.b
                                                                    =
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = t2;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    = ppname1
                                                                    };
                                                                    Pulse_Syntax_Base.q
                                                                    = qual;
                                                                    Pulse_Syntax_Base.ascription
                                                                    =
                                                                    FStar_Pervasives_Native.None;
                                                                    Pulse_Syntax_Base.body
                                                                    =
                                                                    (Pulse_Syntax_Naming.close_st_term
                                                                    body1 x)
                                                                    })),
                                                                    (Pulse_Syntax_Base.C_Tot
                                                                    (Pulse_Syntax_Pure.tm_arrow
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = t2;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    = ppname1
                                                                    } qual
                                                                    (Pulse_Syntax_Naming.close_comp
                                                                    c_body x))),
                                                                    (Pulse_Typing.T_Abs
                                                                    (g, x,
                                                                    qual,
                                                                    {
                                                                    Pulse_Syntax_Base.binder_ty
                                                                    = t2;
                                                                    Pulse_Syntax_Base.binder_ppname
                                                                    = ppname1
                                                                    }, u,
                                                                    (Pulse_Syntax_Naming.close_st_term
                                                                    body1 x),
                                                                    c_body,
                                                                    (),
                                                                    body_typing)))))))
                                                                    uu___8)))
                                                                    uu___7)))
                                                                    uu___7)))
                                                                    uu___7)))
                                                                    uu___7)))
                                                                    uu___7)))
                                                                    uu___6)))
                                                                    uu___5)))
                                                                    uu___4)))
                                                                    uu___4)))
                                                                    uu___4)))
                                                                    uu___4)))
                                                            uu___4))) uu___3)))
                              uu___))) uu___)
let (check_abs :
  Pulse_Typing_Env.env ->
    Pulse_Syntax_Base.st_term ->
      Pulse_Checker_Base.check_t ->
        ((Pulse_Syntax_Base.st_term, Pulse_Syntax_Base.comp,
           (unit, unit, unit) Pulse_Typing.st_typing)
           FStar_Pervasives.dtuple3,
          unit) FStar_Tactics_Effect.tac_repr)
  =
  fun g ->
    fun t ->
      fun check ->
        FStar_Tactics_Effect.tac_bind
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                   (Prims.of_int (277)) (Prims.of_int (10))
                   (Prims.of_int (277)) (Prims.of_int (28)))))
          (FStar_Sealed.seal
             (Obj.magic
                (FStar_Range.mk_range "Pulse.Checker.Abs.fst"
                   (Prims.of_int (278)) (Prims.of_int (2))
                   (Prims.of_int (278)) (Prims.of_int (26)))))
          (Obj.magic (preprocess_abs g t))
          (fun uu___ ->
             (fun t1 -> Obj.magic (check_abs_core g t1 check)) uu___)