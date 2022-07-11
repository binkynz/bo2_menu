#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\render;

menu_init(title, width)
{
    menu = spawnstruct();
    menu.open = false;

    menu.user = self;
    menu.title = title;
    menu.width = width;
    menu.tabs = [];

    menu.selected_tab = 0;

    return menu;
}

menu_add_tab(name)
{
    idx = self.tabs.size;
    self.tabs[idx] = spawnstruct();
    self.tabs[idx].name = name;
    self.tabs[idx].options = [];
}

menu_control()
{
    self.user endon("disconnect");

    for (;;)
    {
        if (self.user adsbuttonpressed() && self.user meleebuttonpressed())
        {
            self.open = !self.open;
            wait 0.1;
        }

        if (self.open)
        {
            if(self.user actionslotonebuttonpressed())
                self.selected_tab -= 1;
            else if (self.user actionslottwobuttonpressed())
                self.selected_tab += 1;

            if (self.selected_tab < 0)
                self.selected_tab = self.tabs.size - 1;
            else if (self.selected_tab >= self.tabs.size)
                self.selected_tab = 0;
        }

        wait 0.05;
    }
}

menu_draw()
{
    self.user endon("disconnect");

    title_text = self.user createfontstring("default", 1);
    title_text setpoint("TOPCENTER", "TOPCENTER", 0, 0);
    title_text settext(self.title);

    text_height = title_text.height;
    background_height = (self.tabs.size + 1) * text_height;

    background = self.user render_create_shader("white", self.width, background_height, (0, 0, 0), 0.2, -2);
    background setpoint("TOPCENTER", "TOPCENTER", 0, 0);

    title_text setparent(background);

    for (i = 0; i < self.tabs.size; i++)
    {
        tab_text = self.user createfontstring("default", 1);
        tab_text setpoint("TOPCENTER", "TOPCENTER", 0, (i + 1) * text_height);
        tab_text settext(self.tabs[i].name);
        tab_text setparent(background);
    }

    tab_selected = self.user render_create_shader("white", self.width, text_height, (1, 0, 0), 0.2, -1);
    tab_selected setpoint("TOPCENTER", "TOPCENTER", 0, text_height);
    tab_selected setparent(background);

    for (;;)
    {
        if (!self.open)
            background render_hide_elem();
        else
        {
            background render_show_elem();
            tab_selected setpoint("TOPCENTER", "TOPCENTER", 0, (self.selected_tab + 1) * text_height);
        }

        wait 0.1;
    }
}
