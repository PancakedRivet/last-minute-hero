function _init()
 -- Initialization code here
 game_state = game_states.new_game
 game_duration_max_secs = 60
 game_tick = 0
 game_fps = 30
 max_enemies = 5
 enemies = {}
 coins = {}
end

function _update()
 -- Update logic here
 if game_state == game_states.new_game or game_state == game_states.game_over then
    if btnp(❎) then
        new_game()
    end
 end
 if game_state == game_states.playing then
    game_tick += 1
    if game_tick % game_fps == 0 then
        player.score += 1
        timer_health_tick(player, game_duration_max_secs)
    end
    if player.health <= 0 then
       game_state = game_states.game_over
    end
    update_position(player)
    update_enemies()
    update_attack(player)
 end
end

function _draw()
 cls()
 if game_state == game_states.new_game then
    print("Press ❎ to Start", 40, 60, 7)
    return
 end
 if game_state == game_states.game_over then
    print("Game Over!", 50, 60, 8)
    return
 end
 if game_state == game_states.playing then
    map()
    draw_player(player)
    draw_ui()
    -- Draw enemies
    for enemy in all(enemies) do
        draw_status_bar(enemy.health, enemy.max_health, enemy.x - 3, enemy.y - 5, 11, 1)
        spr(game_sprites.enemy, enemy.x, enemy.y)
    end
    for coin in all(coins) do
        spr(coin.sp, coin.x, coin.y)
    end
 end
end