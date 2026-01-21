player_animation_sprites_walk = {48, 49, 50, 51}
player_animation_frames_per_sprite = 6

function new_player()
    local player = {
        sp = 48,
        x = 64,
        y = 64,
        sp_flipx = false,
        sp_flipy = false,
        animation_idx = 1,
        animation_tick = 0,
        speed = 2,
        health = 60,
        max_health = 60,
        attack = 10,
        attack_tick = 0,
        attack_tick_max = 15,
        attack_tick_start = 10,
        attack_tick_end = 5,
        defense = 5,
        score = 0,
        score_value = 1,
        coins = 0,
        coin_value = 1,
    }
    return player
end

function update_position(_player)
    local max_pos_x = 122
    local max_pos_y = 120
    local min_pos_x = -2
    local min_pos_y = 10
    local _update_animation_walk = false

    if btn(⬅️) then
        if _player.x - _player.speed > min_pos_x then
            _player.x -= _player.speed
            _update_animation_walk = true
        end
        _player.sp_flipx = true
    end

    if btn(➡️) then
        if _player.x + _player.speed < max_pos_x then
            _player.x += _player.speed
            _update_animation_walk = true
        end
        _player.sp_flipx = false
    end

    if btn(⬆️) then
        if _player.y - _player.speed > min_pos_y then
            _player.y -= _player.speed
            _update_animation_walk = true
        end
    end

    if btn(⬇️) then
        if _player.y + _player.speed < max_pos_y then
            _player.y += _player.speed
            _update_animation_walk = true
        end
    end

    if _update_animation_walk then
        update_animation_walk(_player, #player_animation_sprites_walk, player_animation_frames_per_sprite)
    else
        _player.animation_idx = 1
    end
end

function update_attack(_player)
    -- Only attack if not already attacking
    if btnp(❎) and _player.attack_tick == 0 then
        _player.attack_tick = _player.attack_tick_max -- Attack duration in ticks
    end
    if _player.attack_tick > 0 then
        _player.attack_tick -= 1
        -- Check for enemy collisions
        local sprite_width = 8
        local attack_sgn = _player.sp_flipx and 1 or -1
        local attack_range = sprite_width * attack_sgn
        if _player.attack_tick < _player.attack_tick_start and _player.attack_tick > _player.attack_tick_end then
            for enemy in all(enemies) do
                if not enemy.attacked then
                    if (_player.x - enemy.x) < attack_range and abs(_player.y - enemy.y) < abs(attack_range) then
                        enemy.health -= _player.attack
                        enemy.attacked = true
                        if enemy.health <= 0 then
                            del(enemies, enemy)
                            add(coins, { x = enemy.x, y = enemy.y, sp = game_sprites.coin }) -- Spawn a coin where the enemy died
                            _player.score += _player.score_value
                        end
                    end
                end
            end
        end
    end
    if _player.attack_tick < 0 then
        _player.attack_tick = 0
    end
    -- Stop the same enemy from being attacked multiple times in one attack
    if _player.attack_tick == 0 then
        for enemy in all(enemies) do
            enemy.attacked = false
        end
    end
end

function draw_player(_player)
    spr(player_animation_sprites_walk[_player.animation_idx], _player.x, _player.y, 1, 1, _player.sp_flipx, _player.sp_flipy)
end

function timer_health_tick(_player, _game_duration_max_secs)
    -- Decrease player health over time
    tick_value = _player.max_health / _game_duration_max_secs
    if _player.health > 0 then
        _player.health -= tick_value
    end
end

function update_check_coin_collection(_player)
    for coin in all(coins) do
        if abs(_player.x - coin.x) < 8 and abs(_player.y - coin.y) < 8 then
            _player.coins += _player.coin_value
            del(coins, coin)
        end
    end
end