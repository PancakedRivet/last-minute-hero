function update_game_over()
    player.game_over_cooldown = max(0, player.game_over_cooldown - 1)
    if player.game_over_cooldown == 0 and btnp(❎) then
        new_game()
    end
end

function draw_game_over(_camera)
    print("game over!", 50 + _camera.x, 40 + _camera.y, colours.red)
    print("final score: "..player.score, 40 + _camera.x, 50 + _camera.y, colours.white)
    print("press ❎ to start", 40 + _camera.x, 70 + _camera.y, colours.white)
    print("a new game", 50 + _camera.x, 80 + _camera.y, colours.white)
end