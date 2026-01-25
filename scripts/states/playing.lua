function update_playing()
    -- Update logic here
    if btnp(🅾️) then
        game_state = game_states.shop
        shop_selected_index = 1
        return
    end
    game_tick += 1
    if game_tick % game_fps == 0 then
        player.score += 1
        timer_health_tick(player, game_duration_max_secs)
    end
    if player.health <= 0 then
        game_state = game_states.game_over
    end
    update_position(player)
    update_check_coin_collection(player)
    update_enemies()
    update_attack(player)
end

function draw_playing()
    cls()
    camera(8,0)
    map()
    
    -- full sprite row
    draw_row(48,mapx,mapy) --hills
    --draw reduced row sprites
    draw_rr(80,mapx,mapy) --water

    -- Reset camera
    camera(0,0)

    draw_player(player)
    draw_ui(player)
    draw_enemies(enemies)
    draw_coins()
end