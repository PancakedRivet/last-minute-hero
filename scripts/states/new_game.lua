show_story = true

function update_new_game()
    if btnp(❎) then
        new_game()
    end
    if btnp(🅾️) then
        show_story = not show_story
    end
end

local text_story = {
    "okay so here's the deal:",
    "we are under attack and",
    "our previous hero died",
    "horrifically in battle...",
    "we know it's last minute",
    "but we are counting on you",
    "to be our hero! good luck!",
}

local text_controls = {
    "⬅️, ➡️, ⬆️, ⬇️ to move",
    "❎ (x or v keys) to attack",
    "🅾️ (z or c keys) to dash",
    "you lose health every second",
    "kill enemies for gold",
    "visit the shop to spend gold",
    "don't loot the previous hero",
}

function draw_new_game(_camera)
    local line_height = 10
    local line_y = 25

    local text = show_story and text_story or text_controls

    print("last minute hero", 30 + _camera.x, 10 + _camera.y, 7)

    for i=1,#text do
        print(text[i], 5 + _camera.x, line_y + _camera.y, 7)
        line_y += line_height
    end

    line_y += 5 -- add some spacing before the options

    print("press ❎ to start", 30 + _camera.x, line_y + _camera.y, 7)
    line_y += line_height
    print("press 🅾️ for " .. (show_story and "controls" or "story"), 30 + _camera.x, line_y + _camera.y, 7)
end