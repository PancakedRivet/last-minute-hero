ui_pos = {
    background = { x0 = 0, y0 = 0, x1 = 128, y1 = 9 },
    hp_icon = { x = 1, y = 2 },
    hp_bar = { x0 = 9, y0 = 2, x1 = 86, y1 = 5 },
    coin_icon = { x = 90, y = 2 },
    coin_text = { x = 97, y = 3 },
    score_icon = { x = 108, y = 2 },
    score_text = { x = 116, y = 3 }
}

hp_bar_border_width = 1

local function get_bar_width(_current, _max, _width)
    return flr(_width * (_current / _max))
end

local function get_bar_colour(_current, _max)
    local ratio = _current / _max
    if ratio < 0.2 then
        return colours.red
    elseif ratio < 0.5 then
        return colours.yellow
    else
        return colours.green
    end
end

local function draw_hp_text(_current_hp, _max_hp, _camera)
    print(
        _current_hp .. "/" .. _max_hp,
        ui_pos.hp_bar.x0 + ((ui_pos.hp_bar.x1 - ui_pos.hp_bar.x0) / 2) - (6 * #tostr(_max_hp) / 2) + _camera.x,
        ui_pos.hp_bar.y0 + _camera.y,
        colours.white
    )
end

-- The main UI with health, coins and score
function draw_ui(_player, _camera)
    -- UI Background
    rectfill(ui_pos.background.x0 + _camera.x, ui_pos.background.y0 + _camera.y, ui_pos.background.x1 + _camera.x, ui_pos.background.y1 + _camera.y, colours.light_grey)
    -- Health Bar UI
    draw_status_bar(_player.health, _player.max_health, ui_pos.hp_bar.x0 + _camera.x, ui_pos.hp_bar.y0 + _camera.y, ui_pos.hp_bar.x1 + _camera.x, ui_pos.hp_bar.y1 + _camera.y)
    spr(game_sprites.health, ui_pos.hp_icon.x + _camera.x, ui_pos.hp_icon.y + _camera.y)

    -- In the shop, the health text is drawn separately to allow for the health preview overlay to be drawn over the bar correctly
    if not (game_state == game_states.shop and shop_selected_index <= #shop_items and shop_items[shop_selected_index].name == shop_item_names.health_item_name) then
        draw_hp_text(_player.health, _player.max_health, _camera)
    end

    -- Coin UI
    local coin_animation_frame = flr(global_game_tick / 8) % #game_sprites.coin_animation + 1
    spr(game_sprites.coin_animation[coin_animation_frame], ui_pos.coin_icon.x + _camera.x, ui_pos.coin_icon.y + _camera.y)
    print(_player.coins, ui_pos.coin_text.x + _camera.x, ui_pos.coin_text.y + _camera.y, colours.white)
    -- Score UI
    spr(game_sprites.score, ui_pos.score_icon.x + _camera.x, ui_pos.score_icon.y + _camera.y)
    print(_player.score, ui_pos.score_text.x + _camera.x, ui_pos.score_text.y + _camera.y, colours.white)
end

function draw_status_bar(_current_value, _max_value, _x0, _y0, _x1, _y1)
    local _width = _x1 - _x0
    local _height = _y1 - _y0
    local filled_width = get_bar_width(_current_value, _max_value, _width)
    local bar_color = get_bar_colour(_current_value, _max_value)

    -- Background Edge
    rectfill(
        _x0,
        _y0,
        _x0 + _width + (2 * hp_bar_border_width),
        _y0 + _height + (2 * hp_bar_border_width),
        colours.white
    )
    -- Background
    rectfill(
        _x0 + hp_bar_border_width,
        _y0 + hp_bar_border_width,
        _x0 + hp_bar_border_width + _width,
        _y0 + hp_bar_border_width + _height,
        colours.black
    )
    -- Filled part
    rectfill(
        _x0 + hp_bar_border_width,
        _y0 + hp_bar_border_width,
        _x0 + hp_bar_border_width + filled_width,
        _y0 + hp_bar_border_width + _height,
        bar_color
    )
end

-- If the player is hovering over the health item in the shop,
-- show the amount of health that would be restored on the health bar
function draw_shop_health_preview(_player, _restore_amount, _camera)
    local width = ui_pos.hp_bar.x1 - ui_pos.hp_bar.x0

    local current_filled_width = get_bar_width(_player.health, _player.max_health, width)
    local restored_filled_width = get_bar_width(_restore_amount, _player.max_health, width)

    -- We need an offset to avoid drawing over the end of the current health bar
    local restored_hp_width_offset = 1
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
        restored_hp_positions.x0 + _camera.x,
        restored_hp_positions.y0 + _camera.y,
        restored_hp_positions.x1 + _camera.x,
        restored_hp_positions.y1 + _camera.y,
        14
    )
    draw_hp_text(
        min(_player.health + _restore_amount, _player.max_health),
        _player.max_health,
        _camera
    )
end