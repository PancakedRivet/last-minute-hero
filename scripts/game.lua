game_states = {
    new_game = 0,
    playing = 1,
    game_over = 2,
    shop = 3
}

game_sprites = {
    health = 2,
    enemy = 17,
    coin = 3,
    score = 19
}

function new_game()
    player = new_player()
    game_state = game_states.playing
end