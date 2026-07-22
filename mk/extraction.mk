TAG := extraction
SRC := src/extraction
CACHE_DIR := build/$(TAG).checked
OUTPUT_DIR := build/$(TAG).ml
CODEGEN := PluginNoLib
ROOTS := $(shell find $(SRC) -name '*.fst' -o -name '*.fsti')
FSTAR_OPTIONS += --with_fstarc
EXTRACT += --extract '-*,+ExtractPulse,+ExtractPulseC,+ExtractPulseOCaml'
FSTAR_OPTIONS += --lax --MLish --MLish_effect FStarC.Effect

DEPFLAGS += --already_cached 'Prims,FStarC'

ifeq (,$(PULSE_ROOT))
PULSE_ROOT := .
endif
include $(PULSE_ROOT)/mk/boot.mk

.DEFAULT_GOAL := ocaml
