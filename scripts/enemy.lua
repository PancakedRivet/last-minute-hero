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
        -- update enemy animations
        update_animation_walk(enemy, #enemy_animation_sprites_walk, enemy_animation_frames_per_sprite)
    end
end

function new_enemy()
    local enemy_x, enemy_y = spawn_enemy()
    local enemy = {
        x = enemy_x,
        y = enemy_y,
        health = 20,
        max_health = 20,
        speed = 1,
        attack = 1,
        attack_range_x = 6,
        attack_range_y = 0,
        attacked = false,
        animation_idx = 1,
        animation_tick = 0
    }
    return enemy
end

function spawn_enemy()
    local enemy_x = 0
    local enemy_y = 0
    local m1 = 0
    local f1 = 1

    while f1 do
        enemy_x = ceil(rnd() * map_size.width)
        enemy_y = ceil(rnd() * map_size.height)
        m1 = mget(enemy_x / 8, enemy_y / 8)
        f1 = fget(m1, game_flags.collision)
    end

    return enemy_x, enemy_y
end


-- Draw enemies
function draw_enemies(_enemies)
    for enemy in all(_enemies) do
        spr(enemy_animation_sprites_walk[enemy.animation_idx], enemy.x, enemy.y)
    end
    -- draw the health bars after drawing the sprites so that they appear on top
    for enemy in all(_enemies) do
        draw_status_bar(enemy.health, enemy.max_health, enemy.x - 3, enemy.y - 5, enemy.x + 8, enemy.y - 4)
    end
end