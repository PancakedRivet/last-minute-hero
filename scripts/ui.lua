-- The main UI with health, coins and score
function draw_ui(_player, _game_sprites)
    -- UI Background
    rectfill(0, 0, 128, 9, 6)
    -- Health Bar UI
    draw_status_bar(_player.health, _player.max_health, 9, 2, 77, 3)
    spr(_game_sprites.health, 1, 1)
    -- Coin UI
    spr(_game_sprites.coin, 90, 1)
    print(_player.coins, 97, 3, 7)
    -- Score UI
    spr(_game_sprites.score, 108, 1)
    print(_player.score, 116, 3, 7)
end

function draw_status_bar(_current_value, _max_value, _x, _y, _width, _height)
    local bar_ratio = _current_value / _max_value
    local filled_width = flr(_width * bar_ratio)
    local border_width = 1

    -- Green by default
    local bar_color = 11
    if bar_ratio < 0.5 then
        bar_color = 10 -- Yellow
    end
    if bar_ratio < 0.2 then
        bar_color = 8 -- Red
    end

    -- Background Edge
    rectfill(_x, _y, _x + _width + (2 * border_width), _y + _height + (2 * border_width), 7)
    -- Background
    rectfill(_x + border_width, _y + border_width, _x + _width + border_width, _y + _height + border_width, 0)
    -- Filled part
    rectfill(_x + border_width, _y + border_width, _x + filled_width + border_width, _y + _height + border_width, bar_color)
end