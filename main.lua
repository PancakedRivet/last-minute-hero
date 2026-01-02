function _init()
 -- Initialization code here
 player = new_player()
 game_state = game_states.menu
 game_duration_max_secs = 60
 game_tick = 0
 game_fps = 30
end

function _update()
 -- Update logic here
 if game_state == game_states.menu then
    if btnp(❎) then
        game_state = game_states.playing
    end
 end
 if game_state == game_states.playing then
    game_tick += 1
    if game_tick % game_fps == 0 then
        timer_health_tick(player, game_duration_max_secs)
    end
    if player.health <= 0 then
       game_state = game_states.game_over
    end
    update_position(player)
 end
end

function _draw()
 cls()
 if game_state == game_states.menu then
    print("Press ❎ to Start", 40, 60, 7)
    return
 end
 if game_state == game_states.game_over then
    print("Game Over!", 50, 60, 8)
    return
 end
 if game_state == game_states.playing then
    draw_player(player)
    draw_status(player)
    draw_status_bar(player.health, player.max_health, 9, 3, 118, 4) 
    -- Health sprite in top left corner
    spr(game_sprites.health, 1, 1)
 end
end