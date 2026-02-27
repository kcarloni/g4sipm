#!/bin/bash

# G4SIPM="$(cd "$(dirname "$0")" && pwd)"
# GEANT4_INSTALL_DIR="/Users/kiara/home/software/built"

cd "$G4SIPM" && git submodule update --init

mkdir -p "$G4SIPM/build" && cd "$G4SIPM/build"
# if [ -f CMakeCache.txt ]; then rm CMakeCache.txt; fi
cmake \
    -DGeant4_DIR="${GEANT4_INSTALL_DIR}/lib/Geant4-10.6.0" \
    -DBOOST_ROOT="/opt/homebrew" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DWITH_ROOT=OFF \
    -DWITH_SQLITE=OFF \
    "$G4SIPM"

make