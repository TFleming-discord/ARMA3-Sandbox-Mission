// a small file that determines a "safe" spawn point for a given thing
// ARMA physics get very annoying when dealing with tight spots, so finding a spot with enough space is important
// although I usually just had it check if a fucking truck could fit every time, because if a truck could fit, anything probably could

params [
	"_spawnPos",
	"_classData"
];

// choose a spot within 50 and 80 meters of the requested spawn point
private _emptyPosRadii = 80; 
private _safePos = _spawnPos findEmptyPosition [50, _emptyPosRadii, _classData];

// If no "spot" is returned by findEmptyPosition, then there is no safe spot. Try again with a slightly larger search radius
while {_safePos isEqualTo []} do {
	_emptyPosRadii = _emptyPosRadii + 5;
	_safePos = _spawnPos findEmptyPosition [5, _emptyPosRadii, _classData];
};

// If a safe spot is found, but there happens to be a ROAD near the safe spot, move the spot to the road
private _roadPos = _safePos nearRoads 20;

if !(_roadPos isEqualTo []) then {
	_safePos = getPosATL (_roadPos select 0);
	systemChat "Road within 20m of _safePos, spawn updated!";
};

_safePos