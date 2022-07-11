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
    menu menu_add_item("1");
    menu menu_add_item("2");
    menu menu_add_item("3");
    menu thread menu_control();

    for(;;)
    {
        self waittill("spawned_player");
    }
}
