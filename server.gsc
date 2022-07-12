#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\render;

toggle_fast_zombies()
{
    if (level.zombie_vars["zombie_spawn_delay"] != 0)
    {
        level.zombie_spawn_delay = level.zombie_vars["zombie_spawn_delay"];
        level.zombie_vars["zombie_spawn_delay"] = 0;
    }
    else
        level.zombie_vars["zombie_spawn_delay"] = level.zombie_spawn_delay;

    iprintln("Zombie Spawn Delay = " + level.zombie_vars["zombie_spawn_delay"]);
}

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
    self waittill("end_game");
    end_time = int(gettime() / 1000);

    for (;;)
    {
        level.server_timer settimer(end_time - start_time);

        wait 0.05;
    }
}
