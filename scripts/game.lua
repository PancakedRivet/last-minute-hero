game_states = {
    new_game = 0,
    playing = 1,
    game_over = 2
}

game_sprites = {
    health = 2,
}

function new_game()
    player = new_player()
    game_state = game_states.playing
end

function draw_status_bar(current_value, max_value, x, y, width, height)
 local x = x or 0
 local y = y or 0
 local bar_width = width or 40
 local bar_height = height or 8
 local bar_ratio = current_value / max_value
 local filled_width = flr(bar_width * bar_ratio)
 local border_width = 1

 local bar_color = 11 -- Green by default
 if bar_ratio < 0.5 then
    bar_color = 10 -- Yellow
 end
 if bar_ratio < 0.2 then
    bar_color = 8 -- Red
 end

 rectfill(x, y, x + bar_width, y + bar_height, 7) -- Background Edge
 rectfill(x + border_width, y + border_width, x + bar_width - border_width, y + bar_height - border_width, 0) -- Background
 rectfill(x + border_width, y + border_width, x + filled_width, y + bar_height - border_width, bar_color) -- Filled part
end

