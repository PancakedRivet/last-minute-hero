function new_player()
    local player = {
        sp=1,
        x=64,
        y=64,
        sp_flipx=false,
        sp_flipy=false,
        speed=2
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