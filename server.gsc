#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\render;

toggle_server_timer()
{
    if (level.server_timer.hidden)
        level.server_timer render_show_elem();
    else
        level.server_timer render_hide_elem();
}

server_timer()
{
    self endon("disconnect");

    level.server_timer = render_server_timer("left", "top", "user_left", "user_top");
    level.server_timer render_hide_elem();
    level.server_timer settimerup(0);

    start_time = int(gettime() / 1000);
    level waittill("end_game");
    end_time = int(gettime() / 1000);

    for (;;)
    {
        level.server_timer settimer(end_time - start_time);

        wait 0.05;
    }
}

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

        if (level.is_fast_zombies)
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
        level.perk_purchase_limit = 9;
    else
        level.perk_purchase_limit = 4;

    iprintln("perk_purchase_limit = " + level.perk_purchase_limit);
}
