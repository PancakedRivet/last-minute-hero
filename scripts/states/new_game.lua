function update_new_game()
    if btnp(❎) then
        new_game()
    end
end

function draw_new_game(_camera)
    print("Press ❎ to Start", 40 + _camera.x, 60 + _camera.y, 7)
end