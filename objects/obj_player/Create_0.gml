//variaveis

//velocidade
vel = 1.5;
velh = 0;
velv = 0;
mc_vel_muda_dir_ar = 0.035;
mc_vel_muda_dir = 0.1;
vel_muda_dir = mc_vel_muda_dir;

//teclas
right = false;
left = false;
jump = false;
jump_r = false;

right_escolhido = false;
left_escolhido  = false;
jump_escolhido  = false;

//checar o chao
chao = false;
parede_dir = 0;
parede_esq = 0;

//checar o teto
teto = false;
begin_caindo = false;

//gravidade
mc_grav = 0.15;
grav = mc_grav;

//força do meu pulo
forca_pulo = 3.3;

//o quão rapido eu posso ir verticalmente
max_velv = 12;

//janela de variaveis
view_player = noone;

//variavel da direcao do player
dir = dir_inicial;

//staticas
uma_vez = true;
uma_vez_encosta = true;
uma_vez_reset = true;

//coyote time
coyote_espera = 6;
coyote_timer = coyote_espera;

//variavel com as minhas colisoes
//pegando tiles
tile_chao = layer_tilemap_get_id("Tile_Chao");
colizion = [obj_parede, obj_parede_one_way, tile_chao];
colizion_dano = [obj_espinhos];
//transicao de sprites
transicao_pulo_pra_queda = [spr_player_jump_fall, spr_player_fall];

transicao_atual = [];
spr_atual = 0;

inputs_possiveis =
[
    ord("A"), ord("B"), ord("C"), ord("D"), ord("E"), ord("F"), ord("G"),
    ord("H"), ord("I"), ord("J"), ord("K"), ord("L"), ord("M"), ord("N"),
    ord("O"), ord("P"), ord("Q"), ord("S"), ord("T"), ord("U"),
    ord("V"), ord("W"), ord("X"), ord("Y"), ord("Z"),
    
    vk_space, vk_control, vk_alt, vk_enter
];

//iniciando efeitos
inicia_efeito_mola();
inicia_efeito_branco();
scribble_anim_wave(0.3, 1.5, 0.12);
scribble_anim_wheel(0.2, 1.2, 0.15);
scribble_anim_jitter(0.8, 1.2, 0.1);
scribble_anim_pulse(0.3, 0.1);
scribble_anim_shake(1, 0.1);
scribble_anim_wobble(30, 0.2);

inicio_aleatorio = function()
{
    // Verifica se a room atual é rm_explication
    if (room == rm_explication || room == rm_final)
    {
        // Se for rm_explicacao, define os inputs especificamente (D, A, Espaço).
        var r_index = 3;
        var l_index = 0;
        var j_index = 25;
        
        // Guarda os índices escolhidos
        global.r_name = r_index;
        global.l_name = l_index;
        global.j_name = j_index;
        
        // Guarda os códigos dos inputs escolhidos
        right_escolhido = inputs_possiveis[r_index];
        left_escolhido  = inputs_possiveis[l_index];
        jump_escolhido  = inputs_possiveis[j_index];
    }
    else
    {
        // Se NÃO for rm_explicacao, usa a lógica de randomização original
        randomize();
        
        var _array_num = array_length(inputs_possiveis) - 1;
        
        var r = irandom_range(0, _array_num);
        var l = irandom_range(0, _array_num);
        while (l == r) l = irandom_range(0, _array_num);
        var j = irandom_range(0, _array_num);
        while (j == r || j == l) j = irandom_range(0, _array_num);
        
        // Guarda os índices escolhidos
        global.r_name = r;
        global.l_name = l;
        global.j_name = j;
        
        // Guarda os códigos dos inputs escolhidos
        right_escolhido = inputs_possiveis[r];
        left_escolhido  = inputs_possiveis[l];
        jump_escolhido  = inputs_possiveis[j];
    }
}

uza_imputs = function()
{
    right = keyboard_check(right_escolhido);
    left = keyboard_check(left_escolhido);
    jump = keyboard_check_pressed(jump_escolhido);
    jump_r = keyboard_check_released(vk_space);
}

//aplicando as velocidades
movimento = function()
{ 
    var _velh = (right - left) * vel;
    
    // Se eu estou no chão, eu passo direto o valor do _velh para o velh
    if (chao)
    {
        velh = _velh;
    }
    else
    {
        // Eu mudo de pouquinho em pouquinho o valor do velh com base no _velh
        velh = lerp(velh, _velh, vel_muda_dir);
    }
    
    //se eu estou no chao minha velv = 0;
    if (chao)
    {
        //falando que meu velv e 0
        velv = 0;
        //se eu pula
        if (jump)
        {
            velv = -forca_pulo;
            audio_play_sound(snd_pulo, 0, 0);
        }
        y = round(y);
    }
    else //se eu n to no chao eu to pulando (caindo)
    {
        if (estado == estado_desliza_parede)
        {
            if(jump)
            {
                velv = -forca_pulo + 0.3;
                velh = 1.8 * -dir;
                spr_atual = 0;
                audio_play_sound(snd_pulo, 0, 0);
            }
        }
        
        velv += grav;
    }
    
    var _my_sprite = sprite_width / 2 - 10;
    x = clamp(x, 0 + _my_sprite, room_width - _my_sprite);
    
    //fazendo o meu velver estar abaixo do limite
    velv = clamp(velv, -max_velv, max_velv);
}

//passando de level
pega_rubi = function()
{
    var _rubi = instance_place(x, y, obj_rubi);
    if (_rubi && estado != estado_morrendo)
    {
        instance_destroy(_rubi);
        audio_play_sound(snd_pega_rubi, 0, 0);
    }
    
    if (!instance_exists(obj_rubi) && room != rm_final && estado != estado_morrendo && uma_vez)
    {
        cria_transicao_inicia(room_next(room));
        global.level++;
        uma_vez = false;
    }
}

//associando as velocidades
associa_vel = function()
{
    //usando o velh no x
    move_and_collide(velh, 0, colizion);
    //usando velv no y
    move_and_collide(0, velv, colizion);
}

//trocando de lado se eu estou olhando pra esquerda
checa_direcao = function()
{
    //se eu for para a esquerda
    if (velh < 0)
    {
        //a direcao e olho para a esquerda
        dir = -1;
    }
    else if (velh > 0) //se for ara direita
    {
        //a direcao e pra direita
        dir = 1;
    }
}

morri = function()
{
    if (place_meeting(x, y, colizion_dano) && uma_vez_encosta)
    {
        cria_transicao_inicia(room);
        audio_play_sound(snd_morre, 0, 0);
        uma_vez_encosta = false;
    }
}

//checando e guardando na variavel chão 
checa_chao = function()
{
    //chao = true ou false. dependando se ta encostando ou n
    chao = place_meeting(x, y + 1, colizion);
    //checando o teto
    //o 'sign' transforma -5 ou -3 ou -2 em -1
    //5 ou 10 ou 4000 em 1
    //o simbolo '+' é devido porque a velv é negativa. + com - = -(em cima)
    teto = place_meeting(x, y + sign(velv), colizion)
    //paredes
    parede_dir = place_meeting(x + 1, y, colizion);
    parede_esq = place_meeting(x - 1, y, colizion);
}

//coyote time metodo
coyote_time = function()
{
    if (!chao) 
    {
        if (coyote_timer > 0) coyote_timer--;
    }
    else coyote_timer = coyote_espera;
}

//animaçoes

//trocando a sprite
troca_sprite = function(_spr = spr_player_idle)
{
    //se a minha sprite atual for diferente da sprite escolida
    if (sprite_index != _spr)
    {
        //coloque a sprite certa
        sprite_index = _spr;
        //e a imagem no 0(o começo)
        image_index = 0;
    }  
}

transicao_de_sprites = function()
{
    troca_sprite(transicao_atual[spr_atual]);
    
    if (end_animation() && spr_atual < array_length(transicao_atual) - 1)
    {
        spr_atual += 1;
    }
}

mudando_transicao_de_sprites = function(_array)
{
    transicao_atual = _array;
}

#region maquina de estado

//estados

//estado parado
estado_parado = function()
{
    troca_sprite(spr_player_idle);
    
    //posso movimentar
    movimento();
    //checando para onde estou olhando
    checa_direcao();
    
    //se eu apertar pra direita e pra esquerda = false
    //se eu aperto direita e n aperto esquerda = true
    //se eu n aperto nem um e = false
    //ele ve se os valores sao diferentes
    if (right != left)
    {
        //troca o estado
        estado = estado_movendo;
    }
    //se eu pular ou se eu n to no chao eu to pulando (ou caindo)
    if (jump && chao)
    {
        efeito_set_mola(0.5, 1.5);
        //troca o estado
        estado = estado_pulando;
        spr_atual = 0;
    }
    if (!chao)
    {
        //troca o estado 
        estado = estado_pulando;
        spr_atual = 0;
    }
    if (place_meeting(x, y, colizion_dano))
    {
        estado = estado_morrendo;
        velv = -1;
    }
} 

//estado se movendo
estado_movendo = function()
{
    troca_sprite(spr_player_walk);
    
    //posso movimentar
    movimento();
    //checando para onde estou olhando
    checa_direcao();
    
    //se eu estiver parado horizontamente
    if (velh == 0)
    {
       //troca o estado pro parado 
       estado = estado_parado; 
    }
    //se eu pular
    if (jump && chao)
    {
        efeito_set_mola(0.5, 1.5);
        //vai para o estado pulando
        estado = estado_pulando;
        spr_atual = 0;
    }
    //se eu n to no chao
    if (!chao)
    {
        estado = estado_pulando;
        spr_atual = 0;
    }
    if (place_meeting(x, y, colizion_dano))
    {
        estado = estado_morrendo;
        velv = -1;
    }
}

//estado de quando eu estiver no pulo
estado_pulando = function()
{
    //posso movimentar
    movimento();
    //checando para onde estou olhando
    checa_direcao();
    
    //se eu encostar no chao
    if (chao)
    {
        efeito_set_mola(1.5, 0.7);
        estado = estado_parado;
        
        begin_caindo = false;
        
        //se eu pular
        if (jump)
        {
            efeito_set_mola(0.5, 1.5);
            //vai para o estado pulando
            estado = estado_pulando;
            spr_atual = 0;
        }
        return;
    }
    
    //se eu encostei no teto
    if (teto)
    {
        //zerando velv
        velv = 0;
    }
    
    
    //se eu n estiver encostando no chao e estiver caindo
    if (velv >= 0)
    {
        //se é a primeira vez caindo
        if (!begin_caindo)
        {
            //faz a virada
            mudando_transicao_de_sprites(transicao_pulo_pra_queda);
            
            //reseta valores
            spr_atual = 0;
            begin_caindo = true;
        }
        
        //COYOTE TIME
        if (jump && coyote_timer)
        {
            //fazendo ele pular
            velv = -forca_pulo;
            //efeitos
            efeito_set_mola(0.7, 1.5);
            audio_play_sound(snd_pulo, 0, 0);
            //vai para o estado pulando
            estado = estado_pulando;
            //garantindo que vou fazer apenas uma vez
            coyote_timer = 0;
        }
        
        transicao_de_sprites();
        
        if (parede_dir || parede_esq)
        {
            estado = estado_desliza_parede;
            velv = 0;
        }
    }
    else // se eu n estiver encostando no chao e estiver subindo
    {
        troca_sprite(spr_player_jump);
        
        //se eu soltar o botão de pulo
        if (jump_r)
        {
            //corto velv pela metade
            velv /= 2;
        }
    }
    
    //se eu colidir com dano
    if (place_meeting(x, y, colizion_dano))
    {
        estado = estado_morrendo;
        velv = -1;
    }
}

//dezlizando
estado_desliza_parede = function()
{
    troca_sprite(spr_player_wall);
    
    movimento();
    
    grav = 0;
    
    velv += 0.02;
    
    if (jump)
    {
        estado = estado_wall_jump;
        grav = mc_grav;
    }
    if (!parede_dir && !parede_esq)
    {
        estado = estado_pulando;
        grav = mc_grav;
    }
    if (chao)
    {
        estado = estado_parado;
        grav = mc_grav;
    }
    if (place_meeting(x, y, colizion_dano))
    {
        estado = estado_morrendo;
        velv = -1;
    }
}

//pulando pro wall jump
estado_wall_jump = function()
{
    troca_sprite(spr_player_wall_jump);
    
    movimento();
    checa_direcao();
    
    vel_muda_dir = mc_vel_muda_dir_ar;
    
    //se eu encostei no teto
    if (teto)
    {
        //zerando velv
        velv = 0;
    }
    if (parede_dir || parede_esq)
    {
        estado = estado_desliza_parede;
        velv = 0;
        vel_muda_dir = mc_vel_muda_dir;
    }
    if (chao)
    {
        efeito_set_mola(1.5, 0.7);
        estado = estado_parado;
        vel_muda_dir = mc_vel_muda_dir;
    }
    if (place_meeting(x, y, colizion_dano))
    {
        estado = estado_morrendo;
        velv = -1;
    }
}

//estado de morrer
estado_morrendo = function()
{
    troca_sprite(spr_player_morre);
}

//definindo o estado inicial
estado = estado_parado;

#endregion
