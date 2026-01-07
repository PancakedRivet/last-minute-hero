game_states = {
    new_game = 0,
    playing = 1,
    game_over = 2
}

game_sprites = {
    health = 2,
    enemy = 17
}

function new_game()
    player = new_player()
    game_state = game_states.playing
end

function draw_status_bar(_current_value, _max_value, _x, _y, _width, _height)
 local bar_ratio = _current_value / _max_value
 local filled_width = flr(_width * bar_ratio)
 local border_width = 1

 local bar_color = 11 -- Green by default
 if bar_ratio < 0.5 then
    bar_color = 10 -- Yellow
 end
 if bar_ratio < 0.2 then
    bar_color = 8 -- Red
 end

 rectfill(_x, _y, _x + _width + (2 * border_width), _y + _height + (2 * border_width), 7) -- Background Edge
 rectfill(_x + border_width, _y + border_width, _x + _width + border_width, _y + _height + border_width, 0) -- Background
 rectfill(_x + border_width, _y + border_width, _x + filled_width + border_width, _y + _height + border_width, bar_color) -- Filled part
end

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
    }
    return enemy
end