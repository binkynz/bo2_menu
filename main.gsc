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

    self thread create_menu();

    for(;;)
    {
        self waittill("spawned_player");
    }
}

create_menu()
{
    self endon("disconnect");

    menu = self menu_init("Sassy the Sasquatch", 200);
    menu menu_add_item("1", ::create_submenu);
    menu menu_add_item("2");
    menu menu_add_item("3");
    menu menu_add_item("Exit", ::menu_control_close);
    menu thread menu_control();
    menu thread menu_monitor();
}

create_submenu()
{

}
