function update_playing()
    game_tick += 1
    if game_tick % game_fps == 0 then
        player.score += 1
        timer_health_tick(player, game_duration_max_secs)
    end
    if player.health <= 0 then
        game_state = game_states.game_over
        return
    end

    if count(enemies) + count(spawning_enemies) < max_enemies then
        -- spawn a new enemy
        add(spawning_enemies, new_enemy())
        sfx(game_sfx.enemy_spawn)
    end

    update_position(player)
    update_check_coin_collection(player)
    update_spawning_enemies()
    update_dying_enemies()
    update_enemies()
    update_attack(player)

    -- determine whether the shop should be opened
    -- if the player is still in the area but has just left the shop,
    -- we wait for them to move far enough away from the shop area before
    -- allowing them to re-enter
    -- if is_in_shop_area(player) then
    if any_collision(player, game_flags.shop) then
        if not player.is_in_shop then
            game_state = game_states.shop
            sfx(game_sfx.shop_open)
            shop_selected_index = 1
            player.is_in_shop = true
            return
        end
    else 
        -- player is far enough away from shop area
        player.is_in_shop = false
    end
end

function draw_playing(_camera)
    cls()
    map()
    
    -- full sprite row
    draw_row(48,mapx,mapy) --hills
    --draw reduced row sprites
    draw_rr(80,mapx,mapy) --water
    draw_rr(96,mapx,mapy) --stone

    draw_corpse(corpse)

    draw_spawning_enemies(spawning_enemies)
    draw_dying_enemies(dying_enemies)
    draw_enemies(enemies)
    draw_player(player)
    
    draw_ui(player, _camera)
    draw_coins()
end

function draw_corpse(_corpse)
    if not _corpse.attacked then
        spr(_corpse.sp, _corpse.x, _corpse.y)
    end
end