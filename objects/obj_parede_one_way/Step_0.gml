if (!instance_exists(obj_player)) return;

if (obj_player.y - 1 > y) mask_index = spr_vasia;
else mask_index = sprite_index;