//uzando os imputs aleatorios
uza_imputs()

//associando com move and colide as minhas variaveis velv e velh
associa_vel();

//passando de level
pega_rubi();

//qol
coyote_time();

//verifica se morreu
morri();

//checando se eu estou no chao e guardando na variavel chao
checa_chao();

//fazendo o efeito mola funcionar
efeito_mola_lerp(0.1);
efeito_branco_lerp(0.1);

//atualizando o estado
estado();

//full screen
if (keyboard_check_pressed(vk_f11)) window_set_fullscreen(!window_get_fullscreen());

if (keyboard_check_pressed(ord("R")) && instance_exists(obj_rubi) 
    && estado != estado_morrendo && uma_vez_reset)
{
    cria_transicao_inicia(room);
    uma_vez_reset = false;   
}