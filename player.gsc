#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\render;

toggle_player_timer()
{
    if (level.player_timer.hidden)
        level.player_timer render_show_elem();
    else
        level.player_timer render_hide_elem();
}

player_timer()
{
    self endon("disconnect");

    level.player_timer = render_player_timer("left", "top", "user_left", "user_top");
    level.player_timer render_hide_elem();
    level.player_timer settimerup(0);

    start_time = int(gettime() / 1000);
    level waittill("end_game");
    end_time = int(gettime() / 1000);

    for (;;)
    {
        level.player_timer settimer(end_time - start_time);

        wait 0.05;
    }
}

toggle_player_health()
{
    self notify("stop_player_health");

    if (isdefined(self.player_health_text))
        self.player_health_text render_destroy_elem();
    else
        self thread player_health();
}

player_health()
{
    self endon("disconnect");
    self endon("stop_player_health");

    self.player_health_text = self createfontstring("default", 1);
    self.player_health_text setpoint("BOTTOM LEFT", "BOTTOM LEFT", 0, 0);
    self.player_health_text.label = &"Health: ^2";

    for (;;)
    {
        self.player_health_text setvalue(self.health);

        wait 0.05;
    }
}

toggle_player_zombie_counter()
{
    self notify("stop_player_zombie_counter");

    if (isdefined(self.player_zombie_text))
        self.player_zombie_text render_destroy_elem();
    else
        self thread player_zombie_counter();
}

player_zombie_counter()
{
    self endon("disconnect");
    self endon("stop_player_zombie_counter");

    self.player_zombie_text = self createfontstring("default", 1);
    self.player_zombie_text setpoint("BOTTOM", "BOTTOM", 0, 0);
    self.player_zombie_text.label = &"Zombies: ^1";

    for (;;)
    {
        self.player_zombie_text setvalue(get_round_enemy_array().size + level.zombie_total);

        wait 0.05;
    }
}
