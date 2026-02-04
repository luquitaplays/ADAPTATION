if (room == rm_final && uma_vez)
{
    // 1. Pega o ID (índice) do som que está tocando
    audio_stop_all();
    audio_play_sound(snd_room_final, 0, 1);
    uma_vez = false;
}