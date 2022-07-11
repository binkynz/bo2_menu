#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\menu;

init()
{
    level thread on_player_connect();
}

on_player_connect()
{
    self endon("end_game");

    for(;;)
    {
        level waittill("connected", player);
        player thread on_player_spawned();
    }
}

on_player_spawned()
{
    self endon("disconnect");

    menu = self menu_init("Sassy the Sasquatch", 200);
    menu menu_add_tab("tab 1");
    menu menu_add_tab("tab 2");
    menu menu_add_tab("tab 3");
    menu menu_add_tab("tab 4");
    menu menu_add_tab("tab 5");
    menu menu_add_tab("tab 6");
    menu thread menu_control();
    menu thread menu_draw();

    for(;;)
    {
        self waittill("spawned_player");
    }
}
