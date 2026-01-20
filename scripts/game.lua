game_states = {
    new_game = 0,
    playing = 1,
    game_over = 2,
    shop = 3
}

game_sprites = {
    health = 2,
    enemy = 17,
    coin = 3,
    score = 19
}

colours ={
    black = 0,
    dark_blue = 1,
    dark_purple = 2,
    dark_green = 3,
    brown = 4,
    dark_grey = 5,
    light_grey = 6,
    white = 7,
    red = 8,
    orange = 9,
    yellow = 10,
    green = 11,
    blue = 12,
    indigo = 13,
    pink = 14,
    peach = 15
}

function new_game()
    player = new_player()
    game_state = game_states.playing
end

function draw_coins()
    for coin in all(coins) do
        spr(coin.sp, coin.x, coin.y)
    end
end