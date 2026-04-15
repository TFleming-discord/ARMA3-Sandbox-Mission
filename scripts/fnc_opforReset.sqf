// === fnc_resetEverything.sqf ===

/*
This function fully resets designated OPFOR forces and objects.
It loops through a defined config table and respawns everything that was deleted or needs to be reverted.

Usage:
[] call fnc_resetEverything;
*/

// look at that old ass comment lmfaoooo
// it's right, though. This file is solely dedicated to letting players soft-reset the mission at will via a secluded laptop inside of player spawn.
// Granted, everything has to be hard-coded. EVERYTHING has a spawn point. EVERYTHING has a set layout.

private _reconSquad = ["O_recon_TL_F", "O_recon_medic_F", "O_recon_exp_F", "O_recon_M_F", "O_recon_F", "O_recon_JTAC_F", "O_Pathfinder_F"];
private _guardSquad = ["O_soldierU_SL_F", "O_soldierU_medic_F", "O_soldierU_LAT_F", "O_soldierU_F"];
private _atSquadHeavy = ["O_Soldier_TL_F", "O_Soldier_HAT_F", "O_Soldier_HAT_F", "O_Soldier_AHAT_F"];
private _sniperSquad = ["O_sniper_F", "O_spotter_F"];

private _resetTable = [
    // GROUP FORMAT: ["group", varName, spawnMarker, classArray/className, wanderZoneArray]
	// VEHICLE FORMAT: ["veh", varName, spawnMarker, className, bearing, crewArray(Optional), crewVarName(Optional), crewWanderZoneArray(Optional)]
	// OBJECT FORMAT: ["obj", varName, spawnMarker, className, bearing, invincibleBool]

    // // GROUP EXAMPLES
    // //["group", "squadName", "markerSquadSpawn", ["O_Soldier_SL_F", "O_Soldier_F", "O_Soldier_M_F"], [wanderTrigger, radii, timeout]],
	// ["group", "opSquad1", "testUnits", ["O_Soldier_AR_F", "O_HeavyGunner_F", "O_medic_F"], [testTrigger, 20]],// Tester

    // // VEHICLE EXAMPLE
    // //["vehicle", "opTruck1", "markerTruckSpawn", "O_Truck_03_transport_F", 80, ["O_Soldier_SL_F", "O_Soldier_F"]],
	// ["veh", "opVeh1", "testVeh", "O_MRAP_02_F", 180], // Tester

    // // STATIC OBJECT EXAMPLE
    // //["object", "opRadioTower", "markerTowerSpawn", "Land_TTowerBig_1_F", 120, true]
	// ["obj", "opTower", "testProp", "Land_Cargo_Patrol_V3_F", 90, true]// Tester

	

	// Everything below is EVERY SINGLE INSTANCE of a "thing" outside of player spawn, hardcoded with it's name, spawn point, and parameters.
	// Chelonisi (Island)
	["group", "islandBridgeGuards", "islandBridgeGuards", ["O_Soldier_AT_F", "O_HeavyGunner_F"]],
	["group", "islandBaseSquad", "islandBaseSquad", _reconSquad, [islandBaseWander, 20, 15]],

	["veh", "islandAPC", "islandAPC", "O_APC_Wheeled_02_rcws_v2_F", 190, ["O_crew_F", "O_crew_F"], "islandAPCCrew", [islandAPCWander, 100, 20]],
	["veh", "islandArty_1", "islandArty_1", "O_MBT_02_arty_F", 331],
	["veh", "islandArty_2", "islandArty_2", "O_MBT_02_arty_F", 320],
	["veh", "islandZamak", "islandZamak", "O_Truck_02_box_F", 320],

	["obj", "islandBridgeSandbag", "islandBridgeSandbag", "Land_BagFence_Long_F", 140],
	["obj", "islandBaseWall_1", "islandBaseWall_1", "Land_HBarrier_Big_F", 140],
	["obj", "islandBaseWall_2", "islandBaseWall_2", "Land_HBarrier_Big_F", 50],
	["obj", "islandBaseWall_3", "islandBaseWall_3", "Land_HBarrier_Big_F", 140],
	["obj", "islandBaseWall_4", "islandBaseWall_4", "Land_HBarrier_Big_F", 140],
	["obj", "islandBaseBunker", "islandBaseBunker", "Land_BagBunker_Large_F", 140, true],
	["obj", "islandTent", "islandTent", "Land_DeconTent_01_CSAT_brownhex_F", 356, true],

	//AAC Airfield
	["group", "aacSquad_1", "aacSquad", _guardSquad, [aacWander, 50, 20]],
	["group", "aacSquad_2", "aacSquad", _guardSquad, [aacWander, 50, 20]],

	["veh", "aacFighterJet", "aacFighterJet", "O_Plane_Fighter_02_F", 123],
	["veh", "aacCASJet", "aacCASJet", "O_Plane_CAS_02_dynamicLoadout_F", 214],
	["veh", "aacTruckFuel","aacTruckFuel", "O_Truck_03_fuel_F", 95],
	["veh", "aacTruckRepair","aacTruckRepair", "O_Truck_02_box_F", 120],
	["veh", "aacCar","aacCar", "O_LSV_02_unarmed_F", 163],
	["veh", "aacHeli","aacHeli", "O_Heli_Transport_04_covered_F", 62],

	["obj", "aacWall_1", "aacWall_1", "Land_HBarrierWall6_F", 70],
	["obj", "aacWall_2", "aacWall_2", "Land_HBarrierWall6_F", 70],
	["obj", "aacWall_3", "aacWall_3", "Land_HBarrierWall6_F", 70],
	["obj", "aacWall_4", "aacWall_4", "Land_HBarrierWall6_F", 70],
	["obj", "aacWall_5", "aacWall_5", "Land_HBarrierWall6_F", 160],
	["obj", "aacNet", "aacNet", "CamoNet_OPFOR_open_F", 83, true],
	["obj", "accTower", "accTower", "Land_Cargo_Patrol_V3_F", 270, true],
	["obj", "aacBuilding", "aacBuilding", "Land_Cargo_HQ_V3_F", 77, true],

	//Western Concrete Factory
	["group", "concreteSquad_1", "concreteSquad", _guardSquad, [concreteWander, 30, 15]],
	["group", "concreteSquad_2", "concreteSquad", _guardSquad, [concreteWander, 30, 15]],

	["veh", "concreteCivTruck","concreteCivTruck", "C_Truck_02_transport_F"],
	["veh", "concreteCivTruckSmall","concreteCivTruckSmall", "C_Van_01_box_F", 267],
	["veh", "concreteTruckTransport","concreteTruckTransport", "O_Truck_02_covered_F", 25],
	["veh", "concreteTruckRepair","concreteTruckRepair", "O_Truck_02_box_F", 217],
	["veh", "concreteAA_1","concreteAA_1", "O_APC_Tracked_02_AA_F", 100, ["O_crew_F", "O_crew_F", "O_crew_F"], "concreteAACrew"],
	["veh", "concreteAA_2","concreteAA_2", "O_APC_Tracked_02_AA_F", 300, ["O_crew_F", "O_crew_F", "O_crew_F"], "concreteAACrew"],
	["veh", "concreteAATurret","concreteAATurret", "O_static_AA_F", 150],

	
	["obj", "concreteTent", "concreteTent", "Land_MedicalTent_01_CSAT_brownhex_generic_outer_F", 270, true],

	//Western General Factory
	["group", "factorySquad_1", "factorySquad_1", _guardSquad, [factoryWander_1, 50, 25]],
	["group", "factorySquad_2", "factorySquad_1", _guardSquad, [factoryWander_1, 50, 25]],
	["group", "factorySquad_3", "factorySquad_2", _guardSquad, [factoryWander_2, 50, 25]],
	["group", "factorySquad_4", "factorySquad_2", _guardSquad, [factoryWander_2, 50, 25]],
	["group", "factoryATSquad", "factorySquad_3", _atSquadHeavy, [factoryWander_3, 50, 25]],

	["veh", "factoryOPFORTruck_1", "factoryOPFORTruck_1", "O_LSV_02_armed_F", 90, ["O_crew_F", "O_crew_F"], "factoryAPCCrew_1", [factoryWander_1, 100, 20]],
	["veh", "factoryOPFORTruck_2", "factoryOPFORTruck_2", "O_LSV_02_armed_F", 270, ["O_crew_F", "O_crew_F"], "factoryAPCCrew_2", [factoryWander_2, 100, 20]],
	["veh", "factoryAPC", "factoryAPC", "O_APC_Wheeled_02_rcws_v2_F", 180, ["O_crew_F", "O_crew_F"], "factoryTruckCrew", [factoryWander_3, 100, 5]],
	["veh", "factoryCivCar", "factoryCivCar", "C_Hatchback_01_sport_F", 265],
	["veh", "factoryCivRepairTruck", "factoryCivRepairTruck", "C_Offroad_01_repair_F", 82],
	["veh", "factoryCivTruckFuel", "factoryCivTruckFuel", "C_Truck_02_fuel_F", 182],
	["veh", "factoryCivTruck", "factoryCivTruck", "C_Van_01_transport_F", 357],
	["veh", "factoryCivVan", "factoryCivVan", "C_Van_02_service_F", 1],

	["obj", "factoryBunker_1", "factoryBunker_1", "Land_BagBunker_Small_F", 1, true],
	["obj", "factoryBunker_2", "factoryBunker_2", "Land_BagBunker_Small_F", 358, true],

	//Firni (depricated, ew, gross)
	// ["group", "firniSquad_1", "firniSquad_1", _guardSquad, [firniWander, 50, 25]],
	// ["group", "firniSquadAT", "firniSquad_1", _atSquadHeavy, [firniWander, 50, 25]],
	// ["group", "firniSquad_2", "firniSquad_2", _guardSquad, [firniWander, 50, 25]],

	// ["veh", "firniVehicle", "firniVehicle", "O_LSV_02_armed_F", 90, ["O_crew_F", "O_crew_F"], "firniVehicleSquad", [firniWander, 100, 20]],
	// ["heli", "firniHeli", "firniVehicle", "O_Heli_Light_02_dynamicLoadout_F", 90, ["O_crew_F", "O_crew_F"], "firniHeliSquad", [firniWander, 100, 20], "FLY"]

	//USS Liberty
	// Where I stopped and haven't picked up since.
	//VEHICLE FORMAT: ["veh", varName, spawnMarker, className, bearing, crewArray(Optional), crewVarName(Optional), crewWanderZoneArray(Optional)]
	["ship", "destroyer120", "destroyer120Spawn", "B_Ship_Gun_01_F", [0, -78.5, 14.5], 180, ["O_crew_F"], "destroyer120CSAT"]

];

{ // okay, now actually start resetting things
    private _entry = _x;
	private _type = _entry select 0;

	params ["_entry"];

	// Delete old instance if it exists
	private _existing = missionNamespace getVariable [(_entry select 1), objNull];
	if (!isNull _existing) then {
		if (_type == "group") then {
			{ deleteVehicle _x; } forEach units _existing;
			deleteGroup _existing;
		} else {
			deleteVehicle _existing;
		};
	};

	// Respawn logic
	switch (_type) do {
		case "group": {
			[_entry] spawn{
				params ["_entry"];
				sleep 0.5; // Pause for a short bit to let deleted things become fully deleted before spawning new ones
						   // (can cause collision issues with objects mid-deletion without sleep)

				private _varName = _entry select 1;
				private _marker = _entry select 2; 
				private _classData = _entry select 3;
				private _zone = if (count _entry > 4) then {_entry select 4} else {[]};

				// systemChat format ["_zone : %1", _zone];

				private _grp = createGroup east;
				{
					private _unit = _grp createUnit [_x, getMarkerPos _marker, [], 5, "NONE"];
					_unit setSkill 0.35;
				} forEach _classData;
				missionNamespace setVariable [_varName, _grp];
				sleep 0.1; // Let units spawn before assigning them a wander zone
				if !(_zone isEqualTo []) then {
					//systemChat format ["Assigning %1 to patrol %2 with a radius of %3 and a timeout of %4!", _grp, _zone select 0, _zone select 1, _zone select 2];
					[_grp, getPos (_zone select 0), (_zone select 1), [], (_zone select 2)] call sandbox_fnc_taskPatrolBounded; //woahg... custom function...
				};
			};
		};

		case "veh": {
			[_entry] spawn {
				params ["_entry"];
				sleep 0.5; // Pause for a short bit to let deleted things become fully deleted before spawning new ones

				private _varName = _entry select 1;
				private _marker = _entry select 2;
				private _classData = _entry select 3;
				private _dir = if (count _entry > 4) then {_entry select 4} else {0};
				private _crewClasses = if (count _entry > 5) then {_entry select 5} else {[]};
				private _crewVarName = if (count _entry > 6) then {_entry select 6} else {""};
				private _crewZone = if (count _entry > 7) then {_entry select 7} else {[]};
				private _mode = if (count _entry > 8) then {_entry select 8} else {"CAN_COLLIDE"};

				private _mPos = getMarkerPos _marker;
				_mPos set [2, (_mPos select 2) + 0.5];
				private _veh = createVehicle [_classData, _mPos, [], 0, _mode];
				_veh setPosATL _mPos;
				_veh setDir _dir;
				_veh setFuel 1;
				_veh setVehicleAmmo 1;
				_veh setDamage 0;

				missionNamespace setVariable [_varName, _veh];

				// --- Crew spawning ---
				if !(_crewClasses isEqualTo []) then {
					private _crewGrp = createGroup east;
					{
						private _unit = _crewGrp createUnit [_x, position _veh, [], 0, "NONE"];
						_unit moveInAny _veh;
					} forEach _crewClasses;

					_crewGrp setBehaviour "AWARE";
					_crewGrp setCombatMode "YELLOW";
					_crewGrp setSpeedMode "LIMITED";

					if (_crewVarName != "") then {
						missionNamespace setVariable [_crewVarName, _crewGrp];
					};

					if !(_crewZone isEqualTo []) then {
						[_crewGrp, getPos (_crewZone select 0), (_crewZone select 1), [], (_crewZone select 2)] call sandbox_fnc_taskPatrolBounded;
					} else {
						{
							_x disableAI "MOVE";
						} forEach units _crewGrp;
					};
				};
			};
		};

		case "heli": {
			[_entry] spawn {
				params ["_entry"];
				sleep 0.5; // Pause for a short bit to let deleted things become fully deleted before spawning new ones

				private _varName = _entry select 1;
				private _marker = _entry select 2;
				private _classData = _entry select 3;
				private _dir = if (count _entry > 4) then {_entry select 4} else {0};
				private _crewClasses = if (count _entry > 5) then {_entry select 5} else {[]};
				private _crewVarName = if (count _entry > 6) then {_entry select 6} else {""};

				private _mPos = getMarkerPos _marker;
				_mPos set [2, (_mPos select 2) + 0.5];
				private _veh = createVehicle [_classData, _mPos, [], 0, "FLY"];
				_veh setDir _dir;
				_veh setFuel 1;
				_veh setVehicleAmmo 1;
				_veh setDamage 0;

				missionNamespace setVariable [_varName, _veh];

				// --- Crew spawning ---
				if !(_crewClasses isEqualTo []) then {
					private _crewGrp = createGroup east;
					{
						private _unit = _crewGrp createUnit [_x, position _veh, [], 0, "NONE"];
						_unit moveInAny _veh;
					} forEach _crewClasses;

					_crewGrp setBehaviour "AWARE";
					_crewGrp setCombatMode "YELLOW";
					_crewGrp setSpeedMode "LIMITED";

					if (_crewVarName != "") then {
						missionNamespace setVariable [_crewVarName, _crewGrp];
					};

					private _wp = _crewGrp addWaypoint [_mPos, 0];
					_wp setWaypointType "LOITER";
					_wp setWaypointLoiterAltitude 100;
					_wp setWaypointloiterRadius 150;
				};
			};
		};

		case "obj": {
			[_entry] spawn {
				params ["_entry"];
				sleep 0.5; // Pause for a short bit to let deleted things become fully deleted before spawning new ones
						   // (can cause collision issues with objects mid-deletion without sleep)

				private _varName = _entry select 1;
				private _marker = _entry select 2; 
				private _classData = _entry select 3;
				private _dir = if (count _entry > 4) then {_entry select 4} else {0};
				private _invuln = if (count _entry > 5) then {_entry select 5} else {false};
			
				private _obj = createVehicle [_classData, [0,0,0], [], 0, "CAN_COLLIDE"];
				private _mPos = getMarkerPos _marker;
				_obj setPosATL _mPos;
				_obj setDir _dir;
				private _normal = surfaceNormal _mPos;
				_obj setVectorUp _normal;
				_obj enableSimulation false;
				_obj allowDamage _invuln;
				missionNamespace setVariable [_varName, _obj];
			};
		};

		// Proprietary ship logic for USS Freedom
		case "ship": {
			[_entry] spawn {
				params ["_entry"];
				sleep 0.5; // Pause for a short bit to let deleted things become fully deleted before spawning new ones

				private _varName = _entry select 1;
				private _marker = _entry select 2;
				private _classData = _entry select 3;
				private _mountPos = _entry select 4;
				private _dir = if (count _entry > 5) then {_entry select 5} else {0};
				private _crewClasses = if (count _entry > 6) then {_entry select 6} else {[]};
				private _crewVarName = if (count _entry > 7) then {_entry select 7} else {""};
				private _mode = if (count _entry > 8) then {_entry select 8} else {"CAN_COLLIDE"};

				private _mPos = getMarkerPos _marker;
				private _veh = createVehicle [_classData, _mPos, [], 0, _mode];
				_veh enableSimulation false; // Disable physics for now
				_veh setPosATL (getPosATL destroyer120Spawn);
				_veh setDir _dir; // Optional, may not work well while attached
				//_veh attachTo [destroyer, _mountPos];
				//_veh setVectorDirAndUp [[0,-1,0],[0,0,1]]; // Face forward, upright
				_veh enableSimulation true; // Re-enable once placed
				_veh setFuel 1;
				_veh setVehicleAmmo 1;
				_veh setDamage 0;

				missionNamespace setVariable [_varName, _veh];

				systemChat "turret spawned";

				// --- Crew spawning ---
				if !(_crewClasses isEqualTo []) then {
					private _crewGrp = createGroup east;
					{
						private _unit = _crewGrp createUnit [_x, position _veh, [], 0, "NONE"];
						_unit moveInAny _veh;
					} forEach _crewClasses;

					systemChat "gunner spawned";

					_crewGrp setBehaviour "AWARE";
					_crewGrp setCombatMode "YELLOW";
					_crewGrp setSpeedMode "LIMITED";

					if (_crewVarName != "") then {
						missionNamespace setVariable [_crewVarName, _crewGrp];
					};
				};
			};
		};
	};
} forEach _resetTable;

// Old code for the Firni task.
([0,0,0] nearestObject 1061837) setDamage 0;
([0,0,0] nearestObject 1061749) setDamage 0;
taskActiveBuilding = true;

hint "OPFOR has been fully reset!";