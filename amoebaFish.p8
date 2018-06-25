pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--healthiest catch
--summer slow jams 6/18

function _init()
 topspd = 3
 accl = 1
 drg = 0.8
 current = 0.2
 bounce = -0.8
 dur = 5
 max_critters=5
 critters = {}
 events = {}
 spawn_time = 70
 spawn_timer = spawn_time
 _update = menu_update
 _draw = menu_draw
end

function menu_update()
 if (btnp(❎)) then
  init_critters()
  make_player()
  _update = game_update
  _draw = game_draw
 elseif btnp(🅾️) then
  _draw = rules_draw
 end
end

function menu_draw()
 cls()
 draw_title() 
end

function rules_draw()
 cls(1)
end


function game_update()
 move_player()
 update_hook()
 update_critters()
 update_events()
end


function game_draw()
 cls()
 dbground()
 --map(0,0,0,0,16,16)
 spr(p.s,p.x,p.y,2,1)
 spr(h.s,h.x,h.y)
 draw_cilia()
 for i,c in pairs(critters) do
  spr(c.s,c.x,c.y)
 end
end

function update_events()
 for c in all(events) do
    if costatus(c) != "dead" then
      coresume(c)
    else
      del(actions,c)
    end
  end
end

-->8
--draw background
function dbground()
fillp(0b1100011001101100)
rectfill(0,16,128,108,2)
fillp()
end
-->8
--draw title background
function draw_titlebg()
	circfill(58,64,95,2)--flesh color
	circfill(58,64,82,0)--outline
	circfill(58,64,80,4)--rib thing?
	circfill(58,64,70,0)
	circfill(58,64,69,2)
	circfill(68,64,50,0)
	circfill(68,64,49,4)
	circfill(68,64,40,0)
	circfill(68,64,39,2)
	circfill(78,66,20,0)
	circfill(78,66,19,4)
	circfill(78,66,18,0)
	circfill(78,66,17,0)	
end
--draw the title box an text stuffs
function draw_titlebox()
rectfill(8,8,120,42,6)
rectfill(10,10,118,40,7)
print("healthiest catch",32,22,1)
print("press ❎ to start",32,96,7)
print("😐aefeagoewpqasdlfptafadpre",11,9,7)
print("l☉aowqv★fgv♪⬅️█☉🅾️fvlm",11,37,7)
print("press 🅾️ instructions",24,104,7)
end

function draw_title()
draw_titlebg()
map(48,48)
draw_titlebox()
end
-->8

--player functions

function make_player()
  p = { --player
   x = 60, --initial coords
   y = 60,
   dx = 0, --initial velocity
   dy = 0,
   s = 1 --sprite number
  }
  h = { --hook
   xoff = 12, --where on the body
   yoff = 8, --to attach hook
   getx = function(off) return p.x + off end,
   gety = function(off) return p.y + off end,
   s = 25,
   dx = p.dx,
   dy = p.dy,
   h = 8,
   w = 6,
   retracted = true
  }
end

function move_player()
 
 if (btn(⬅️)) then 
	  p.dx = mid(topspd*-1, p.dx-accl, topspd)
 end
	if (btn(➡️)) then
	  p.dx = mid(topspd*-1, p.dx+accl, topspd)
 end
	if (btn(⬆️)) then
	 p.dy= mid(topspd*-1, p.dy-accl, topspd)
	end
	if (btn(⬇️)) then
 	p.dy= mid(topspd*-1, p.dy+accl, topspd)
	end

 if (hits_wall()) rebound()
 
 p.x = mid(0-current,p.dx+p.x,120)
 p.y =mid(0,p.y + p.dy, 120)
 
 p.x -= current
 p.dx *=drg
 
 if (abs(p.dx)<0.02) p.dx=0
 if (abs(p.dy)<0.02) p.dy=0
end

function can_move(x,y,w,h)
return true
end

function hits_wall()
 if (p.x + current + p.dx <= 0
  or (p.x + p.dx >= 120)
  or (p.y + p.dy <= 0)
  or (p.y + p.dy >= 120)) then
 return true
 else return false
 end
end

function rebound()
 if ((p.x+p.dx <=0) or (p.x + p.dx+7 >= 127)) then
  p.dx = p.dx*bounce
 end
 
 if ((p.y+p.dy <=0) or (p.y + p.dy+7 >= 127)) then
  p.dy = p.dy*bounce
 end
end 
-->8
--critter functions
function init_critters()
 for i=1,flr(max_critters*.75) do
  spawn_timer = 0
  add_critter()
 end
end

function add_critter()
 if (#critters < max_critters
  and spawn_timer==0) then

 --spawn random baddie
 --just offscreen
 --at random height
  add(critters, {
   x = 128,
   y = flr(rnd(120)),
   s = flr(rnd(6))+16,
   dx =-(flr(rnd(8))/8)-.01,
   dy = 0,
   wv = rnd(1)+0.3,
   caught = false,
   h = 8,
   w = 8,
   caughtx = 0,
   caughty = 0
  })
  spawn_timer= spawn_time
  else spawn_timer =max(spawn_timer -1,0)
 end
end

function move_critter(c)
 if not c.caught then
  c.x += c.dx - current
  c.y += c.dy +c.wv*c.dx*sin(t()+5*3.14)
 else
  c.x = h.x -c.caughtx
  c.y = h.y - c.caughty
 end
end


function update_critters()
 foreach(critters,move_critter)

 local to_del = {}
 for c in all(critters) do
  if c.x < -8 then add(to_del, c) end
 end
 
 for c in all(to_del) do
  del(critters, c)
 end
 
 add_critter()
  
end
-->8
--hook functions
function draw_cilia()
 if not h.retracted then
  local startx = min(p.x+h.xoff,h.x)
  local starty = min(p.y+h.yoff,h.y)
  local endx = max(p.x+h.xoff,h.x)
  local endy = max(p.y+h.yoff,h.y)
 
  line(p.x+h.xoff,p.y+h.yoff,h.x,h.y,7)
 end
end

function catch()
 for c in all(critters) do
  if not (c.x>h.x+h.w or
	          c.y>h.y+h.h or
	          c.x+c.w<h.x or
	          c.y+c.h<h.y) then
	    c.caught = true
	    c.caughtx = c.x-h.x
	    c.caughty = c.y-h.y
	  end
	end
end

function update_hook()
 if (btnp(❎) and h.retracted) then
  local c = cocreate(throw_hook_up)
  add(events, c)
 elseif (btnp(🅾️) and h.retracted) then
  local c = cocreate(throw_hook_down)
  add(events, c)
 elseif h.retracted then
  h.x = h.getx(h.xoff)
  h.y = h.gety(h.yoff)
 end
 if not h.retracted then
  catch()
 end
end
 
function throw_hook_up()
	--extend hook
  h.retracted = false
  
  for i=1,20 do
    h.x += 1
    h.y -= 1
  end
  
  retract()
  
end  

--i know this isn't esp. "dry",
--but coroutines can't take
--params or return values.
function throw_hook_down()
 --extend hook
  h.retracted = false
  
  for i=1,20 do
    h.x += 1
    h.y += 1
  end
  
  retract()

end

function retract()
  --leave the hook extended 
  --for 10 ticks
  for i=1,10 do yield()end
  
  --retract hook
  local dirx = 1
  local diry = 1
  for i=1,dur do
   if (h.x > p.x) then dirx = -1 else dirx = 1 end 
   if (h.y > p.y) then diry = -1 else diry = 1 end
   local dx = (dirx*abs((h.x - (p.x+h.xoff))))/dur
   h.x += dx
   local dy = diry*abs((h.y - (p.y+h.yoff)))/dur
   h.y += dy
   yield()
  end
  
    
  h.x = h.getx(h.xoff)
  h.y = h.gety(h.yoff)
  h.retracted = true
end
__gfx__
00000000006666607760000006776000000000000666000076000000067760000677600000000000999999999999999999999999999999999999999900000000
00000000067777767776660006777600000000000677607766000000067776000677760000000000999990000009999909999999999999999999900000000000
00700700667756777777776006777600000000000677777700760000067776000677760000000600999900000000999900000999000000000000000000000000
00077000667666711777676000677660000000000067176000660600006776600067766000000760999000000000009900000000000000000000000000000000
00077000067777711775677600067600000000000007776000007600000676000006760000000076990000000000009900000000000000000000000000000000
00700700066777711776777600066660000000000077666700066600000666600006666000000076990000000000000900000000000000000000000000000000
00000000006677677777776000006000000000000077007700000000000060000000600077777760990000000000009900000000000000000000000000000000
00000000000666777777660000000000000000000000000000000000000000000000000066666600900000000000000900000000000000000000000000000000
00000a000000000000000000000000000000000000000bb000000000000000000000000006660000999999990000000000000000000000000000000000000000
000aaa00000000000000aa00000b000000000660bb0bbb0000000000000000000000000006776077999999990000000000000000000000000000000000000000
00aaaa0000888800000aaa0000bbb00b00666660b333600000000000000000000000000006777777999999990000000000000000000000000000000000000000
0aaaa0000822288000aaaa00000333bb006666000377630000000000000000000000000000671760999999999000000000000000000000000000000000000000
0aaaa00008222880000aa000000666b000066000037766b000000000000000000000000000077760999999999900000000000000000000000000000000000000
0aaaaaa000888800000000000003663000000000b63333bb00000000000000000000000000776667999999999900000000000000000000000000000000000000
00aa0a00000000000000000000bb33b000000000b00bb00000000000000000000000000000770077999999999999000000000000000000000000000000000000
00000000000000000000000000000000000000000000bb0000000000000000000000000000000000999999999999999000000000000000000000000000000000
000000000000000000000a0000000bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000aaa00bb0bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000aaaa00b3336000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaa00003776300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaa000037766b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaaaa0b63333bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000aa0a00b00bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000900000000000009900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000900000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000990000000000009900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999000000000009900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999000000000999900000000000999000009990000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999900000009999909000999099999900099999900000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999999999999999999999999999999999999999999999999
00000000000000000000000000000000000000000000000000000000000000000000000000000000999999999999999999999999999999999999999900000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000888888888888888888000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000006666600000000888888888888888888000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000627200920000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000004300007383939400000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000004454647484940000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000666666000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000025354555657585009600888888888888888888000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000666666000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000026364656667686969700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000027374757677787000000888888888888888888000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666666000000000006666600000000000000000000000000000000000000000000000000
00000000000000000000000000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666600000000000066666600000000000000000000000000000000000000000000000000
00000000000000000000000000000066000000000000888888888888888888000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000666666660000000000000000a1a0b0a0d0c0b0a0d0c0c0e0e0d0e0b0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002100000000003100110000010000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000006100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011001020000000004100610000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050002100000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011006100000000000000110000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000610000001100000051720000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000610000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002100000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061c3e30000000000e30011c3003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a3b3a1a1a3f3f3f3b3a1a3b3a1a3f3b3
__gff__
0000000000000000000002020202020000000000000000000000020200000000000000000000000000000000000000000000000000000000000002020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000000000000000000000000000018180000000000000000000000000000000000000000000000000000000000000000000000003f3f3f3f3f3f3f3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666000000000000
0000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888888
0a0c0d0b1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066000000000000000000
000000000b1a0a1818000b1a1a0a1e0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666000000888888
00000000000e18181800000c0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666000000000000
0000000000001817182400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000001717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000001700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000242424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003b3a0000000000242424240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000003b1a1a3a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b1a1a1a1a3a3b3a3e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000205002050020500305003050040500305003050020500205001050050500505018050040500505003050040501f05004050010500305002050010501f05021050230500105002050010500305003050
