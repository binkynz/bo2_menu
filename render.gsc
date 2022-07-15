#include maps\mp\gametypes_zm\_hud_util;

/*
^0 = Black
^1 = Red/Orange
^2 = Lime Green
^3 = Yellow
^4 = Dark Blue
^5 = Light Blue
^6 = Purple
^7 = White/Default
^8 = Black
*/

render_create_shader(shader, width, height, color, alpha, sort)
{
    hud = newclienthudelem(self);

    hud.elemtype = "icon";
    hud.x = 0;
    hud.y = 0;
    hud.width = width;
    hud.height = height;
    hud.sort = sort;
    hud.color = color;
    hud.alpha = alpha;
    hud.stored_alpha = alpha;
    hud.children = [];
    hud.hidden = false;
    hud setparent(level.uiparent);
    hud setshader(shader, width, height);

    return hud;
}

render_server_timer(alignx, aligny, horzalign, vertalign)
{
    hud = createservertimer("default", 1);

    hud.alignx = alignx;
    hud.aligny = aligny;
    hud.horzalign = horzalign;
    hud.vertalign = vertalign;
    hud.foreground = true;

    return hud;
}

render_player_timer(alignx, aligny, horzalign, vertalign)
{
    hud = createclienttimer("default", 1);

    hud.alignx = alignx;
    hud.aligny = aligny;
    hud.horzalign = horzalign;
    hud.vertalign = vertalign;
    hud.foreground = true;

    return hud;
}

render_hide_elem()
{
    if (self.hidden)
        return;

    foreach (child in self.children)
        child render_hide_elem();

    self hideelem();
}

render_show_elem()
{
    if (!self.hidden)
        return;

    foreach (child in self.children)
    {
        child render_show_elem();
        child.alpha = child.stored_alpha;
    }

    self showelem();
    self.alpha = self.stored_alpha;
}

render_destroy_elem()
{
    foreach (child in self.children)
        child render_destroy_elem();

    self destroyelem();
}
