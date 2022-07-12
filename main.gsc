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

    menu = self menu_init("Sassy", 200);
    menu menu_add_item("Lez", ::create_lez_submenu, true);
    menu menu_add_item("Donny", ::create_donny_submenu, true);
    menu menu_add_item("Mike", ::create_mike_submenu, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_lez_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Lez", 200);
    menu menu_add_item("Sassy", ::create_menu, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_donny_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Donny", 200);
    menu menu_add_item("Sassy", ::create_menu, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_mike_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Mike", 200);
    menu menu_add_item("Sassy", ::create_menu, true);
    menu menu_add_item("Exit", ::menu_close);
}
