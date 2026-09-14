#!/bin/bash
#
# Configure and build g4sipm out-of-tree, with ROOT and SQLite off.
#
# Reads from the environment (see README, "Building with 1_setup.sh"):
#
#   Geant4_DIR    required. The directory containing Geant4Config.cmake.
#                 NOT the same as GEANT4_INSTALL_DIR -- see the README.
#   BOOST_ROOT    optional. Defaults to Homebrew's prefix where available,
#                 otherwise left to CMake's own search.
#   G4SIPM_UIVIS  optional, ON/OFF (default ON). Set OFF for a Geant4 built
#                 without UI/visualisation drivers.
#
# G4SIPM is taken from the environment if set, otherwise derived from this
# script's own location.

: "${G4SIPM:=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export G4SIPM

if [[ -z "${Geant4_DIR:-}" ]]; then
    echo "g4sipm/1_setup: Geant4_DIR is not set." >&2
    echo "  Set it to the directory containing Geant4Config.cmake, e.g." >&2
    echo "    export Geant4_DIR=/path/to/geant4-install/lib/cmake/Geant4" >&2
    echo "  Note this is NOT GEANT4_INSTALL_DIR: that is the install prefix," >&2
    echo "  while Geant4_DIR is the CMake config directory inside it." >&2
    exit 1
fi

cd "$G4SIPM" || exit 1
git submodule update --init || exit 1

mkdir -p "$G4SIPM/build" && cd "$G4SIPM/build" || {
    echo "g4sipm/1_setup: could not create or enter $G4SIPM/build" >&2; exit 1; }

# Boost: prefer an explicit BOOST_ROOT from the environment; else fall back to
# Homebrew's prefix if available (macOS); else let CMake find Boost itself.
_boost_args=()
if [[ -n "${BOOST_ROOT:-}" ]]; then
    _boost_args=(-DBOOST_ROOT="$BOOST_ROOT")
elif _brew_prefix="$(brew --prefix 2>/dev/null)"; then
    _boost_args=(-DBOOST_ROOT="$_brew_prefix")
fi

cmake \
    -DGeant4_DIR="$Geant4_DIR" \
    "${_boost_args[@]}" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DWITH_GEANT4_UIVIS="${G4SIPM_UIVIS:-ON}" \
    -DWITH_ROOT=OFF \
    -DWITH_SQLITE=OFF \
    "$G4SIPM" || exit 1

make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"
