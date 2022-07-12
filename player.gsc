#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\render;

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
    self.player_health_text setpoint("CENTER", "BOTTOM", 0, 0);
    self.player_health_text.label = &"Health: ";

    for (;;)
    {
        self.player_health_text setvalue(self.health);

        wait 0.5;
    }
}
