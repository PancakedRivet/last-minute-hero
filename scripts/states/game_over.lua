function update_game_over()
    if btnp(❎) then
        new_game()
    end
end

function draw_game_over()
    print("game over!", 50, 40, colours.red)
    print("final score: "..player.score, 40, 50, colours.white)
    print("press ❎ to start", 40, 70, colours.white)
    print("a new game", 50, 80, colours.white)
end