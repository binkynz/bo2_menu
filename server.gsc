#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\render;

toggle_server_fast_zombies()
{
    if (!isdefined(level.is_fast_zombies))
        level.is_fast_zombies = false;

    level.is_fast_zombies = !level.is_fast_zombies;

    level notify("toggled_fast_zombies");
}

server_fast_zombies()
{
    self endon("disconnect");

    for (;;)
    {
        level waittill_any("toggled_fast_zombies", "end_of_round");

        if (isdefined(level.is_fast_zombies) && level.is_fast_zombies)
            level.zombie_vars["zombie_spawn_delay"] = 0;
        else if (level.round_number == 1)
            level.zombie_vars["zombie_spawn_delay"] = 2;
        else
        {
            level.zombie_vars["zombie_spawn_delay"] = 2;
            for (i = 2; i <= level.round_number; i++)
            {
                if (level.zombie_vars["zombie_spawn_delay"] > 0.08)
                    level.zombie_vars["zombie_spawn_delay"] *= 0.95;
                else
                    level.zombie_vars["zombie_spawn_delay"] = 0.08;
            }
        }

        self iprintln("zombie_spawn_delay = " + level.zombie_vars["zombie_spawn_delay"]);
    }
}

toggle_server_perk_limit()
{
    if (!isdefined(level.is_unlimited_perks))
        level.is_unlimited_perks = false;

    level.is_unlimited_perks = !level.is_unlimited_perks;

    if (level.is_unlimited_perks)
        level.perk_purchase_limit = 9; // change from being fixed
    else
        level.perk_purchase_limit = 4;

    iprintln("perk_purchase_limit = " + level.perk_purchase_limit);
}

toggle_server_powerup_perk()
{
    server_powerup_grab_init();

    if (!isdefined(level.is_powerup_perk))
        level.is_powerup_perk = false;

    level.is_powerup_perk = !level.is_powerup_perk;

    if (level.is_powerup_perk)
        level.zombie_powerups["perk"].func_should_drop_with_regular_powerups = ::func_should_always_drop;
    else
        level.zombie_powerups["perk"].func_should_drop_with_regular_powerups = ::func_should_never_drop;

    iprintln("is_powerup_perk = " + level.is_powerup_perk);
}

toggle_server_powerup_packapunch()
{
    server_powerup_grab_init();

    if (!isdefined(level.is_powerup_packapunch))
        level.is_powerup_packapunch = false;

    level.is_powerup_packapunch = !level.is_powerup_packapunch;

    if (level.is_powerup_packapunch)
        level.zombie_powerups["packapunch"].func_should_drop_with_regular_powerups = ::func_should_always_drop;
    else
        level.zombie_powerups["packapunch"].func_should_drop_with_regular_powerups = ::func_should_never_drop;

    iprintln("is_powerup_packapunch = " + level.is_powerup_packapunch);
}

server_powerup_grab_init()
{
    if (isdefined(level.is_server_powerup_grab_init))
        return;

    if (isdefined(level._zombiemode_powerup_grab))
        level.stored_zombiemode_powerup_grab = level._zombiemode_powerup_grab;

    level._zombiemode_powerup_grab = ::server_powerup_grab;

    include_zombie_powerup("perk");
    include_zombie_powerup("packapunch");
    add_zombie_powerup("perk", "t6_wpn_zmb_perk_bottle_sleight_world", &"ZOMBIE_POWERUP_PERK", ::func_should_never_drop, 0, 0, 0);
    add_zombie_powerup("packapunch", "t6_wpn_zmb_raygun2_upg_world", &"ZOMBIE_POWERUP_PACKAPUNCH", ::func_should_never_drop, 0, 0, 0);

    level.is_server_powerup_grab_init = true;
}

server_powerup_test()
{
    self endon("disconnect");

    for (;;)
    {
        if (self meleebuttonpressed())
        {
            self server_powerup_force_drop();

            while (self meleebuttonpressed())
                wait 0.05;
        }

        wait 0.05;
    }
}

server_powerup_force_drop()
{
    powerup = network_safe_spawn("powerup", 1, "script_model", self.origin
        + vectorscale(anglestoforward(self.angles), 70)
        + vectorscale((0, 0, 1), 40));

    if (!isdefined(powerup))
        return;

    powerup powerup_setup();
    powerup thread powerup_timeout();
    powerup thread powerup_wobble();
    powerup thread powerup_grab();
    powerup thread powerup_move();
    powerup thread powerup_emp();

    level notify("powerup_dropped", powerup);
}

server_powerup_grab(powerup, player)
{
    switch (powerup.powerup_name)
    {
        case "perk":
            level thread server_perk_powerup(powerup, player);
            break;
        case "packapunch":
            level thread server_packapunch_powerup(powerup, player);
            break;
        default:
            level thread [[level.stored_zombiemode_powerup_grab]](powerup, player);
            break;
    }
}

server_perk_powerup(powerup, player)
{
    player endon("disconnect");

    if (player player_is_in_laststand() || player.sessionstate == "spectator")
        return;

    free_perk = player give_random_perk();
    player iprintln("perk recieved: " + free_perk);

    if (level.disable_free_perks_before_power)
        player thread disable_perk_before_power(free_perk);
}

server_packapunch_powerup(powerup, player)
{
    player endon("disconnect");

    if (is_true(player.has_powerup_weapon))
        return;

    weapon_name = player getcurrentweapon();
    if (!can_upgrade_weapon(weapon_name))
        return;

    player.has_powerup_weapon = true;
    player increment_is_drinking();

    weapon = get_upgrade_weapon(weapon_name, will_upgrade_weapon_as_attachment(weapon_name));

    player giveweapon(weapon, 0, player get_pack_a_punch_weapon_options(weapon));
    player switchtoweapon(weapon);

    // should add a icon/text displaying time remaining

    countdown = 30;
    while (countdown > 0)
    {
        wait 0.05;
        countdown -= 0.05;
    }

    player takeweapon(weapon);
    player switchtoweapon(weapon_name);

    player.has_powerup_weapon = false;
    player decrement_is_drinking();
}
