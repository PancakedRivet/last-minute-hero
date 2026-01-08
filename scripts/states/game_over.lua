function update_game_over()
    if btnp(❎) then
        new_game()
    end
end

function draw_game_over()
    print("Game Over!", 50, 60, 8)
    print("Press ❎ to Start a new game", 40, 70, 7)
end