#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\render;

menu_init(title, width)
{
    menu = spawnstruct();

    menu.open = true;
    menu.user = self;
    menu.width = width;
    menu.items = [];
    menu.stored_items = [];
    menu.base = menu menu_init_item(title, 0);
    menu.selected = 0;

    return menu;
}

menu_init_item(name, offset)
{
    text = self.user createfontstring("default", 1);
    text setpoint("TOPCENTER", "TOPCENTER", 0, 0);
    text settext(name);

    shader = self.user render_create_shader("white", self.width, text.height, (0, 0, 0), 0.2, -1);
    shader setpoint("TOPCENTER", "TOPCENTER", 0, offset);

    text setparent(shader);
    if (!self.open)
        shader render_hide_elem();

    return shader;
}

menu_add_item(name, func)
{
    idx = self.items.size + 1;

    self.items[name] = spawnstruct();

    self.items[name].item = self menu_init_item(name, idx * self.base.height);
    self.items[name].func = func;
    self.items[name].is_selected = idx == 1;
}

menu_control()
{
    self.user endon("disconnect");

    for (;;)
    {
        wait 0.05;

        if (!self.open)
            continue;

        up = self.user actionslotonebuttonpressed();
        down = self.user actionslottwobuttonpressed();
        if (up || down)
        {
            item_keys = getarraykeys(self.items);

            self.items[item_keys[self.selected]].is_selected = false;
            if (up)
            {
                self.selected -= 1;
                if (self.selected < 0)
                    self.selected = item_keys.size - 1;
            }
            else
            {
                self.selected += 1;
                if (self.selected >= item_keys.size)
                    self.selected = 0;
            }

            self.items[item_keys[self.selected]].is_selected = true;

            self.user iprintln(self.selected);
        }
    }
}
