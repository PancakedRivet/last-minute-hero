game_states = {
    menu = 0,
    playing = 1,
    game_over = 2
}

game_sprites = {
    health = 2,
    timer = 3
}

function new_game()
 game_timer_frames_max = 1800 -- 60 seconds at 30 FPS
 game_timer_frames = game_timer_frames_max
 player = new_player()
end

function draw_status_bar(current_value, max_value, x, y, width, height, sprite)
 local x = x or 0
 local y = y or 0
 local bar_width = width or 40
 local bar_height = height or 8
 local bar_ratio = current_value / max_value
 local filled_width = flr(bar_width * bar_ratio)

 local bar_color = 11 -- Green by default
 if bar_ratio < 0.5 then
    bar_color = 10 -- Yellow
 end
 if bar_ratio < 0.2 then
    bar_color = 8 -- Red
 end

 -- Sprite is always to the left of the bar
 if sprite then
    spr(sprite, x, y)
    x += 8
 end

 rectfill(x, y, x + bar_width, y + bar_height, 0) -- Background
 rectfill(x, y, x + filled_width, y + bar_height, bar_color) -- Filled part
end

