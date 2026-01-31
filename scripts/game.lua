game_states = {
    new_game = 0,
    playing = 1,
    game_over = 2,
    shop = 3
}

game_sprites = {
    health = 40,
    health_animation = {40, 41},
    coin = 36,
    coin_animation = {36, 37, 38, 39},
    score = 42,
    score_animation = {42, 43, 44, 45, 46},
    shop_opened = 6,
    shop_closed = 5,
    corpse = 12
}

-- sound notes
-- tilted saw = player
-- noise = enemy
-- triangle = system
game_sfx = {
    coin_collect = 0,
    player_dash = 1,
    enemy_spawn = 2,
    enemy_die = 3,
    player_hurt = 4,
    player_dash_reset = 5,
    player_attack = 6,
    enemy_attack = 7,
    shop_menu_movement = 8,
    shop_insufficient_funds = 9,
    shop_purchase = 10,
    shop_open = 11,
    shop_close = 12,
    corpse_hit = 13,
    game_over = 14
}

game_flags = {
    collision = 0,
    shop = 1
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
    corpse = {
        x = 96,
        y = 96,
        sp = game_sprites.corpse,
        attacked = false,
        gold_value = 25,
        score_penalty = 10
    }
    enemies = {}
    spawning_enemies = {}
    dying_enemies = {}
    coins = {}
    game_tick = 0
    mapx = 0 
    mapy = 0
    game_state = game_states.playing
end

function draw_coins()
    for coin in all(coins) do
        -- spr(coin.sp, coin.x, coin.y)
        local coin_animation_frame = flr((global_game_tick - coin.current_tick) / (5)) % #game_sprites.coin_animation + 1
        spr(game_sprites.coin_animation[coin_animation_frame], coin.x, coin.y)
    end
end

-- Update animation for a character
function update_animation(_animation_tick, _animation_idx, _animation_sprite_count, _animation_frames_per_sprite)
    _animation_tick += 1
    if _animation_tick >= _animation_frames_per_sprite then
        _animation_tick = 0
        _animation_idx += 1
        if _animation_idx > _animation_sprite_count then
            _animation_idx = 1
        end
    end
    new_animation = {
        animation_tick = _animation_tick,
        animation_idx = _animation_idx
    }
    return new_animation
end