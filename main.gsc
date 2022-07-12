#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\menu;
#include scripts\zm\player;

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

    for(;;)
    {
        self waittill("spawned_player");
        self thread create_menu();
    }
}

create_menu()
{
    self endon("disconnect");

    menu = self menu_init("Sassy", 200);
    menu menu_add_menu("Lez", ::create_lez_submenu);
    menu menu_add_menu("Donny", ::create_donny_submenu);
    menu menu_add_menu("Mike", ::create_mike_submenu);
    menu menu_add_item("Exit", ::menu_close);
}

create_lez_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Lez", 200);
    menu menu_add_menu("Sassy", ::create_menu);
    menu menu_add_item("Player Health", ::toggle_player_health, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_donny_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Donny", 200);
    menu menu_add_menu("Sassy", ::create_menu);
    menu menu_add_item("Exit", ::menu_close);
}

create_mike_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Mike", 200);
    menu menu_add_menu("Sassy", ::create_menu);
    menu menu_add_item("Exit", ::menu_close);
}
