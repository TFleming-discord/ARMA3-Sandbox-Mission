// params [
// 	"_varName", // Variable name for squad
// 	"_classData", // Array of class names for the soldiers within the squad
// 	["_dir", 0], // Direction the squad should spawn facing, default North
// 	["_vehClass", ""], // Optional vehicle class name if reinforcements should be using a vehicle, default none
// 	["_vehVarName", ""], // Optional vehicle variable name, default none.
// 	["_vehDir", 0] // Optional vehicle direction, default none.
// ];

private _fireTeam = ["O_Soldier_TL_F", "O_Soldier_GL_F", "O_Soldier_AR_F", "O_Soldier_LAT_F"]; // Unused. ArmA default "Fire Team". More for reference
private _myFireTeam = ["O_Soldier_TL_F", "O_Soldier_GL_F", "O_Soldier_AR_F", "O_medic_F"];
private _assaultSquad = ["O_Soldier_SL_F", "O_HeavyGunner_F", "O_soldier_M_F", "O_Soldier_LAT_F", "O_Soldier_AR_F", "O_Soldier_AAR_F", "O_Sharpshooter_F", "O_medic_F"];
private _heliCrew = ["O_helipilot_F", "O_helipilot_F"];
private _crew = ["O_crew_F", "O_crew_F", "O_crew_F"];

private _playerPos = position player; // Get player pos
private _angle = random 360; // Get random angle

//== Opfor anger level 0 ==
if (opforAnger <= 1) then {
	hint "OPCOM Anger level 0, OPCOM does not care about you yet.";
};

//== Opfor anger level 1 == Small recon squad
if (opforAnger == 2) then {

	private _distance = 100 + random 50; // "Random distance between 100 and 150"
	private _spawnPos = _playerPos getPos [_distance, _angle]; // Spawn point for reinforcement

	// Create group
		private _grp = [_spawnPos, _myFireTeam, 0.35] call sandbox_fnc_createGrp;
	// ==

	// Set waypoints for squad ==
		[_grp, _playerPos] spawn {
		params ["_grp", "_playerPos"];

			sleep (5 + random 5); // Wait 5-10 seconds, THEN create the seek-and-destroy waypoint
								  // (this gives the squad time to fan out)
			
			private _wp = _grp addWaypoint [_playerPos, 0]; 
			_wp setWaypointType "SAD";
			_wp setWaypointBehaviour "AWARE";
			_wp setWaypointCombatMode "RED";
			_wp setWaypointSpeed "FULL";
		};
	//

	hint "OPCOM Anger level 1\nSmall fire teams are investigating your presence.";
};

//== Opfor anger level 2 == Full assault squad in transport truck
if (opforAnger == 3) then {

	private _distance = 200 + random 100; // "Random distance between 100 and 150"
	private _spawnPos = _playerPos getPos [_distance, _angle]; // Spawn point for reinforcement

	private _grp = [_spawnPos, _assaultSquad, 0.45] call sandbox_fnc_createGrp;

	// Determining a safe spawn location for motorized infantry ==
		_safePos = [_spawnPos, "O_Truck_02_transport_F"] call sandbox_fnc_safeSpawn;
	// ==

	// Create group
		private _veh = createVehicle ["O_Truck_02_transport_F", _safePos, [], 0, "NONE"];
		{
			_x moveInAny _veh;
		}forEach units _grp;
	// ==

	// Set waypoint for squad
		[_grp, _playerPos] spawn {
		params ["_grp", "_playerPos"];

			sleep (5 + random 5);
			
			// Create a move waypoint so that the squad drives to the player's location ==
			private _wpMOVE = _grp addWaypoint [_playerPos, 0, 0]; 
			_wpMOVE setWaypointType "MOVE";
			_wpMOVE setWaypointBehaviour "AWARE";
			_wpMOVE setWaypointCombatMode "RED";
			_wpMOVE setWaypointSpeed "FULL";
			_wpMOVE setWaypointCompletionRadius 10;
			// VV Un-binds the vehicle from the group's possession, making all units disembark VV ==
			_wpMOVE setWaypointStatements ["true", "{unassignVehicle _x; _x leaveVehicle vehicle _x;} forEach units (group this);"]; 
			_grp setCurrentWaypoint _wpMOVE;

			private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
			_wpSAD setWaypointType "SAD";
			_wpSAD setWaypointBehaviour "AWARE";
			_wpSAD setWaypointCombatMode "RED";
			_wpSAD setWaypointSpeed "FULL";
		};
	// ==

	hint "OPCOM Anger level 2\nMotorized assault squads are being dispatched because of your actions.";
};

//== Opfor anger level 3 == Two full assault squads in transport trucks and an armed recon vehicle
if (opforAnger == 4) then {

	private _distance = 300 + random 100; // "Random distance between 300 and 400"
	private _spawnPos = _playerPos getPos [_distance, _angle]; // Select generic spawn point for enemy reinforcements distance away at angle

	// Create TWO motorized squads
		for "_i" from 0 to 1 do {
			
			// Create a group (with a custom function!!!)
			private _grp = [_spawnPos, _assaultSquad, 0.6] call sandbox_fnc_createGrp;

			// Determine a safe spawn location by seeing if you can put a whole truck there first (with a custom function!!!)
				_safePos = [_spawnPos, "O_Truck_02_transport_F"] call sandbox_fnc_safeSpawn;
			// ==

			// Create vehicle, enemy squad, and have squad enter the vehicle
				private _veh = createVehicle ["O_Truck_02_transport_F", _safePos, [], 0, "NONE"];
				{
					_x moveInAny _veh;
				} forEach units _grp;
			// ==

			// Create waypoints on the player's position for enemy squad to Reach
				[_grp, _playerPos] spawn { 
				params ["_grp", "_playerPos"];

					// slight random delay to allow physics of newly spawned stuff to settle
					// also makes this a rougelike!!! no run is the same!!!
					sleep (5 + random 5);
					
					// Create a move waypoint so that the squad drives to the player's location ==
					private _wpMOVE = _grp addWaypoint [_playerPos, 0, 0]; 
					_wpMOVE setWaypointType "MOVE";
					_wpMOVE setWaypointBehaviour "AWARE";
					_wpMOVE setWaypointCombatMode "RED";
					_wpMOVE setWaypointSpeed "FULL";
					_wpMOVE setWaypointCompletionRadius 10;
					// VV Un-binds the vehicle from the group's possession, making all units disembark VV ==
					_wpMOVE setWaypointStatements ["true", "{unassignVehicle _x; _x leaveVehicle vehicle _x;} forEach units (group this);"]; 
					_grp setCurrentWaypoint _wpMOVE;

					private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
					_wpSAD setWaypointType "SAD";
					_wpSAD setWaypointBehaviour "AWARE";
					_wpSAD setWaypointCombatMode "RED";
					_wpSAD setWaypointSpeed "FULL";
				};
			// ==
		};
	// ==

	// Create armed vehicle squad

		private _grp = [_spawnPos, _myFireTeam, 0.6] call sandbox_fnc_createGrp;

		// Determine safe spawn location (with fallback)
			_safePos = [_spawnPos, "O_Truck_02_transport_F"] call sandbox_fnc_safeSpawn;
		// ==

		// Create squad
			private _veh = createVehicle ["O_LSV_02_armed_F", _safePos, [], 0, "NONE"];
			{
				_x moveInAny _veh;
			}forEach units _grp;
		// ==

		// Create waypoints for squad
			[_grp, _playerPos] spawn {
			params ["_grp", "_playerPos"];

				sleep (5 + random 5);

				private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
				_wpSAD setWaypointType "SAD";
				_wpSAD setWaypointBehaviour "AWARE";
				_wpSAD setWaypointCombatMode "RED";
				_wpSAD setWaypointSpeed "FULL";
			};
		// ==

	hint "OPCOM Anger level 3\nMotorized assault squads and vehicles are being sent to stop your chaos.";
};

//== Opfor anger level 4 == Light APC, transport truck, and a light attack helicopter
if (opforAnger == 5) then {

	private _distance = 300 + random 100; // "Random distance between 100 and 150"
	private _spawnPos = _playerPos getPos [_distance, _angle]; // Spawn point for reinforcement

	// Create light APC squad

		private _grp = [_spawnPos, _crew, 0.75] call sandbox_fnc_createGrp;

		// Determine safe spawn location (with fallback)
			_safePos = [_spawnPos, "O_APC_Wheeled_02_rcws_v2_F"] call sandbox_fnc_safeSpawn;
		// ==

		// Create squad
			private _veh = createVehicle ["O_APC_Wheeled_02_rcws_v2_F", _safePos, [], 0, "NONE"]; 
			{
				_x moveInAny _veh;
			}forEach units _grp;
		// ==

		// Create waypoints for squad
			[_grp, _playerPos] spawn {
			params ["_grp", "_playerPos"];

				private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
				_wpSAD setWaypointType "SAD";
				_wpSAD setWaypointBehaviour "AWARE";
				_wpSAD setWaypointCombatMode "RED";
				_wpSAD setWaypointSpeed "FULL";
			};
		// ==
	// ==

	// == Create transport truck squad
		private _grp = [_spawnPos, _assaultSquad, 0.75] call sandbox_fnc_createGrp;

		// Determine safe spawn location (with fallback)
			_safePos = [_spawnPos, "O_Truck_02_transport_F"] call sandbox_fnc_safeSpawn;
		// ==

		// Create squad
			private _veh = createVehicle ["O_Truck_02_transport_F", _safePos, [], 0, "NONE"];
			{
				_x moveInAny _veh;
			} forEach units _grp;
		// ==

		// Create waypoints for squad
			[_grp, _playerPos] spawn { 
			params ["_grp", "_playerPos"];

				sleep (5 + random 5);
				
				// Create a move waypoint so that the squad drives to the player's location ==
				private _wpMOVE = _grp addWaypoint [_playerPos, 0, 0]; 
				_wpMOVE setWaypointType "MOVE";
				_wpMOVE setWaypointBehaviour "AWARE";
				_wpMOVE setWaypointCombatMode "RED";
				_wpMOVE setWaypointSpeed "FULL";
				_wpMOVE setWaypointCompletionRadius 10;
				// VV Un-binds the vehicle from the group's possession, making all units disembark VV ==
				_wpMOVE setWaypointStatements ["true", "{unassignVehicle _x; _x leaveVehicle vehicle _x;} forEach units (group this);"]; 
				_grp setCurrentWaypoint _wpMOVE;

				private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
				_wpSAD setWaypointType "SAD";
				_wpSAD setWaypointBehaviour "AWARE";
				_wpSAD setWaypointCombatMode "RED";
				_wpSAD setWaypointSpeed "FULL";
			};
		// ==
	// ==

	// Create the helicopter squad
		private _heliSpawnPos = _playerPos getPos [(_distance + 500), _angle]; // Increase helicopter spawn by 500 meters to avoid popping into existence
		private _heliGrp = [_heliSpawnPos, _heliCrew, 0.75] call sandbox_fnc_createGrp;

		// Create vehicle and define pylons
			private _heli = createVehicle ["O_Heli_Light_02_dynamicLoadout_F", _heliSpawnPos, [], 0, "FLY"];
			private _pylonIndices = getAllPylonsInfo _heli select { _x select 0 };
			{
				_vehicle setPylonLoadout [_x, "PylonWeapon_300Rnd_20mm_shells", true];
			} forEach _pylonIndicies;

			{
				_x moveInAny _heli;
			}forEach units _heliGrp;
		// ==

		// Create waypoints for squad
			private _wp = _heliGrp addWaypoint [_playerPos, 0];
			_wp setWaypointType "SAD";
			_wp setWaypointBehaviour "AWARE";
			_wp setWaypointCombatMode "RED";
			_wp setWaypointSpeed "FULL";
		// ==
	// ==

	hint "OPCOM Anger level 4\nAir AND Mechanized units are looking to halt your destruction.";
};

//== Opfor anger level 5 == Tank, transport truck, and a heavy attack helicopter
if (opforAnger == 6) then {

	private _distance = 400 + random 200; // "Random distance between 400 and 600"
	private _spawnPos = _playerPos getPos [_distance, _angle]; // Spawn point for reinforcement

	// Create tank squad
		private _grp = [_spawnPos, _crew, 0.9] call sandbox_fnc_createGrp;

		// Determine safe spawn location (with fallback)
			_safePos = [_spawnPos, "O_MBT_04_cannon_F"] call sandbox_fnc_safeSpawn;
		// ==

		// Create squad
			private _veh = createVehicle ["O_MBT_04_cannon_F", _safePos, [], 0, "NONE"]; 
			{
				_x moveInAny _veh;
			}forEach units _grp;
		// ==

		// Create waypoints for squad
			[_grp, _playerPos] spawn {
			params ["_grp", "_playerPos"];

				private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
				_wpSAD setWaypointType "SAD";
				_wpSAD setWaypointBehaviour "AWARE";
				_wpSAD setWaypointCombatMode "RED";
				_wpSAD setWaypointSpeed "FULL";
			};
		// ==
	// ==

	// == Create transport truck squad
		private _grp = [_spawnPos, _assaultSquad, 0.9] call sandbox_fnc_createGrp;

		// Determine safe spawn location (with fallback)
			_safePos = [_spawnPos, "O_Truck_02_transport_F"] call sandbox_fnc_safeSpawn;
		// ==

		// Create squad
			private _veh = createVehicle ["O_Truck_02_transport_F", _safePos, [], 0, "NONE"];
			{
				_x moveInAny _veh;
			} forEach units _grp;
		// ==

		// Create waypoints for squad
			[_grp, _playerPos] spawn { 
			params ["_grp", "_playerPos"];

				sleep (5 + random 5);
				
				// Create a move waypoint so that the squad drives to the player's location ==
				private _wpMOVE = _grp addWaypoint [_playerPos, 0, 0]; 
				_wpMOVE setWaypointType "MOVE";
				_wpMOVE setWaypointBehaviour "AWARE";
				_wpMOVE setWaypointCombatMode "RED";
				_wpMOVE setWaypointSpeed "FULL";
				_wpMOVE setWaypointCompletionRadius 10;
				// VV Un-binds the vehicle from the group's possession, making all units disembark VV ==
				_wpMOVE setWaypointStatements ["true", "{unassignVehicle _x; _x leaveVehicle vehicle _x;} forEach units (group this);"]; 
				_grp setCurrentWaypoint _wpMOVE;

				private _wpSAD = _grp addWaypoint [_playerPos, 0, 1];
				_wpSAD setWaypointType "SAD";
				_wpSAD setWaypointBehaviour "AWARE";
				_wpSAD setWaypointCombatMode "RED";
				_wpSAD setWaypointSpeed "FULL";
			};
		// ==
	// ==

	// Create the helicopter squad
		private _heliSpawnPos = _playerPos getPos [(_distance + 500), _angle]; // Increase helicopter spawn by 500 meters to avoid popping into existence
		private _heliGrp = [_heliSpawnPos, _heliCrew, 0.9] call sandbox_fnc_createGrp;

		// Create group
			private _heli = createVehicle ["O_Heli_Attack_02_dynamicLoadout_F", _heliSpawnPos, [], 0, "FLY"];
			{
				_x moveInAny _heli;
			}forEach units _heliGrp;
		// ==

		// Create waypoints for squad
			private _wp = _heliGrp addWaypoint [_playerPos, 0];
			_wp setWaypointType "SAD";
			_wp setWaypointBehaviour "AWARE";
			_wp setWaypointCombatMode "RED";
			_wp setWaypointSpeed "FULL";
		// ==
	// ==

	hint "OPCOM Anger level 6\nYour immediate death is top priority.";
};