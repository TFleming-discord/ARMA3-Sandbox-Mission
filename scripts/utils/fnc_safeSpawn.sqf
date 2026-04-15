params [
	"_spawnPos",
	"_classData"
];

private _emptyPosRadii = 80; 
private _safePos = _spawnPos findEmptyPosition [50, _emptyPosRadii, _classData];

while {_safePos isEqualTo []} do {
	//player globalChat format ["'%1' spawn failure  at radii of %1, retrying...", _classData, _emptyPosRadii];
	_emptyPosRadii = _emptyPosRadii + 5;
	_safePos = _spawnPos findEmptyPosition [5, _emptyPosRadii, _classData];
};
//if (_emptyPosRadii != 80) then {player globalChat format ["'%1' spawn successful after radii was increased to %2", _classData, _emptyPosRadii]};

private _roadPos = _safePos nearRoads 20;

if !(_roadPos isEqualTo []) then {
	_safePos = getPosATL (_roadPos select 0);
	systemChat "Road within 20m of _safePos, spawn updated!";
};

_safePos