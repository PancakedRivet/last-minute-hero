function update_new_game()
    if btnp(❎) then
        new_game()
    end
end

local text = {
    "okay so here's the deal:",
    "we are under attack and",
    "our previous hero died",
    "horrifically in battle...",
    "we know it's last minute",
    "but we are counting on you",
    "to be our hero! good luck!",
}

function draw_new_game(_camera)
    local line_height = 10
    local line_y = 30

    print("last minute hero", 30 + _camera.x, 10 + _camera.y, 7)

    for i=1,#text do
        print(text[i], 10 + _camera.x, line_y + _camera.y, 7)
        line_y += line_height
    end

    print("press ❎ to start", 30 + _camera.x, line_y + _camera.y + line_height, 7)
end