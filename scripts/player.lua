function new_player()
    local player = {
        sp=1,
        x=64,
        y=64,
        sp_flipx=false,
        sp_flipy=false,
        speed=2,
        health=100,
        max_health=100,
        attack=10,
        defense=5
    }
    return player
end

function update_position(player)
 if btn(⬅️) then
  player.x -= player.speed
  player.sp_flipx = true
 end
 
 if btn(➡️) then
  player.x += player.speed
  player.sp_flipx = false
 end
 
 if btn(⬆️) then
  player.y -= player.speed
 end
 
 if btn(⬇️) then
  player.y += player.speed
 end
end

function draw_player(player)
 spr(player.sp, player.x, player.y, 1, 1, player.sp_flipx, player.sp_flipy)
end

function draw_status(player)
 draw_hp_bar(player)
 print("Health: "..player.health.."/"..player.max_health, 1, 9, 8)
 print("Attack: "..player.attack, 1, 17, 8)
 print("Defense: "..player.defense, 1, 25, 8)
end

function draw_hp_bar(player)
 local bar_width = 40
 local bar_height = 8
 local health_ratio = player.health / player.max_health
 local filled_width = flr(bar_width * health_ratio)

 local health_color = 11 -- Green by default
 if health_ratio < 0.5 then
    health_color = 10 -- Yellow
 end
 if health_ratio < 0.2 then
    health_color = 8 -- Red
 end
 
 rectfill(0, 0, bar_width, bar_height, 0) -- Background
 rectfill(0, 0, filled_width, bar_height, health_color) -- Filled part
end