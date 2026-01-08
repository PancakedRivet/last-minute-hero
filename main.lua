-- Core initialization code here
function _init()
    game_state = game_states.new_game
    game_duration_max_secs = 60
    game_tick = 0
    game_fps = 30
    max_enemies = 5
    enemies = {}
    coins = {}
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
end