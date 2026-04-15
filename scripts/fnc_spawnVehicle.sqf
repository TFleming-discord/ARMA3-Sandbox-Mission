params [
    "_pos",   // Object or marker to spawn at
    "_vehicleType",   // Classname of vehicle to spawn
    "_caller",        // Optional: player using the action
    ["_dir", 0],      // Optional : Direction the vehicle should be facing
    ["_base", ""]     // Optional : Vehicle base class, if more than one type of a similar vehicle is nearby
];

private _scanRadius = 20;
private _rawNearby = nearestObjects [_pos, ["Car", "Tank", "Air", "UAV", "UGV_01_base_F"], _scanRadius];
private _nearby = [];

if (_base == "") then { // Select nearest similar vehicle
    _nearby = _rawNearby select {typeOf _x == _vehicleType};
} else {
    _nearby = _rawNearby select {_x isKindOf _base};
};

[_nearby, _pos, _dir, _vehicleType, _caller] spawn { // Then, on a new thread...
    params ["_nearby", "_pos", "_dir", "_vehicleType", "_caller"];
    {
        private _veh = _x;

        if (!alive _veh || {damage _veh > 0.5} || {fuel _veh > 0.99}) then { // Filter damaged, wrecked, or used vehicles of the same type...
            deleteVehicle _veh; // ...and delete it.
        };
    } forEach _nearby;

    sleep 0.5; // Delay to let ArmA delete the other vehicles
    
    private _veh = createVehicle [_vehicleType, _pos, [], 0, "NONE"]; // Now spawn the new vehicle.

    
    if (_veh isKindOf "UAV" || _veh isKindOf "UGV_01_base_F") then { // If the new vehicle is a drone of some sort...
        createVehicleCrew _veh; // Give it a crew (Invisible AI NPC that allows UAV terminal access to every soldier of it's side)
        private _crew = crew _veh;
        private _pilot = _crew select 0;
        private _group = group _pilot;
    };

    _veh setDir _dir;
    _veh setVehicleAmmo 1;
    _veh setFuel 1;
    _veh lock 0;

    [
     parsetext format [
        "<t color='#00BFFF'>%1</t> respawned a <t color='#00FF00'>%2</t>!",
        name _caller,
        getText (configFile >> "CfgVehicles" >> _vehicleType >> "displayName")
        ]
    ] remoteExec ["hint", 0];
}