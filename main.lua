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
 draw_player(player)
 draw_status(player)
end