function _init()
 -- Initialization code here
 new_game()
 game_state = game_states.playing
end

function _update()
 -- Update logic here
 update_position(player)
 game_timer_frames -= 1
end

function _draw()
 cls()
 draw_player(player)
 draw_status(player)
 draw_status_bar(game_timer_frames, game_timer_frames_max, 1, 1, 128, 2, game_sprites.timer)
 draw_status_bar(player.health, player.max_health, 1, 5, 40, 2, game_sprites.health)
end