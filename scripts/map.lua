map_size = {
    width = 128,
    height = 128
}

--get offset number from map
--s is the sprite thats being matched
function gos(x,y,s)
    local o=0   
    if(mget(x-1,y-1)==s)o+=8
    if(mget(x,y-1)==s)o+=4
    if(mget(x-1,y)==s)o+=2
    if(mget(x,y)==s)o+=1
    return o
end

--use this for row layout
--draw map from ordered sprites
function draw_row(rowstart,mx,my)
    for x=mx,mx+16 do
        for y=my,my+16 do
        local offset=gos(x,y,rowstart+15)
            if(offset>0)spr(rowstart+offset,x*8-4,y*8-4)
        end
    end
end

--use this for reduced sprites row layout 
--sprite is the first sprite in set/row 
function draw_rr(sprstart,mx,my)
    for x=mx,mx+16 do --full screen
        for y=my,my+16 do 
        local o=gos(x,y,sprstart+5)
            if o>0 then --if not ground draw
                spr(sprstart+rsl[o+1][1],x*8-4,y*8-4,1,1,rsl[o+1][2]>0,rsl[o+1][3]>0)           
            end               
        end
    end
end

--spt converts a data string into a 2d array
--e.g. "1,2,3|4,5,6" -> {{1,2,3},{4,5,6}}
function spt(datastring)
    local v=split(datastring,"|")
    for i=1,#v do 
        v[i]=split(v[i])
    end
    return v
end

--map_collision checks map() for collisions 
--between obj and tiles with a set flag
function map_collision(obj,flag)
    local sprite_size = 8 -- 8px x 8px sprites
    -- width and height of the object assume top left corner is 0,0
    local x,y,w,h = obj.x,obj.y,obj.w,obj.h
    -- get the pixel coordinates of the top left corner of the object
    local x0,y0 = (x+1)\sprite_size,(y+1)\sprite_size
    -- get the pixel coordinates of the bottom right corner of the object
    local x1,y1 = (x+w-1)\sprite_size,(y+h-1)\sprite_size
    -- get the map tile values at the four corners of the object
    local m1=mget(x0,y0)
    local m2=mget(x1,y0)
    local m3=mget(x0,y1)
    local m4=mget(x1,y1)
    -- check if any of the tiles have the collision flag set
    collisions = {
        top_left = fget(m1,flag),
        top_right = fget(m2,flag),
        bottom_left = fget(m3,flag),
        bottom_right = fget(m4,flag)
    }
    return collisions
end

function any_collision(obj,flag)
    local collisions = map_collision(obj,flag)
    return collisions.top_left or collisions.top_right or collisions.bottom_left or collisions.bottom_right
end