/*
 * MaterialFactory.hh
 *
 * @date Mar 15, 2012
 * @author Tim Niggemann, III Phys. Inst. A, RWTH Aachen University
 * @copyright GNU General Public License v3.0
 */

#ifndef MATERIALFACTORY_HH_
#define MATERIALFACTORY_HH_

#include <G4Material.hh>

/**
 * Factory class (singleton) collecting all used materials. Properly initializes the materials with index of refraction.
 */
class MaterialFactory {
private:
	G4Material* air;
	G4Material* boronCarbideCeramic;
	G4Material* copper;
	G4Material* epoxy;
	G4Material* silicon;

	/**
	 * Hidden constructor.
	 */
	MaterialFactory();

public:
	static double LAMBDA_MIN;
	static double LAMBDA_MAX;

	virtual ~MaterialFactory();

	/**
	 * @return MaterialFactory - the singleton.
	 */
	static MaterialFactory* getInstance();

	/**
	 * @return G4Material - air.
	 */
	G4Material* getAir();

	/**
	 * @return G4Material - ceramic.
	 */
	G4Material* getBoronCarbideCeramic();

	/**
	 * @return G4Material - copper.
	 */
	G4Material* getCopper();

	/**
	 * @return G4Material - epoxy.
	 */
	G4Material* getEpoxy();

	/**
	 * Build a fresh G4Material with epoxy's element composition (Si=15, H=16,
	 * O=2) and the given name + density. Unlike `new G4Material(name, density,
	 * getEpoxy())`, this does NOT inherit `getEpoxy()`'s MPT pointer, so the
	 * caller can safely attach its own MPT via SetMaterialPropertiesTable.
	 */
	G4Material* makeEpoxyComposition(const G4String& name, double density);

	/**
	 * @return G4Material - silicon.
	 */
	G4Material* getSilicon();
};

#endif /* MATERIALFACTORY_HH_ */
