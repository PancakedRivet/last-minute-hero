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
        attack_tick_max=15,
        attack_tick_start=10,
        attack_tick_end=5,
        defense=5,
        score=0,
        coins=0
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
                            add(coins, {x=enemy.x, y=enemy.y, sp=game_sprites.coin}) -- Spawn a coin where the enemy died
                            _player.score += 1
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
 spr(_player.sp, _player.x, _player.y, 1, 1, _player.sp_flipx, _player.sp_flipy)
end

function timer_health_tick(_player, _game_duration_max_secs)
    -- Decrease player health over time
    tick_value = _player.max_health / _game_duration_max_secs
    if _player.health > 0 then
        _player.health -= tick_value
    end
end