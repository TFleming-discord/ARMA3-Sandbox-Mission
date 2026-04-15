// fn_patrolBounded.sqf
// [unitOrGroup, centerPos, radius, optionalBlacklist, timeout]

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

while {alive _unit && {count units _grp > 0}} do {
    private _pos = [];
    private _attempts = 0;

    // Try to find a valid patrol position
    while {_attempts < 200} do {
        _pos = _center getPos [random _radius, random 360];
        _attempts = _attempts + 1;

        private _valid = true;
        {
            private _blkPos = _x select 0;
            private _blkRad = _x select 1;
            if ((_pos distance2D _blkPos) < _blkRad) exitWith { _valid = false };
        } forEach _blacklist;

        if (_valid) exitWith {};
    };

    private _wp = _grp addWaypoint [_pos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 5;

    private _timeout = time + _time;

    waitUntil {
        sleep 1;
        (_unit distance2D _pos < 6) || (!alive _unit) || (time > _timeout)
    };

    deleteWaypoint _wp;
    sleep 2; // small pause to keep things natural
};