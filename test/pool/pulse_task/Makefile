PULSE_ROOT ?= ../../..
OTHERFLAGS += --include $(PULSE_ROOT)/out/lib/pulse
OTHERFLAGS += --include $(PULSE_ROOT)/share/pulse/examples
OTHERFLAGS += --ext pulse:extract_ocaml_bare
OTHERFLAGS += --cmi

DEPFLAGS += --extract '-*'
DEPFLAGS += --extract +Quicksort
DEPFLAGS += --extract +Pulse.Lib.Task
DEPFLAGS += --extract +FStar.Dyn

CACHE_DIR  := _cache
# Extract directly into the dune tree (no symlinks, for Windows support)
OUTPUT_DIR := dune/output
CODEGEN    := OCaml
SRC        := .
ROOTS      := Quicksort.Task.fst
TAG        := pool

# Copy the shared example into this directory instead of symlinking it,
# so the build works on platforms without symlink support (e.g. Windows).
Quicksort.Task.fst: $(PULSE_ROOT)/share/pulse/examples/Quicksort.Task.fst
	cp -p $< $@

include $(PULSE_ROOT)/mk/boot.mk

# The dependency analysis (and hence extraction) needs the copied root present.
$(DEPSTEM): Quicksort.Task.fst

.DEFAULT_GOAL := all

.PHONY: all
all: test

.PHONY: all_ml
all_ml: $(ALL_ML_FILES)
	# The extraction plugin does get called on names in pattern
	# match branches, so we must replace them explicitly.
	sed -i 's/FStar_Pervasives_Native\.None/None/' $(ALL_ML_FILES)
	sed -i 's/FStar_Pervasives_Native\.Some/Some/' $(ALL_ML_FILES)

.PHONY: dune
dune: all_ml
	opam exec -- dune build --root=dune --no-print-directory

.PHONY: test
test: run

.PHONY: accept
accept:

.PHONY: run
run: dune
	./dune/_build/default/driver.exe

# Here so `make accept` works from the parent dir
accept:
