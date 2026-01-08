function draw_ui()
    rectfill(0, 0, 128, 9, 6) -- UI Background
    draw_status_bar(player.health, player.max_health, 9, 2, 77, 3) 
    -- Health sprite in top left corner
    spr(game_sprites.health, 1, 1)
    -- Coin UI
    spr(game_sprites.coin, 90, 1)
    print(player.coins, 97, 3, 7)
    -- Score UI
    spr(game_sprites.score, 108, 1)
    print(player.score, 116, 3, 7)
end