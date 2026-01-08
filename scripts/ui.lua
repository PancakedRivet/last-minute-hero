-- The main UI with health, coins and score
function draw_ui(_player)
    -- UI Background
    rectfill(0, 0, 128, 9, 6)
    -- Health Bar UI
    draw_status_bar(_player.health, _player.max_health, 9, 2, 77, 3)
    spr(game_sprites.health, 1, 1)
    -- Coin UI
    spr(game_sprites.coin, 90, 1)
    print(_player.coins, 97, 3, 7)
    -- Score UI
    spr(game_sprites.score, 108, 1)
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

-- If the player is hovering over the health item in the shop,
-- show the amount of health that would be restored on the health bar
-- TODO Refactor to use constant values from the main Health Bar UI
function draw_shop_health_preview(_player, _restore_amount)
    local health_bar_positions = { x = 9, y = 2, width = 77, height = 3 }
    local current_bar_ratio = _player.health / _player.max_health
    local restored_bar_ratio = _restore_amount / _player.max_health
    local current_filled_width = flr(health_bar_positions.width * current_bar_ratio)
    local restored_filled_width = flr(health_bar_positions.width * restored_bar_ratio)
    local border_width = 1
    local restored_hp_width_offset = 1
    -- Prevent overflow beyond max health
    if _player.health >= _player.max_health then
        restored_hp_width_offset = 0
    end
    local restored_hp_positions = {
        x0 = health_bar_positions.x + border_width + restored_hp_width_offset + current_filled_width,
        y0 = health_bar_positions.y + border_width,
        x1 = health_bar_positions.x + border_width + restored_hp_width_offset + current_filled_width + restored_filled_width,
        y1 = health_bar_positions.y + health_bar_positions.height + border_width
    }
    if restored_hp_positions.x1 > health_bar_positions.x + border_width + health_bar_positions.width then
        restored_hp_positions.x1 = health_bar_positions.x + border_width + health_bar_positions.width
    end

    rectfill(
        restored_hp_positions.x0,
        restored_hp_positions.y0,
        restored_hp_positions.x1,
        restored_hp_positions.y1,
        14
    )
end