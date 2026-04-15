// fn_patrolBounded.sqf
// [unitOrGroup, centerPos, radius, optionalBlacklist, timeout]

// the result of a very, very annoying day.
// this file is solely dedicated to making the targeted group mindlessly wander around a given point. That's it.
// because it looks nicer if everyone is scattered rather than standing perfectly still in formation.

params [ // Function input
    ["_input", objNull, [objNull, grpNull]],
    ["_center", [0,0,0], [[], objNull]],
    ["_radius", 20],
    ["_blacklist", []], // format: [[pos1, radius1], [pos2, radius2]]
    ["_time", 10]
];

private _grp = if (_input isEqualType grpNull) then {_input} else {group _input};
private _unit = leader _grp;

_grp setBehaviour "SAFE";
_grp setSpeedMode "LIMITED";

//systemChat format ["Assigning %1...", _grp];

// While the unit is idle...
while {alive _unit && {count units _grp > 0}} do {
    private _pos = [];
    private _attempts = 0;

    // Try to find a valid wander position
    while {_attempts < 200} do {
        _pos = _center getPos [random _radius, random 360];
        _attempts = _attempts + 1;

        // But avoid blacklisted areas at all costs
        private _valid = true;
        {
            private _blkPos = _x select 0;
            private _blkRad = _x select 1;
            if ((_pos distance2D _blkPos) < _blkRad) exitWith { _valid = false };
        } forEach _blacklist;

        if (_valid) exitWith {};
    };

    // If a position is found, wander there
    private _wp = _grp addWaypoint [_pos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 5;

    // ...but give up if it takes too long
    private _timeout = time + _time;

    waitUntil {
        sleep 1;
        (_unit distance2D _pos < 6) || (!alive _unit) || (time > _timeout)
    };

    // Delete the waypoint and loop until the group is alerted
    deleteWaypoint _wp;
    sleep 2; // small pause to keep things natural
};