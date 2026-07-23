#!/usr/bin/env bash

# Install the Cygwin packages needed to build F*, karamel and Pulse into
# the Cygwin root managed by opam (ocaml/setup-ocaml@v3). Adapted from
# EverParse's src/package/windows/install-cygwin-packages.sh.
#
# The list of packages lives in the `cygwin-packages` file next to this
# script. Set CYGWIN_ROOT to install into a specific root (e.g. opam's
# internal Cygwin) and CYGWIN_MIRROR to pick a mirror.

set -e
set -x

unset CDPATH
cd "$( dirname "${BASH_SOURCE[0]}" )"

cygsetup="setup-x86_64.exe"
cygsetup_args="--no-desktop --no-shortcuts --no-startmenu --wait --quiet-mode"

if [ -n "${CYGWIN_ROOT:-}" ]; then
    cygsetup_args="$cygsetup_args --root $CYGWIN_ROOT"
fi

if [ -n "${CYGWIN_MIRROR:-}" ]; then
    cygsetup_args="$cygsetup_args --only-site --site $CYGWIN_MIRROR"
fi

# Find Cygwin's setup utility, or download it from the internet.
# Success: writes the path to Cygwin's setup in $cygsetup
# Failure: aborts.
found=false
if cygsetup="$(which $cygsetup)" ; then
    found=true
fi

if ! $found ; then
    for s in "$USERPROFILE/Desktop/setup-x86_64.exe" "$USERPROFILE/Downloads/setup-x86_64.exe" "./setup-x86_64.exe" "c:/cygwin64/setup-x86_64.exe" "c:/cygwin/setup-x86_64.exe"; do
	if [ -x "$s" ]; then
	    echo "Found $s"
	    found=true
	    cygsetup="$s"
	fi
    done
fi

if ! $found; then
    echo "Cygwin setup not found, downloading it"
    cygsetup=./setup-x86_64.exe
    curl --output $cygsetup "https://cygwin.com/setup-x86_64.exe"
fi

chmod a+x "$cygsetup"
exec "$cygsetup" $cygsetup_args --packages=$(cat cygwin-packages | tr '\n' ,)
