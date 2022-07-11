#include maps\mp\gametypes_zm\_hud_util;

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

render_hide_elem()
{
    if (self.hidden)
        return;

    foreach (child in self.children)
        child hideelem();

    self hideelem();
}

render_show_elem()
{
    if (!self.hidden)
        return;

    foreach (child in self.children)
    {
        child showelem();
        child.alpha = child.stored_alpha;
    }

    self showelem();
    self.alpha = self.stored_alpha;
}
