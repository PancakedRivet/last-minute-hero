enemy_animation_sprites_walk = {32,33,34,35}
enemy_animation_frames_per_sprite = 8

function update_spawning_enemies()
    for enemy in all(spawning_enemies) do
        -- handle spawn animation
        if enemy.spawn_animation_tick > 0 then
            enemy.spawn_animation_tick -= 1
        else
            -- move from spawning_enemies to enemies
            del(spawning_enemies, enemy)
            add(enemies, enemy)
        end
    end
end

function update_dying_enemies()
    for enemy in all(dying_enemies) do
        -- handle spawn animation
        if enemy.death_animation_tick > 0 then
            enemy.death_animation_tick -= 1
        else
            -- delete from dying_enemies
            del(dying_enemies, enemy)
            -- spawn a coin where the enemy died
            add(coins, { x = enemy.x, y = enemy.y, sp = game_sprites.coin, current_tick = global_game_tick }) 
        end
    end
end

function update_enemies()
    -- move enemies towards player
    for enemy in all(enemies) do
        -- check horizontal movement
        local current_x, current_y = enemy.x, enemy.y
        local dx = abs(player.x - enemy.x)
        local dy = abs(player.y - enemy.y)
        local x_dir = sgn(player.x - enemy.x)
        local y_dir = sgn(player.y - enemy.y)
        local attack_range_offset = -1 -- enemies try to move into their attack range rather than at the limit
        if dx > enemy.attack_range_x + attack_range_offset then
            enemy.x += enemy.speed * x_dir
            if x_dir > 0 then
                enemy.sp_flipx = false
            else
                enemy.sp_flipx = true
            end
        end
        -- note: not adding attack offset to y because vertical alignment is less important
        if dy > enemy.attack_range_y then
            enemy.y += enemy.speed * y_dir
        end

        -- apply knockback if applicable
        if enemy.knockback_tick > 0 then
            enemy.x += enemy.knockback_x * 2 -- knockback speed
            enemy.knockback_tick -= 1
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

        -- update attack logic
        update_attack_enemy(enemy)

        -- update enemy animations
        new_animation = update_animation(enemy.walk_animation_tick, enemy.walk_animation_idx, #enemy_animation_sprites_walk, enemy_animation_frames_per_sprite)
        enemy.walk_animation_tick = new_animation.animation_tick
        enemy.walk_animation_idx = new_animation.animation_idx
    end
end

function new_enemy()
    local enemy_x, enemy_y = spawn_enemy()
    local health_multiplier = 1 + flr(player.kill_count / 25)
    local enemy = {
        x = enemy_x,
        y = enemy_y,
        w = 7, 
        h = 7,
        sp_flipx = false,
        sp_flipy = false,
        health = 10 * health_multiplier,
        max_health = 10 * health_multiplier,
        speed = 1,
        attack = 2,
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
        attacked_player = false,
        walk_animation_idx = 1,
        walk_animation_tick = 0,
        knockback_tick = 0,
        knockback_x = 0,
        spawn_animation_tick = 9,
        spawn_animation_sprites = {56, 57, 58},
        death_animation_tick = 0,
        death_animation_sprites = {59, 60, 61},
    }
    return enemy
end

function spawn_enemy()
    local enemy_x = 0
    local enemy_y = 0
    local collision = 0
    local near_player = true
    local near_player_distance = 32 -- minimum distance from player to spawn is 4 sprites
    local can_spawn = false

    -- loop until we find a non-collision tile to spawn the enemy on
    while not can_spawn do
        enemy_x = ceil(rnd() * map_size.width)
        enemy_y = ceil(rnd() * map_size.height)
        local obj = {x = enemy_x, y = enemy_y, w = 7, h = 7}
        collision = any_collision(obj, game_flags.collision)
        near_player = abs(enemy_x - player.x) < near_player_distance and abs(enemy_y - player.y) < near_player_distance
        can_spawn = not near_player and not collision
    end

    return enemy_x, enemy_y
end

-- update attack logic for the enemies against the player
function update_attack_enemy(_enemy)
    if _enemy.attack_tick_cooldown_current > 0 then
        _enemy.attack_tick_cooldown_current = max(0, _enemy.attack_tick_cooldown_current - 1)
    end
    -- only attack if not already attacking
    if _enemy.attack_tick_cooldown_current == 0 then
        _enemy.attack_tick_current += 1
        if _enemy.attack_tick_current == 1 then
            sfx(game_sfx.enemy_attack)
        end

        -- update the attack animation 
        _enemy.attack_animation_idx = ceil((_enemy.attack_tick_current / _enemy.attack_tick_stop) * #_enemy.attack_animation_sprites)
        
        -- check for hits during the active frames
        if _enemy.attack_tick_active_start < _enemy.attack_tick_current and _enemy.attack_tick_current < _enemy.attack_tick_active_end then
            -- check for player collisions
            if not _enemy.attacked_player then
                -- check the enemy is within attack range and in front of the player
                -- y attack range is extended by 4 pixels to attack in a small vertical area
                if abs(player.x - _enemy.x) < _enemy.attack_range_x 
                and abs(player.y - _enemy.y) < _enemy.attack_range_y + 4 
                and sgn(player.x - _enemy.x) == (_enemy.sp_flipx and -1 or 1)
                and player.dashing == false then
                    player.health -= _enemy.attack
                    sfx(game_sfx.player_hurt)
                    _enemy.attacked_player = true
                end
            end
        end
    end
    -- stop the same enemy from being attacked multiple times in one attack
    if _enemy.attack_tick_current > _enemy.attack_tick_stop then
        _enemy.attack_tick_current = 0
        _enemy.attack_tick_cooldown_current = _enemy.attack_tick_cooldown
        _enemy.attacked_player = false
    end
end

-- draw enemies
function draw_enemies(_enemies)
    for enemy in all(_enemies) do
        spr(enemy_animation_sprites_walk[enemy.walk_animation_idx], enemy.x, enemy.y, 1, 1, enemy.sp_flipx, enemy.sp_flipy)
        if enemy.attack_tick_current > 0 then
            spr(enemy.attack_animation_sprites[enemy.attack_animation_idx], enemy.x + (6 * (enemy.sp_flipx and -1 or 1)), enemy.y, 1, 1, enemy.sp_flipx, enemy.sp_flipy)
        end
    end
    -- draw the health bars after drawing the sprites so that they appear on top
    for enemy in all(_enemies) do
        draw_status_bar(enemy.health, enemy.max_health, enemy.x - 3, enemy.y - 5, enemy.x + 8, enemy.y - 4)
    end
end

-- draw spawning enemies
function draw_spawning_enemies(_spawning_enemies)
    for enemy in all(_spawning_enemies) do
        if enemy.spawn_animation_tick > 0 then
            spr(enemy.spawn_animation_sprites[3 - flr(enemy.spawn_animation_tick / #enemy.spawn_animation_sprites)], enemy.x, enemy.y, 1, 1, enemy.sp_flipx, enemy.sp_flipy)
        end
    end
end

-- draw dying enemies
function draw_dying_enemies(_dying_enemies)
    for enemy in all(_dying_enemies) do
        if enemy.death_animation_tick > 0 then
            spr(enemy.death_animation_sprites[3 - flr(enemy.death_animation_tick / #enemy.death_animation_sprites)], enemy.x, enemy.y, 1, 1, enemy.sp_flipx, enemy.sp_flipy)
        end
    end
end