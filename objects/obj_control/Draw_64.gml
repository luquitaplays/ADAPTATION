if (room == rm_explication || room == rm_final) return;

draw_set_font(fnt_pixel_menor);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(1175, 20, "Level: " + string(global.level) + "/" + string(global.todos_levels));

draw_set_halign(-1);
draw_set_valign(-1);

draw_set_font(-1);