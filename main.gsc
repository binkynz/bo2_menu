#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\menu;
#include scripts\zm\player;
#include scripts\zm\server;

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

        self thread player_timer();
        self thread server_fast_zombies();

        // tests
        // self thread server_powerup_test();
    }
}

create_menu()
{
    self endon("disconnect");

    flag_wait("initial_blackscreen_passed");

    menu = self menu_init("Main Menu", 200);
    menu menu_add_menu("Client Menu", ::create_client_menu);
    menu menu_add_menu("Server Menu", ::create_server_menu);
    menu menu_add_item("Exit", ::menu_close);
}

create_client_menu()
{
    self endon("disconnect");

    menu = self menu_init("Client Menu", 200);
    menu menu_add_menu("Back", ::create_menu);
    menu menu_add_item("Show Game Time", ::toggle_player_timer, true);
    menu menu_add_item("Show Player Health", ::toggle_player_health, true);
    menu menu_add_item("Show Zombie Counter", ::toggle_player_zombie_counter, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_server_menu()
{
    self endon("disconnect");

    menu = self menu_init("Server Menu", 200);
    menu menu_add_menu("Back", ::create_menu);
    menu menu_add_menu("Zombie Menu", ::create_server_zombie_menu);
    menu menu_add_menu("Perk Menu", ::create_server_perk_menu);
    menu menu_add_menu("Powerup Menu", ::create_server_powerup_menu);
    menu menu_add_item("Exit", ::menu_close);
}

create_server_zombie_menu()
{
    self endon("disconnect");

    menu = self menu_init("Server Zombie Menu", 200);
    menu menu_add_menu("Back", ::create_server_menu);
    menu menu_add_item("Fast Zombie Spawn", ::toggle_server_fast_zombies, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_server_perk_menu()
{
    self endon("disconnect");

    menu = self menu_init("Server Perk Menu", 200);
    menu menu_add_menu("Back", ::create_server_menu);
    menu menu_add_item("Unlimited Perks", ::toggle_server_perk_limit, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_server_powerup_menu()
{
    self endon("disconnect");

    menu = self menu_init("Server Powerup Menu", 200);
    menu menu_add_menu("Back", ::create_server_menu);
    menu menu_add_item("Perk Powerup", ::toggle_server_powerup_perk, true);
    menu menu_add_item("PackAPunch Powerup", ::toggle_server_powerup_packapunch, true);
    menu menu_add_item("Exit", ::menu_close);
}
