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
    local exit_index = get_shop_exit_index()
    for item in all(shop_items) do
        print(item.name .. " - " .. item.cost .. " coins", 20, 70 + (10 * index), 6)
        if index == shop_selected_index then
            print(">", 10, 70 + (10 * index), 8)
        end
        index += 1
    end
    -- Exit option with an empty line to separate it from the items
    print("Exit Shop", 20, 70 + (10 * exit_index + 10), 6)
    if exit_index == shop_selected_index then
        print(">", 10, 70 + (10 * exit_index + 10), 8)
    end

    if shop_selected_index <= #shop_items and shop_items[shop_selected_index].name == shop_item_names.health_item_name then
        draw_shop_health_preview(player, shop_items[shop_selected_index].health_restore)
    end
end