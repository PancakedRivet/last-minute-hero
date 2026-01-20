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
    shop_items = {
        {name=shop_item_names.health_item_name, cost=10, sprite=game_sprites.health, func=function() return player.health, min(player.health + 5, player.max_health) end},
        {name=shop_item_names.score_item_name, cost=20, sprite=game_sprites.score, func=function() return player.score_value, player.score_value + 1 end},
        {name=shop_item_names.money_item_name, cost=50, sprite=game_sprites.coin, func=function() return player.coin_value, player.coin_value + 1 end}
    }
    shop_selected_index = 1
end

-- Core update logic here
function _update()
    if game_state == game_states.new_game then 
        update_new_game()
    end
    if game_state == game_states.game_over then
        update_game_over()
    end
    if game_state == game_states.playing then
        update_playing()
    end
    if game_state == game_states.shop then
        update_shop()
    end
end

-- Core draw logic here
function _draw()
    cls()
    if game_state == game_states.new_game then
        draw_new_game()
    end
    if game_state == game_states.game_over then
        draw_game_over()
    end
    if game_state == game_states.playing then
        draw_playing()
    end
    if game_state == game_states.shop then
        draw_shop()
    end
end