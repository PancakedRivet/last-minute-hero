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
    score_animation = {42, 43, 44, 45, 46}
}

game_flags = {
    collision = 0
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