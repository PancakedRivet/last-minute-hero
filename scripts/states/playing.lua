function update_playing()
    -- Update logic here
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
    map()
    draw_player(player)
    draw_ui(player)
    draw_enemies(enemies)
    for coin in all(coins) do
        spr(coin.sp, coin.x, coin.y)
    end
end