local function get_shop_exit_index()
    return #shop_items + 1
end

local function can_purchase_item(item)
    return player.coins >= item.cost
end

function update_shop()
    -- Shop update logic here
    if btnp(❎) then
        game_state = game_states.playing
        return
    end

    if btnp(⬆️) then
        shop_selected_index -= 1
        if shop_selected_index < 1 then
            shop_selected_index = get_shop_exit_index()
        end
        return
    end

    if btnp(⬇️) then
        shop_selected_index += 1
        if shop_selected_index > get_shop_exit_index() then
            shop_selected_index = 1
        end
        return
    end

    -- Player selects a shop item
    if btnp(🅾️) and shop_selected_index <= #shop_items then
        local selected_item = shop_items[shop_selected_index]
        if can_purchase_item(selected_item) then
            player.coins -= selected_item.cost
            selected_item.purchase_func()
        end
        return
    end

    -- Player selects the exit option
    if btnp(🅾️) and shop_selected_index == get_shop_exit_index() then
        game_state = game_states.playing
        return
    end
end

function draw_shop(_camera)
    local index = 1
    local _display_x_start = 6 + _camera.x
    local _display_y_start = 20 + _camera.y
    local _sprite_y_offset = -1
    local _sprite_x_offset = 6
    local _shop_cost_x_offset = 28
    local _cursor_x = 1
    local line_height = 10
    local exit_index = get_shop_exit_index()
    
    draw_ui(player, _camera)
    print("welcome to the shop!", _display_x_start, _display_y_start, colours.white)
    -- Add some space before listing items
    _display_y_start += line_height * 2
    for item in all(shop_items) do
        local _current_value, _proposed_value = item.display_func()
        local coin_animation_frame = flr(global_game_tick / (5 + index)) % #game_sprites.coin_animation + 1
        spr(game_sprites.coin_animation[coin_animation_frame], _display_x_start, _display_y_start + (line_height * index) + _sprite_y_offset)
        -- The cost of the item and it's name with space for the sprite in between
        spr(item.sprite, _display_x_start + _shop_cost_x_offset, _display_y_start + (line_height * index) + _sprite_y_offset)
        if index == shop_selected_index then
            print(">", _cursor_x, _display_y_start + (line_height * index), colours.red)
            print("x" .. item.cost .. " -   " .. item.name .. " (" .. _current_value .. ">" .. _proposed_value .. ")", _display_x_start + _sprite_x_offset, _display_y_start + (line_height * index), colours.light_grey)
        else
            print("x" .. item.cost .. " -   " .. item.name .. " (" .. _current_value .. ">" .. _proposed_value .. ")", _display_x_start + _sprite_x_offset, _display_y_start + (line_height * index), colours.dark_grey)
        end
        index += 1
    end
    -- Exit option with an empty line to separate it from the items
    if exit_index == shop_selected_index then
        print(">", _cursor_x, _display_y_start + (line_height * exit_index + line_height), colours.red)
        print("exit shop", _display_x_start, _display_y_start + (line_height * exit_index + line_height), colours.light_grey)
    else
        print("exit shop", _display_x_start, _display_y_start + (line_height * exit_index + line_height), colours.dark_grey)
    end

    if shop_selected_index <= #shop_items and shop_items[shop_selected_index].name == shop_item_names.health_item_name then
        draw_shop_health_preview(player, item_health_restore, _camera)
    end
end