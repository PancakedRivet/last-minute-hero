-- Core initialization code here
function _init()
    game_state = game_states.new_game
    game_duration_max_secs = 60
    game_tick = 0
    game_fps = 30
    max_enemies = 5
    enemies = {}
    coins = {}
    shop_item_names = {
        health_item_name = "health",
        score_item_name = "score/enemy",
        money_item_name = "coins/enemy"
    }
    item_health_restore = 5
    item_score_increase = 1
    item_coin_increase = 1
    shop_items = {
        {name=shop_item_names.health_item_name, cost=10, sprite=game_sprites.health,
            display_func=function() return player.health, min(player.health + item_health_restore, player.max_health) end,
            purchase_func=function() player.health = min(player.health + item_health_restore, player.max_health) end
        },
        {name=shop_item_names.score_item_name, cost=20, sprite=game_sprites.score,
            display_func=function() return player.score_value, player.score_value + item_score_increase end,
            purchase_func=function() player.score_value = player.score_value + item_score_increase end
        },
        {name=shop_item_names.money_item_name, cost=50, sprite=game_sprites.coin,
            display_func=function() return player.coin_value, player.coin_value + item_coin_increase end,
            purchase_func=function() player.coin_value = player.coin_value + item_coin_increase end
        }
    }
    shop_selected_index = 1

    camera_position = {
        x = 8, -- start with an offset to account for the water tiles being against the left edge
        y = 0
    }

    mapx = 0 
    mapy = 0
    --lookup table for the reduced map tileset
    rsl=spt("0,0,0|0,0,0|0,1,0|1,0,0|0,0,1|3,1,0|4,0,0|2,0,0|0,1,1|4,1,0|3,0,0|2,1,0|1,0,1|2,0,1|2,1,1|5,0,0")
end

-- Core update logic here
function _update()
    if game_state == game_states.new_game then 
        update_new_game()
        return
    end
    if game_state == game_states.game_over then
        update_game_over()
        return
    end
    if game_state == game_states.playing then
        update_playing()
        return
    end
    if game_state == game_states.shop then
        update_shop()
        return
    end
end

-- Core draw logic here
function _draw()
    cls()
    camera(camera_position.x,camera_position.y)
    if game_state == game_states.new_game then
        draw_new_game(camera_position)
        return
    end
    if game_state == game_states.game_over then
        draw_game_over(camera_position)
        return
    end
    if game_state == game_states.playing then
        draw_playing(camera_position)
        return
    end
    if game_state == game_states.shop then
        draw_shop(camera_position)
        return
    end
end