/*
 * OpticalPhysicsList.cc
 *
 * @date Sep 12, 2011
 * @author Tim Niggemann, III Phys. Inst. A, RWTH Aachen University
 * @copyright GNU General Public License v3.0
 */

#include "OpticalPhysicsList.hh"

#include <G4Gamma.hh>
#include <G4Electron.hh>
#include <G4Positron.hh>
#include <G4Proton.hh>

OpticalPhysicsList::OpticalPhysicsList(int verbose, std::vector<G4OpticalProcessIndex> deactivate) {
	G4OpticalPhysics* phys = new G4OpticalPhysics(verbose);
	// Deactivate processes.
	//
	// Geant4 11.0 removed G4OpticalPhysics::Configure; process activation now
	// lives on the G4OpticalParameters singleton and is keyed by process name
	// rather than by enum, with G4OpticalProcessName() doing the mapping.
	//
	// Note this is no longer a property of *this* physics list: the setting is
	// process-wide, so constructing two differently-configured
	// OpticalPhysicsList objects would have the second overwrite the first.
	// Nothing does that today -- G4ScintKit's g4scint builds its own physics
	// list via GODDeSS and never instantiates this class.
	G4OpticalParameters* opt = G4OpticalParameters::Instance();
	for (std::vector<G4OpticalProcessIndex>::iterator it = deactivate.begin(); it != deactivate.end(); it++) {
		opt->SetProcessActivation(G4OpticalProcessName(*it), false);
	}
	//
	RegisterPhysics(phys);
	SetVerboseLevel(verbose);
}

OpticalPhysicsList::~OpticalPhysicsList() {
	//
}

void OpticalPhysicsList::ConstructParticle() {
	G4VModularPhysicsList::ConstructParticle();
	G4Gamma::GammaDefinition();
	G4Electron::ElectronDefinition();
	G4Positron::PositronDefinition();
	G4Proton::ProtonDefinition();
}

void OpticalPhysicsList::SetCuts() {
	SetCutsWithDefault();
	if (this->verboseLevel > 0) {
		DumpCutValuesTable();
	}
}
