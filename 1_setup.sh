#!/bin/bash
#
# Build g4sipm. Intended to be invoked from G4ScintKit's bash_scripts/1_setup.sh,
# which sources setup_paths.sh first — so Geant4_DIR (and optionally BOOST_ROOT)
# are already exported in the environment.

cd "$G4SIPM" && git submodule update --init

mkdir -p "$G4SIPM/build" && cd "$G4SIPM/build"

# Geant4_DIR is inherited from the environment (resolved by setup_paths.sh).
# Pass it through if set; otherwise fall back to find_package(Geant4) discovery.
_geant4_args=()
if [[ -n "${Geant4_DIR:-}" ]]; then
    _geant4_args=(-DGeant4_DIR="$Geant4_DIR")
fi

# Boost: prefer an explicit BOOST_ROOT from the environment; else fall back to
# Homebrew's prefix if available (macOS); else let CMake find Boost itself.
_boost_args=()
if [[ -n "${BOOST_ROOT:-}" ]]; then
    _boost_args=(-DBOOST_ROOT="$BOOST_ROOT")
elif _brew_prefix="$(brew --prefix 2>/dev/null)"; then
    _boost_args=(-DBOOST_ROOT="$_brew_prefix")
fi

cmake \
    "${_geant4_args[@]}" \
    "${_boost_args[@]}" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DWITH_ROOT=OFF \
    -DWITH_SQLITE=OFF \
    "$G4SIPM"

make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"