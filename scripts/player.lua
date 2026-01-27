function new_player()
    local player = {
        sp = 48,
        x = 64,
        y = 64,
        w = 7,
        h = 7,
        sp_flipx = false,
        sp_flipy = false,
        walk_animation_sprites = {48, 49, 50, 51},
        walk_animation_frames_per_sprite = 6,
        walk_animation_idx = 1,
        walk_animation_tick = 0,
        speed = 2,
        health = 60,
        max_health = 60,
        attack = 10,
        attacking = false,
        attack_tick_current = 1,
        attack_tick_active_start = 2,
        attack_tick_active_end = 4,
        attack_tick_stop = 6,
        attack_animation_idx = 1,
        attack_animation_sprites = {52, 53, 54, 55},
        defense = 5,
        score = 0,
        score_value = 1,
        coins = 0,
        coin_value = 1,
    }
    return player
end

-- update player position based on input and handle collisions
function update_position(_player)

    local current_pos_x = _player.x
    local current_pos_y = _player.y

    local _update_animation_walk = false

    -- move player based on input
    if btn(⬅️) then
        _player.x -= _player.speed
        _player.sp_flipx = true
    end

    if btn(➡️) then
        _player.x += _player.speed
        _player.sp_flipx = false
    end

    if btn(⬆️) then
        _player.y -= _player.speed
    end

    if btn(⬇️) then
        _player.y += _player.speed
    end

    -- check collisions
    if current_pos_x != _player.x or current_pos_y != _player.y then
        _update_animation_walk = true
        collisions = map_collision(_player, game_flags.collision)
        -- if we collide vertically (above or below), reset y position
        if (collisions.top_left and collisions.top_right) or (collisions.bottom_left and collisions.bottom_right) then
            _player.y=current_pos_y
        end
        -- if we collide horizontally (left or right), reset x position
        if (collisions.top_left and collisions.bottom_left) or (collisions.top_right and collisions.bottom_right) then
            _player.x=current_pos_x
        end
    end
    
    if _update_animation_walk then
        new_animation = update_animation(_player.walk_animation_tick, _player.walk_animation_idx, #_player.walk_animation_sprites, _player.walk_animation_frames_per_sprite)
        _player.walk_animation_tick = new_animation.animation_tick
        _player.walk_animation_idx = new_animation.animation_idx
    else
        _player.walk_animation_idx = 1
    end
end

function update_attack(_player)
    -- only attack if not already attacking
    if btnp(❎) and not _player.attacking then
        _player.attacking = true
    end
    if _player.attacking then
        _player.attack_tick_current += 1

        -- update the attack animation 
        _player.attack_animation_idx = ceil((_player.attack_tick_current / _player.attack_tick_stop) * #_player.attack_animation_sprites)
        
        -- check for hits during the active frames
        if _player.attack_tick_active_start < _player.attack_tick_current and _player.attack_tick_current < _player.attack_tick_active_end then
            -- check for enemy collisions
            local attack_range = 8
            for enemy in all(enemies) do
                if not enemy.attacked then
                    -- check the enemy is within attack range and in front of the player
                    if abs(_player.x - enemy.x) < attack_range and abs(_player.y - enemy.y) < attack_range and sgn(_player.x - enemy.x) == (_player.sp_flipx and 1 or -1) then
                        enemy.health -= _player.attack
                        enemy.attacked = true
                        if enemy.health <= 0 then
                            del(enemies, enemy)
                            add(coins, { x = enemy.x, y = enemy.y, sp = game_sprites.coin }) -- spawn a coin where the enemy died
                            _player.score += _player.score_value
                        end
                    end
                end
            end
        end
    end
    -- stop the same enemy from being attacked multiple times in one attack
    if _player.attack_tick_current > _player.attack_tick_stop then
        _player.attacking = false
        _player.attack_tick_current = 0
        for enemy in all(enemies) do
            enemy.attacked = false
        end
    end
end

-- draw the player sprite 
-- and if the player are attacking, draw an attack effect
function draw_player(_player)
    spr(_player.walk_animation_sprites[_player.walk_animation_idx], _player.x, _player.y, 1, 1, _player.sp_flipx, _player.sp_flipy)
    if _player.attacking then
        spr(_player.attack_animation_sprites[_player.attack_animation_idx], _player.x + (6 * (_player.sp_flipx and -1 or 1)), _player.y, 1, 1, _player.sp_flipx, _player.sp_flipy)
    end
end

function timer_health_tick(_player, _game_duration_max_secs)
    -- decrease player health over time
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