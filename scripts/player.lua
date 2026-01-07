function new_player()
    local player = {
        sp=1,
        x=64,
        y=64,
        sp_flipx=false,
        sp_flipy=false,
        speed=2,
        health=60,
        max_health=60,
        attack=10,
        attack_tick=0,
        defense=5
    }
    return player
end

function update_position(_player)
    local max_pos_x = 122
    local max_pos_y = 120
    local min_pos_x = -2
    local min_pos_y = 10

 if btn(⬅️) then
    if _player.x - _player.speed > min_pos_x then
     _player.x -= _player.speed
    end
  _player.sp_flipx = true
 end
 
 if btn(➡️) then
    if _player.x + _player.speed < max_pos_x then
        _player.x += _player.speed
    end
  _player.sp_flipx = false
 end
 
 if btn(⬆️) then
    if _player.y - _player.speed > min_pos_y then
        _player.y -= _player.speed
    end
 end
 
 if btn(⬇️) then
    if _player.y + _player.speed < max_pos_y then
        _player.y += _player.speed
    end
 end
end

function update_attack(_player)
    if btnp(❎) then
        _player.attack_tick = 15 -- Attack duration in ticks
    end
    if _player.attack_tick > 0 then
        _player.attack_tick -= 1
        -- Check for enemy collisions
        for enemy in all(enemies) do
            if abs(_player.x - enemy.x) < 8 and abs(_player.y - enemy.y) < 8 then
                enemy.health -= _player.attack
                if enemy.health <= 0 then
                    del(enemies, enemy)
                end
            end
        end
    end
end

function draw_player(_player)
 spr(_player.sp, _player.x, _player.y, 1, 1, _player.sp_flipx, _player.sp_flipy)
end

function draw_status(_player)
 print("Health: ".._player.health.."/".._player.max_health, 1, 12, 8)
 print("Attack: ".._player.attack, 1, 20, 8)
 print("Defense: ".._player.defense, 1, 28, 8)
end

function timer_health_tick(_player, _game_duration_max_secs)
    -- Decrease player health over time
    tick_value = _player.max_health / _game_duration_max_secs
    if _player.health > 0 then
        _player.health -= tick_value
    end
end