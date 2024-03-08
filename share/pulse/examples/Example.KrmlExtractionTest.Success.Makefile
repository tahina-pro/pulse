# This Makefile is only for extraction to C. It assumes everything
# already verified. This separate Makefile is needed because the
# extraction root list needed to compute ALL_KRML_FILES is smaller
# than the verification root list.

PROJECT_NAME=Example.KrmlExtractionTest.Success
FSTAR_DEP_OPTIONS=--extract '* -FStar.Tactics -FStar.Reflection -Pulse -PulseCore +Pulse.Lib -Pulse.Lib.Array.Core -Pulse.Lib.Core -Pulse.Lib.HigherReference -Pulse.Lib.Reference'
include Example.KrmlExtractionTest.Makefile.include
