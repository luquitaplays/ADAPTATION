//variaveis
global.r_name = false;
global.l_name = false;
global.j_name = false;

global.level = 0;
global.todos_levels = 10;

global.nome_imputs =
[
    "A", "B", "C", "D", "E", "F", "G",
    "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "S", "T", "U",
    "V", "W", "X", "Y", "Z",
    
    "SPACE", "CTRL", "ALT", "ENTER"
];


//funçoes
function end_animation(_num = image_number)
{
    //se a animaçao chegar no fim troca para a animaçao do meio
    //_intervalo é o quanto o image_index aumenta por frame
    var _intervalo = sprite_get_speed(sprite_index) / 60;
    //isso verifica se o proximo quadro passa do image number
    if (image_index + _intervalo >= _num)
    {
        //animation end = true
        return true;
    }
    else 
    {
        //animation end = false
    	return false;
    }
}

function atualiza_colisao(array, objeto, adicionar_ou_nao)
{
    if (adicionar_ou_nao)
    {
        //se n tem ainda
        if (!array_contains(array, objeto))
        {
            //adiciona
            array_push(array, objeto);
        }
    }
    else 
    {
        //se tem 
        if (array_contains(array, objeto))
        {
            //deleta
            array_delete(array, array_get_index(array, objeto), 1);
        }
    }
    return array;
}
