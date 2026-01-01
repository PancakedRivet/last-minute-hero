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
 print("Health: "..player.health.."/"..player.max_health, 1, 9, 8)
 print("Attack: "..player.attack, 1, 17, 8)
 print("Defense: "..player.defense, 1, 25, 8)
end
