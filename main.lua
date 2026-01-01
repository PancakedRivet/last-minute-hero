function _init()
 -- Initialization code here
 player = new_player()
end

function _update()
 -- Update logic here
update_position(player)
end

function _draw()
 cls()
 print("Last Minute Hero!", 40, 1, 7)
 spr(player.sp, player.x, player.y, 1, 1, player.sp_flipx, player.sp_flipy)
end