function update_enemies()
    -- Placeholder for enemy update logic
    if count(enemies) < max_enemies then
        -- Spawn a new enemy
        add(enemies, new_enemy())
    end
    -- Move enemies towards player
    for enemy in all(enemies) do
        if enemy.x < player.x then
            enemy.x += enemy.speed
        elseif enemy.x > player.x then
            enemy.x -= enemy.speed
        end
        if enemy.y < player.y then
            enemy.y += enemy.speed
        elseif enemy.y > player.y then
            enemy.y -= enemy.speed
        end
    end
end

function new_enemy()
    local enemy_x = ceil(rnd() * 120)
    local enemy_y = ceil(rnd() * 110) + 10
    local enemy = {
        x=enemy_x,
        y=enemy_y,
        health=20,
        max_health=20,
        speed=1,
        attack=1,
        attacked=false
    }
    return enemy
end