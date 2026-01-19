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
        health_item_name = "Health",
        score_item_name = "Score per enemy",
        money_item_name = "Coins per enemy"
    }
    shop_items = {
        {name=shop_item_names.health_item_name, cost=10, sprite=game_sprites.health, health_restore=5},
        {name=shop_item_names.score_item_name, cost=20, sprite=game_sprites.score, score_increase=100},
        {name=shop_item_names.money_item_name, cost=50, sprite=game_sprites.coin, coins_increase=5}
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