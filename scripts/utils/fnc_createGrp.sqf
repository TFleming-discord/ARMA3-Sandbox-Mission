// very simple script to make creating OPFOR groups a little more tidy.
// also adds a small event handler for a makeshift killfeed.

params [
	"_spawnPos",
	"_classData",
	"_skill"
];

private _grp = createGroup east;
{
	private _unit = _grp createUnit [_x, _spawnPos, [], 10, "NONE"];
	_unit setSkill _skill;
	_unit addEventHandler ["Killed", {
		params ["_killed", "_killer"];
		[format ["%1 killed %2", name _killer, name _killed]] remoteExec ["systemChat", 0];
	}];
} forEach _classData;

_grp