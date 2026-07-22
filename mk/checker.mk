SRC := src/checker/
TAG := checker
CACHE_DIR := build/$(TAG).checked
# Extract directly into the dune plugin tree (no symlinks, for Windows support)
OUTPUT_DIR := build/ocaml/plugin/$(TAG)
CODEGEN := Plugin
ROOTS := $(shell find $(SRC) -name '*.fst' -o -name '*.fsti')
ROOTS += lib/common/Pulse.Lib.Tactics.fsti
# ^ List files with plugins here

FSTAR_OPTIONS += --already_cached 'Prims,FStar'
FSTAR_OPTIONS += --include lib/common
FSTAR_OPTIONS += --smtencoding.elim_box true
FSTAR_OPTIONS += --z3smtopt '(set-option :smt.arith.nl false)'
EXTRACT += --extract '-*,+Pulse,+PulseSyntaxExtension'
DEPFLAGS += --already_cached 'Prims,FStar,FStarC'

ifeq (,$(PULSE_ROOT))
PULSE_ROOT := .
endif
include $(PULSE_ROOT)/mk/boot.mk

.DEFAULT_GOAL := ocaml
