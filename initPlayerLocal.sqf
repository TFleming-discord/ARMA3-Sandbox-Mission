// Simple flags to disable stamina. Carry as much as you want and sprint as far as you want.

player enableStamina false;

player addEventHandler ["Respawn", {
    player enableStamina false;
}];

// In this mission, it was originally inteded for the players to simply be able to respawn.
// So this listener would be called on every death, resetting "opforAnger".
player addEventHandler ["Killed", {
	opforAnger = 0;
    hint "OPCOM has dealt with you.";
}];