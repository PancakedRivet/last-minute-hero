local function get_shop_exit_index()
    return #shop_items + 1
end

function update_shop()
    -- Shop update logic here
    if btnp(❎) then
        game_state = game_states.playing
    end
    if btnp(⬆️) then
        shop_selected_index -= 1
        if shop_selected_index < 1 then
            shop_selected_index = get_shop_exit_index()
        end
    end

    if btnp(⬇️) then
        shop_selected_index += 1
        if shop_selected_index > get_shop_exit_index() then
            shop_selected_index = 1
        end
    end

    -- Player selects the exit option
    if btnp(🅾️) and shop_selected_index == get_shop_exit_index() then
        game_state = game_states.playing
    end
end

function draw_shop()
    draw_ui(player)
    print("Welcome to the Shop!", 30, 60, 7)
    local index = 1
    local _display_x_start = 20
    local _display_y_start = 70
    local _sprite_y_offset = -2
    local _cursor_x = 10
    local line_height = 10
    local exit_index = get_shop_exit_index()
    for item in all(shop_items) do
        print(item.name .. " - " .. item.cost .. " coins", _display_x_start, _display_y_start + (line_height * index), 6)
        --TODO Use a coin sprite instead of text
        --print("=" .. item.cost .. " coins", _display_x_start, _display_y_start + (line_height * index), 6)
        --spr(item.sprite, _display_x_start, _display_y_start + (line_height * index) + _sprite_y_offset)
        if index == shop_selected_index then
            print(">", _cursor_x, _display_y_start + (line_height * index), 8)
        end
        index += 1
    end
    -- Exit option with an empty line to separate it from the items
    print("Exit Shop", _display_x_start, _display_y_start + (line_height * exit_index + line_height), 6)
    if exit_index == shop_selected_index then
        print(">", _cursor_x, _display_y_start + (line_height * exit_index + line_height), 8)
    end

    if shop_selected_index <= #shop_items and shop_items[shop_selected_index].name == shop_item_names.health_item_name then
        draw_shop_health_preview(player, shop_items[shop_selected_index].health_restore)
    end
end