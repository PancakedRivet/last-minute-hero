ui_pos = {
    background = { x0 = 0, y0 = 0, x1 = 128, y1 = 9 },
    hp_icon = { x = 1, y = 1 },
    hp_bar = { x0 = 9, y0 = 2, x1 = 85, y1 = 4 },
    coin_icon = { x = 90, y = 1 },
    coin_text = { x = 97, y = 3 },
    score_icon = { x = 108, y = 1 },
    score_text = { x = 116, y = 3 }
}

hp_bar_border_width = 1

-- The main UI with health, coins and score
function draw_ui(_player)
    -- UI Background
    rectfill(ui_pos.background.x0, ui_pos.background.y0, ui_pos.background.x1, ui_pos.background.y1, 6)
    -- Health Bar UI
    draw_status_bar(_player.health, _player.max_health, ui_pos.hp_bar.x0, ui_pos.hp_bar.y0, ui_pos.hp_bar.x1 + 1, ui_pos.hp_bar.y1 + 1)
    spr(game_sprites.health, ui_pos.hp_icon.x, ui_pos.hp_icon.y)
    -- Coin UI
    spr(game_sprites.coin, ui_pos.coin_icon.x, ui_pos.coin_icon.y)
    print(_player.coins, ui_pos.coin_text.x, ui_pos.coin_text.y, 7)
    -- Score UI
    spr(game_sprites.score, ui_pos.score_icon.x, ui_pos.score_icon.y)
    print(_player.score, ui_pos.score_text.x, ui_pos.score_text.y, 7)
end

function draw_status_bar(_current_value, _max_value, _x0, _y0, _x1, _y1)
    local _width = _x1 - _x0
    local _height = _y1 - _y0
    local bar_ratio = _current_value / _max_value
    local filled_width = flr(_width * bar_ratio)

    -- Green by default
    local bar_color = 11
    if bar_ratio < 0.5 then
        bar_color = 10 -- Yellow
    end
    if bar_ratio < 0.2 then
        bar_color = 8 -- Red
    end

    -- Background Edge
    rectfill(_x0, _y0, _x0 + _width + (2 * hp_bar_border_width), _y0 + _height + (2 * hp_bar_border_width), 7)
    -- Background
    rectfill(_x0 + hp_bar_border_width, _y0 + hp_bar_border_width, _x0 + _width + hp_bar_border_width, _y0 + _height + hp_bar_border_width, 0)
    -- Filled part
    rectfill(_x0 + hp_bar_border_width, _y0 + hp_bar_border_width, _x0 + filled_width + hp_bar_border_width, _y0 + _height + hp_bar_border_width, bar_color)
end

-- If the player is hovering over the health item in the shop,
-- show the amount of health that would be restored on the health bar
function draw_shop_health_preview(_player, _restore_amount)
    local width = ui_pos.hp_bar.x1 - ui_pos.hp_bar.x0
    local current_bar_ratio = _player.health / _player.max_health
    local restored_bar_ratio = _restore_amount / _player.max_health
    local current_filled_width = flr(width * current_bar_ratio)
    local restored_filled_width = flr(width * restored_bar_ratio)
    -- We need an offset to avoid drawing over the end of the current health bar
    local restored_hp_width_offset = 2
    -- If the player's health is full, let the restored health overwrite the end of the health bar
    if _player.health >= _player.max_health then
        restored_hp_width_offset = 0
    end
    local restored_hp_positions = {
        x0 = ui_pos.hp_bar.x0 + hp_bar_border_width + current_filled_width + restored_hp_width_offset,
        y0 = ui_pos.hp_bar.y0 + hp_bar_border_width,
        x1 = ui_pos.hp_bar.x0 + hp_bar_border_width + current_filled_width + restored_filled_width + restored_hp_width_offset,
        y1 = ui_pos.hp_bar.y0 + hp_bar_border_width + (ui_pos.hp_bar.y1 - ui_pos.hp_bar.y0)
    }
    restored_hp_positions.x1 = min(ui_pos.hp_bar.x0 + hp_bar_border_width + width, restored_hp_positions.x1)

    rectfill(
        restored_hp_positions.x0,
        restored_hp_positions.y0,
        restored_hp_positions.x1,
        restored_hp_positions.y1,
        14
    )
end