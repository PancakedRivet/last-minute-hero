local function get_shop_exit_index()
    return #shop_items + 1
end

-- TODO shouldn't be indexing using hardcoded 1
-- Function to retrieve the current and proposed values for the health item
function get_shop_item_values_health()
    local current_health = player.health
    local proposed_health = min(player.health + shop_items[1].health_restore, player.max_health)
    return current_health, proposed_health
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

    -- TODO implement shop item effects
    -- Player selects a shop item
    if btnp(🅾️) and shop_selected_index <= #shop_items then
        local selected_item = shop_items[shop_selected_index]
        if player.coins >= selected_item.cost then
            player.coins -= selected_item.cost
            if selected_item.name == shop_item_names.health_item_name then
                player.health = min(player.health + selected_item.health_restore, player.max_health)
            elseif selected_item.name == shop_item_names.score_item_name then
                player.score += selected_item.score_increase
            elseif selected_item.name == shop_item_names.money_item_name then
                player.coins += selected_item.coins_increase
            end
        end
    end
end

function draw_shop()
    local index = 1
    local _display_x_start = 6
    local _display_y_start = 20
    local _sprite_y_offset = -1
    local _sprite_x_offset = 6
    local _shop_cost_x_offset = 28
    local _cursor_x = 1
    local line_height = 10
    local exit_index = get_shop_exit_index()
    
    draw_ui(player)
    print("Welcome to the Shop!", _display_x_start, _display_y_start, colours.white)
    -- Add some space before listing items
    _display_y_start += line_height * 2
    for item in all(shop_items) do
        local _current_value, _proposed_value = item.func()
        spr(game_sprites.coin, _display_x_start, _display_y_start + (line_height * index) + _sprite_y_offset)
        -- TODO Break this into seperate print statements
        -- The cost of the item and it's name with space for the sprite in between
        print("x" .. item.cost .. " -   " .. item.name .. " (" .. _current_value .. " -> " .. _proposed_value .. ")", _display_x_start + _sprite_x_offset, _display_y_start + (line_height * index), colours.light_grey)
        spr(item.sprite, _display_x_start + _shop_cost_x_offset, _display_y_start + (line_height * index) + _sprite_y_offset)
        if index == shop_selected_index then
            print(">", _cursor_x, _display_y_start + (line_height * index), colours.red)
        end
        index += 1
    end
    -- Exit option with an empty line to separate it from the items
    print("Exit Shop", _display_x_start, _display_y_start + (line_height * exit_index + line_height), colours.light_grey)
    if exit_index == shop_selected_index then
        print(">", _cursor_x, _display_y_start + (line_height * exit_index + line_height), colours.red)
    end

    if shop_selected_index <= #shop_items and shop_items[shop_selected_index].name == shop_item_names.health_item_name then
        draw_shop_health_preview(player, shop_items[shop_selected_index].health_restore)
    end
end