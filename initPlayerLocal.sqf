player enableStamina false;

player addEventHandler ["Respawn", {
    player enableStamina false;
}];

player addEventHandler ["Killed", {
	opforAnger = 0;
    hint "OPCOM has dealt with you.";
}];