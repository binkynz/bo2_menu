#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\render;

menu_init(title, width, open)
{
    menu = spawnstruct();

    menu.open = true;
    menu.user = self;
    menu.width = width;
    menu.items = [];
    menu.base = menu menu_init_item(title, 0);
    menu.selected = 0;

    // doing these here means the base will have undefined color, making it white.
    // i like this effect.
    menu.inactive_color = (0, 0, 0);
    menu.active_color = (1, 0, 0);

    menu thread menu_control();
    menu thread menu_monitor_openclose();
    menu thread menu_monitor_destroy();

    return menu;
}

menu_close()
{
    self notify("close_menu");
}

menu_destroy()
{
    self notify("destroy_menu");
}

menu_init_item(name, offset)
{
    text = self.user createfontstring("default", 1);
    text setpoint("TOPCENTER", "TOPCENTER", 0, 0);
    text settext(name);

    shader = self.user render_create_shader("white", self.width, text.height, self.inactive_color, 0.2, -1);
    shader setpoint("TOPCENTER", "TOPCENTER", 0, offset);

    text setparent(shader);
    if (!self.open)
        shader render_hide_elem();

    return shader;
}

menu_add_item(name, func, is_menu)
{
    idx = self.items.size;

    self.items[idx] = spawnstruct();

    self.items[idx].item = self menu_init_item(name, (idx + 1) * self.base.height);
    self.items[idx].item setparent(self.base);

    if (idx == self.selected)
        self.items[idx].item.color = self.active_color;

    self.items[idx].func = func;
    self.items[idx].is_menu = is_menu;
}

menu_control()
{
    self endon("destroy_menu");
    self.user endon("disconnect");

    for (;;)
    {
        wait 0.05;

        self menu_control_open();

        if (!self.open)
            continue;

        self menu_control_scroll();
        self menu_control_item();
    }
}

menu_control_open()
{
    if (!self.open && self.user adsbuttonpressed() && self.user meleebuttonpressed())
        self notify("open_menu");
}

menu_control_scroll()
{
    up = self.user actionslotonebuttonpressed();
    down = self.user actionslottwobuttonpressed();
    if (up || down)
    {
        self.items[self.selected].item.color = self.inactive_color;

        if (down)
        {
            self.selected += 1;
            if (self.selected >= self.items.size)
                self.selected = 0;
        }
        else
        {
            self.selected -= 1;
            if (self.selected < 0)
                self.selected = self.items.size - 1;
        }

        self.items[self.selected].item.color = self.active_color;
    }
}

menu_control_item()
{
    if (!self.user usebuttonpressed())
        return;

    // not the best solution but meh
    while (self.user usebuttonpressed())
        wait 0.05;

    item = self.items[self.selected];
    if (!isdefined(item.is_menu))
        self thread [[item.func]]();
    else
    {
        self.user thread [[item.func]]();
        self menu_destroy();
    }
}

menu_monitor_openclose()
{
    self endon("destroy_menu");
    self.user endon("disconnect");

    for (;;)
    {
        if (!self.open)
        {
            self waittill("open_menu");
            self.base render_show_elem();
            self.open = true;
        }

        self waittill("close_menu");
        self.base render_hide_elem();
        self.open = false;
    }
}

menu_monitor_destroy()
{
    self.user endon("disconnect");

    self waittill("destroy_menu");
    self.base render_destroy_elem();
}
