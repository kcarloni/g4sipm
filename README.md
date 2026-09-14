# Welcome to G4SiPM

[![Docs](https://readthedocs.org/projects/g4sipm/badge/)](http://g4sipm.readthedocs.io/en/latest/index.html)

A Geant4 (https://github.com/Geant4/geant4) simulation toolkit for silicon photomultipliers (SiPMs).

Further information can be found here: http://dx.doi.org/10.1016/j.nima.2015.01.067

The code has been developed to
 * simulate SiPMs in (existing) Geant4 detector simulations
 * provide an easy to setup phenomenological model
 * be driven by input parameters which can be obtained from datasheets or in the laboratory
 * make reliable predictions of the signal of the SiPM over the complete dynamic range
 
Requirements
 * Geant4 (4.10 or newer, https://github.com/Geant4/geant4)
 * Boost (1.50.0 or newer, http://www.boost.org/) — the `date_time`,
   `program_options`, `filesystem` and `regex` components, all required.

Optional
 * Sqlite3 (https://sqlite.org/)
 * ROOT (5.34 or newer, https://root.cern.ch)
 
The build process has been tested with Ubuntu 15.04 and Scientific Linux 6.

## Getting started

Clone the code

    git clone https://github.com/ntim/g4sipm.git source
    cd source

Initialize submodules Googletest and Jansson    
    
    git submodule init
    git submodule update
    
Configure the build with CMake

    cd ../
    mkdir build
    cd build
    cmake ../source
    
Finally, start the build process

    make
    
## Building with `1_setup.sh`

`1_setup.sh` is a convenience wrapper around the steps above: it initialises
the submodules, configures an out-of-tree build in `build/` with ROOT and
SQLite disabled, and runs `make`. It is self-contained — it reads everything
it needs from the environment, and you must set that up **before** running it.

    export Geant4_DIR=/path/to/geant4-install/lib/cmake/Geant4
    ./1_setup.sh

| variable | | meaning |
| --- | --- | --- |
| `Geant4_DIR` | **required** | The directory containing `Geant4Config.cmake`. |
| `BOOST_ROOT` | optional | Boost install prefix. Defaults to Homebrew's prefix where available, otherwise left to CMake's own search. |
| `G4SIPM_UIVIS` | optional | `ON` (default) or `OFF`. Set `OFF` if your Geant4 was built without UI/visualisation drivers, which otherwise fails at `find_package(Geant4 REQUIRED ui_all vis_all)`. |
| `G4SIPM` | optional | This directory. Derived from the script's own location if unset. |

**`Geant4_DIR` is not `GEANT4_INSTALL_DIR`.** This catches people out. The
latter is Geant4's install prefix — the directory holding `bin/`, `lib/` and
`include/`. `Geant4_DIR` is the CMake config directory *inside* it, the one
that actually contains `Geant4Config.cmake`. Exporting only
`GEANT4_INSTALL_DIR` will not work. Depending on how Geant4 was installed it
is usually one of:

    <prefix>/lib/cmake/Geant4          # newer layout
    <prefix>/lib64/cmake/Geant4
    <prefix>/lib/Geant4-<version>      # older layout

If you are not sure, find it:

    find /path/to/geant4-install -name Geant4Config.cmake

Note that sourcing Geant4's own `bin/geant4.sh` does **not** export
`Geant4_DIR`, so doing that is not a substitute for setting it yourself.

## Documentation

The documentation is available at http://g4sipm.readthedocs.io/en/latest/index.html.

To build the documentation, invoke

    make docs
