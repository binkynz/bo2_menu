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

        self thread server_timer();
        self thread server_fast_zombies();
    }
}

create_menu()
{
    self endon("disconnect");

    flag_wait("initial_blackscreen_passed");

    menu = self menu_init("Main Menu", 200);
    menu menu_add_menu("Client", ::create_client_submenu);
    menu menu_add_menu("Server", ::create_server_submenu);
    menu menu_add_item("Exit", ::menu_close);
}

create_client_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Client", 200);
    menu menu_add_menu("Back", ::create_menu);
    menu menu_add_item("Show Player Health", ::toggle_player_health, true);
    menu menu_add_item("Show Zombie Counter", ::toggle_player_zombie_counter, true);
    menu menu_add_item("Exit", ::menu_close);
}

create_server_submenu()
{
    self endon("disconnect");

    menu = self menu_init("Server", 200);
    menu menu_add_menu("Back", ::create_menu);
    menu menu_add_item("Show Game Time", ::toggle_server_timer, true);
    menu menu_add_item("Fast Zombie Spawn", ::toggle_server_fast_zombies, true);
    menu menu_add_item("Unlimited Perks", ::toggle_server_perk_limit, true);
    menu menu_add_item("Allow Perk Powerup", ::toggle_server_powerup_perk, true);
    menu menu_add_item("Allow PackAPunch Powerup", ::toggle_server_powerup_packapunch, true);
    menu menu_add_item("Exit", ::menu_close);
}
