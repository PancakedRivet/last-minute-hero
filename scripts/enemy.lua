enemy_animation_sprites_walk = {32,33,34,35}
enemy_animation_frames_per_sprite = 8

function update_enemies()
    if count(enemies) < max_enemies then
        -- spawn a new enemy
        add(enemies, new_enemy())
    end
    -- move enemies towards player
    for enemy in all(enemies) do
        -- check horizontal movement
        local current_x, current_y = enemy.x, enemy.y
        local dx = abs(player.x - enemy.x)
        local dy = abs(player.y - enemy.y)
        local x_dir = sgn(player.x - enemy.x)
        local y_dir = sgn(player.y - enemy.y)
        if dx > enemy.attack_range_x then
            enemy.x += enemy.speed * x_dir
        end
        if dy > enemy.attack_range_y then
            enemy.y += enemy.speed * y_dir
        end

        -- check collisions
        if current_x != enemy.x or current_y != enemy.y then
            collisions = map_collision(enemy, game_flags.collision)
            -- if we collide vertically (above or below), reset y position
            if (collisions.top_left and collisions.top_right) or (collisions.bottom_left and collisions.bottom_right) then
                enemy.y=current_y
            end
            -- if we collide horizontally (left or right), reset x position
            if (collisions.top_left and collisions.bottom_left) or (collisions.top_right and collisions.bottom_right) then
                enemy.x=current_x
            end
        end

        -- update enemy animations
        new_animation = update_animation(enemy.walk_animation_tick, enemy.walk_animation_idx, #enemy_animation_sprites_walk, enemy_animation_frames_per_sprite)
        enemy.walk_animation_tick = new_animation.animation_tick
        enemy.walk_animation_idx = new_animation.animation_idx
    end
end

function new_enemy()
    local enemy_x, enemy_y = spawn_enemy()
    local enemy = {
        x = enemy_x,
        y = enemy_y,
        w = 7, 
        h = 7,
        health = 20,
        max_health = 20,
        speed = 1,
        attack = 1,
        attack_range_x = 6,
        attack_range_y = 0,
        attack_tick_current = 1,
        attack_tick_active_start = 2,
        attack_tick_active_end = 4,
        attack_tick_stop = 6,
        attack_tick_cooldown = 30, -- 1s at 30fps after the attack ends
        attack_tick_cooldown_current = 0,
        attack_animation_idx = 1,
        attack_animation_sprites = {52, 53, 54, 55},
        attacked = false,
        walk_animation_idx = 1,
        walk_animation_tick = 0
    }
    return enemy
end

function spawn_enemy()
    local enemy_x = 0
    local enemy_y = 0
    local m1 = 0
    local f1 = 1

    -- loop until we find a non-collision tile to spawn the enemy on
    while f1 do
        enemy_x = ceil(rnd() * map_size.width)
        enemy_y = ceil(rnd() * map_size.height)
        local obj = {x = enemy_x, y = enemy_y, w = 7, h = 7}
        f1 = any_collision(obj, game_flags.collision)
    end

    return enemy_x, enemy_y
end

-- update attack logic for the enemies against the player
function update_attack_enemy(_player)
    if _player.attack_tick_cooldown_current > 0 then
        _player.attack_tick_cooldown_current = max(0, _player.attack_tick_cooldown_current - 1)
    end
    -- only attack if not already attacking
    if _player.attack_tick_cooldown_current == 0 then
        _player.attack_tick_current += 1
        _player.attack_tick_cooldown_current = _player.attack_tick_cooldown

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

-- Draw enemies
function draw_enemies(_enemies)
    for enemy in all(_enemies) do
        spr(enemy_animation_sprites_walk[enemy.walk_animation_idx], enemy.x, enemy.y)
    end
    -- draw the health bars after drawing the sprites so that they appear on top
    for enemy in all(_enemies) do
        draw_status_bar(enemy.health, enemy.max_health, enemy.x - 3, enemy.y - 5, enemy.x + 8, enemy.y - 4)
    end
end