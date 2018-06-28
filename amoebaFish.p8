pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--healthiest catch
--summer slow jams 6/18
--by nextlevelbanana & tyedye105
--thanks to mboffin and cortex:
--i definitely cribbed heavily
--from your carts

function _init()
 topspd = 2.9
 accl = 1
 drg = 0.8
 current = 0.2
 bounce = -0.8
 dur = 5
 max_critters=8
 critters = {}
 events = {}
 spawn_time = 60
 screentop = 16
 screenbase = 112
 screenl = 0
 screenr = 127
 spawn_timer = spawn_time
 flags = {
  p = 2
 }
 stuck = {}
 space = 0
 has_loaded = false
 health = 50
 hooked = 0
 lvl = 1
 _update = menu_update
 _draw = menu_draw
 tick = 1
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
 check_end()
end


function game_draw()
 cls()
 dbground()
 map(0,0,0,0,16,16)
 --draw stuck cholesterol
 for s in all(stuck) do
  spr(s.s,s.x,s.y)
 end

 --draw player + hook
 spr(p.s,p.x,p.y,2,1)
 spr(h.s,h.x,h.y)
 draw_cilia()
 print("hooked: "..hooked,80,2,15)
 print("host health: "..health,2,2,7)
 for i,c in pairs(critters) do
  spr(c.cs,c.x,c.y)
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

function level_up()
 lvl = flr(hooked/10)
 if (hooked > 0 and hooked %10 == 0) then
  max_critters += 3
  spawn_timer = 0
  --add_critter()
  spawn_time -=5
  cls(9)
  flip()
  cls(10)
  flip()
  cls(9)
  flip()
 end
end

function check_end()
 if (is_clogged()) then
  _draw = game_over_draw
  _update = game_over_update
 elseif health > 100 then
  _update = game_over_update
  _draw = game_win_draw
 end
end

function game_over_update()
  if (btn(❎)) _init()
end

function game_over_draw()
 cls(8)
 print("oh crap, your host died!",20,60,0)
 print("❎ to play again",20,80,0)
end

function game_win_draw()
 cls(1)
 print("woo, you win!",20,60,7)
end

function is_clogged()
 if (health <= 0) return true
end
-->8
--draw background
function dbground()
fillp(0b1100011001101100)
rectfill(screenl,screentop,screenr,screenbase-2,2)
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
   s = 1, --sprite number
   h = 8,
   w = 16
  }
  h = { --hook
   xoff = 12, --where on the body
   yoff = 8, --to attach hook
   getx = function(off) return p.x + off end,
   gety = function(off) return p.y + off end,
   s = 48,
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


 local x1 = p.x + p.dx
 local y1 = p.y + p.dy
 if hits_wall(x1,y1) or hits_plaque(x1,y1,p) then
  rebound(x1,y1)

else 
  p.x = mid(screenl-current,p.dx+p.x,screenr-p.w)
  p.y =mid(screentop,p.y + p.dy, screenbase - p.h)
 
  p.x = max(p.x-current,0)
  p.dx *=drg
 end
 
 if (abs(p.dx)<0.02) p.dx=0
 if (abs(p.dy)<0.02) p.dy=0
end

--x1 and y1 are the projected new coords
function hits_wall(x1,y1)
 if (x1 + current <= screenl
  or (x1 >= screenr-p.w)
  or (y1 <= screentop)
  or (y1 >= screenbase-p.h)) then
 return true
 else return false
 end
end


function rebound(x1,y1)
 --if ((x1 <=screenl) or (x1+p.w >= screenr)) then
  p.dx = p.dx*bounce
-- end
 
-- if ((y1 <=screentop) or (y1+p.h >= screenbase)) then
  p.dy = p.dy*bounce
-- end
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
 --randomly selects a sprite from contiguous series
 --dx random btwn -.01 and -.8
 
  local c = {
   x = screenr + 1,
   y = rndintb(screentop+16,screenbase-16),
   s = rndintb(3,10),
   cs = 3,
   dx = -(flr(rnd(8))/8)-.01,
   dy = 0,
   wv = rnd(1)+0.3,
   caught = false,
   h = 8,
   w = 8,
   stuck = false
  }
  c.cs = c.s
  
  if (c.s == 3) c.h = 4 c.w = 6
  if (c.s ==4) c.h = 4 c.w = 4
  if (c.s == 5) c.h = 7 c.w = 6
  if (c.s == 6) c.h = 7 c.w = 6
  if (c.s == 8) c.h = 4 c.w = 5
  add(critters,c)
  
  spawn_timer= spawn_time
  else spawn_timer =max(spawn_timer -1,0)
 end
end

function move_critter(c)
 local x1 = c.x + c.dx - current
 local y1 = c.y + c.dy
 
 if not c.stuck then
  if not c.caught then
   
   if hits_plaque(x1,y1,c) then
    if fget(c.s,2) then
     c.x = x1
     c.y = y1
     c.dx = 0
     c.dy = 0
     c.cs +=64
     c.s = c.cs
     c.stuck = true
     add(stuck,c)
     del(critters,c)
     health -=5
    else
     rebound_plaque(c)
    end
   else -- doesn't rebound 
    c.x += c.dx - current
    c.y += c.dy +c.wv*c.dx*sin(t()+5*3.14)
   end
  else --is caught
   c.x = h.x +4
   c.y = h.y +4
  end
 end
end


function update_critters()
 foreach(critters,move_critter)
 foreach(critters,anim_critter)
 tick += 1
 local to_del = {}
 for c in all(critters) do
  if c.x +c.w < screenl or
  (c.x > screenr and c.dx > 0) then 
    add(to_del, c)
  end
 end
 
 for c in all(to_del) do
  if (not fget(c.s,3)) health -= 3
  del(critters, c)
 end
 
 add_critter()
  
end

function anim_critter(c)
 if (fget(c.s,3)) return
 if (tick %10 == 0) then
  c.cs += 16
  if c.cs > c.s + 48 then
   c.cs = c.s
  end
 end
end

function score_hooked_critters(to_score)
 for c in all(to_score) do
  if (fget(c.s,3)) then
	  health -=5
	 else
	  health += 3
	  hooked += 1
	  level_up()
	 end
	end   
end
-->8
--hook functions
function draw_cilia()
 if not h.retracted then 
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
	    
	    c.caughtx = h.x+4
	    c.caughty = h.y+4
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
-- if not h.retracted then
 -- catch()
 --end
end
 
function throw_hook_up()
	--extend hook
  h.retracted = false
  
  for i=1,20 do
    h.x += 1
    h.y -= 1
    catch()
 --   yield()
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
    catch()
--    yield()
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
   catch()
   yield()
  end
  
    
  h.x = h.getx(h.xoff)
  h.y = h.gety(h.yoff)
  h.retracted = true
  
  remove_hooked()
end

function remove_hooked()
 local to_del = {}
 for c in all(critters) do
  if c.caught then
   add(to_del,c) 
  end
 end
 
 score_hooked_critters(to_del)
 
 for c in all(to_del) do
  del(critters, c)
 end
 
end
-->8
--utils and shared
--player/critter functions

--random number between a (inc)
--and b (exc)
function rndb(a,b)
 return rnd(b-a) +a
end

--random integer between a (inc)
--and b (exc)
function rndintb(a,b)
 return flr(rndb(a,b))
end

function get_flag(x,y)
 return fget(mget(flr(x/8),flr(y/8)))
end

function is_plaque(i,j)
 return pget(i,j) == 9 
end

function is_critter(i,j)
 return get_flag(x,y) == 4
end

function hits_plaque(x1,y1,obj)
 for i=x1,x1+obj.w-1 do
  for j = y1,y1+obj.h-1 do
   if (is_plaque(i,j) ) then
    return true
   end
  end
 end
 return false
end

function rebound_plaque(critter)
 if critter == nil then
  p.dx *= bounce
  p.dy *= bounce
 else 
  critter.dx *= bounce
  critter.dy *= bounce
 end
end
__gfx__
0000000000666660776000000888800000aa00000000a0000b00000000000bb00006600000000033000000000000000000000000000000000000000000000000
000000000677777677766600822288000aaa000000aaa000bbb00b00bb0bbb006666600033000003000000000000000000000000000000000000000000000000
00700700667756777777776082228800aaaa00000aaaa0000333bb00b33360006666000030000033000000000000000000000000000000000000000000000000
000770006676667117776760088880000aa00000aaaa00000666b000037763b00660000033000003000000000000000000000000000000000000000000000000
0007700006777771177567760000000000000000aaaa000003663000037766bb0000000030baab30000000000000000000000000000000000000000000000000
0070070006677771177677760000000000000000aaaaaa000b33b000b63333000000000003aaaa00000000000000000000000000000000000000000000000000
00000000006677677777776000000000000000000aa0a000b0000000b00bb00000000000003aa300000000000000000000000000000000000000000000000000
000000000006667777776600000000000000000000000000000000000000bb000000000000300030000000000000000000000000000000000000000000000000
0099000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000000000000000000
09990000000000000000000000000000000aa00000000000bbb00000bb00bbbb0000660033000033000000000000000000000000000000000000000000000000
9999000000000000000000000000000000aaa00000000a000333bbb0b33360000666660030000003000000000000000000000000000000000000000000000000
099000000000000000000000000000000aaaa000aaa00aa00666b000037763000666600033000033000000000000000000000000000000000000000000000000
0000000000000000000000000000000000aa00000aaaaa0003663000037766b00066000030baab03000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000aaaaaa00b33b000063333bb0000000003aaaa30000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000aaaaa00b0000000b00bb0000000000003aa300000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000aaa000000000000000bb00000000003000030000000000000000000000000000000000000000000000000
0000900000000000000000000000000000000000000000000b000000000000000000006633000000000000000000000000000000000000000000000000000000
0099900000000000000000000000000000000000000a0aa0bbb00000bb00bb000006666630000033000000000000000000000000000000000000000000000000
0999900000000000000000000000000000aa000000aaaaaa0333b000b3336bb00006666033000003000000000000000000000000000000000000000000000000
999900000000000000000000000000000aaa00000000aaaa0666bb00037763000000660030000033000000000000000000000000000000000000000000000000
99990000000000000000000000000000aaaa00000000aaaa036630b0037766000000000003baab03000000000000000000000000000000000000000000000000
999999000000000000000000000000000aa00000000aaaa00b33b000063333b00000000000aaaa30000000000000000000000000000000000000000000000000
0990900000000000000000000000000000000000000aaa0000b000000b000bbb00000000003aa300000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000a00000000000000b000bb0000000003000300000000000000000000000000000000000000000000000000
066600000000000000000000000000000000000000aaa0000b000000000000000000000000000000000000000000000000000000000000000000000000000000
06776077000000000000000000000000000aa0000aaaaa00bbb00000bb00bbbb0000660033000033000000000000000000000000000000000000000000000000
0677777700000000000000000000000000aaa0000aaaaaa00333bbb0b33360000666660030000003000000000000000000000000000000000000000000000000
006717600000000000000000000000000aaaa00000aaaaa00666b000037763000666600033000033000000000000000000000000000000000000000000000000
0007776000000000000000000000000000aa00000aa00aaa03663000037766b00066000030baab03000000000000000000000000000000000000000000000000
007766670000000000000000000000000000000000a000000b33b000063333bb0000000003aaaa30000000000000000000000000000000000000000000000000
0077007700000000000000000000000000000000000000000b0000000b00bb0000000000003aa300000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000bb00000000003000030000000000000000000000000000000000000000000000000
00000000000000000000000000000000009900000000900000000000000000000000000000000000999999999999999999999999999999999999999999999999
00000000000000000000000000000000099900000099900000000000000000000000000000000000999990000009999909999999999999999999900000000000
00000000000000000000000000000000999900000999900000000000000000000000000000000000999900000000999900000999000000009990000000000000
00000000000000000000000000000000099000009999000000000000000000000000000000000000999000000000009900000000000000000000000000000000
00000000000000000000000000000000000000009999000000000000000000000000000000000000990000000000009900000000000000000000000000000000
00000000000000000000000000000000000000009999990000000000000000000000000000000000990000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000990900000000000000000000000000000000000990000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000900000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999999990000000000000000999900000000000000000000
00000000000000000000000000000000000990000000000000000000000000000000000000000000999999990000000000000000999999900000000000000009
00000000000000000000000000000000009990000000090000000000000000000000000000000000999999990000000000000000999999990000000000000000
00000000000000000000000000000000099990009990099000000000000000000000000000000000999999999000000000000000999999990000000000000009
00000000000000000000000000000000009900000999990000000000000000000000000000000000999999999900000000000000999999990000000000000009
00000000000000000000000000000000000000000999999000000000000000000000000000000000999999999900000000000000999999990000000000000999
00000000000000000000000000000000000000000099999000000000000000000000000000000000999999999999000000000000999999990000000000009999
00000000000000000000000000000000000000000009990000000000000000000000000000000000999999999999999000000000999999990000000099999999
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000999999
00000000000000000000000000000000000000000009099000000000000000000000000000000000000000000000000000000000000000000000000000099999
00000000000000000000000000000000009900000099999900000000000000000000000000000000000000000000000000000000000000000000000000009999
00000000000000000000000000000000099900000000999900000000000000000000000000000000000000000000000000000000000000000000000000000099
00000000000000000000000000000000999900000000999900000000000000000000000000000000000000000000000000000000000000000000000000000099
00000000000000000000000000000000099000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000009
00000000000000000000000000000000000000000009990000000000000000000000000000000000000000000000000000000000000000000000000000000099
00000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000000000000000009
00000000000000000000000000000000000000000099900000000000000000000000000000000000000000000000000900000000000000000000000000000000
00000000000000000000000000000000000990000999990000000000000000000000000000000000900000000000009900000000000000000000000000000000
00000000000000000000000000000000009990000999999000000000000000000000000000000000900000000000000900000000000000000000000000000000
00000000000000000000000000000000099990000099999000000000000000000000000000000000990000000000009900000000000000000000000000000000
00000000000000000000000000000000009900000990099900000000000000000000000000000000999000000000009900000000000000000000000000000000
00000000000000000000000000000000000000000090000000000000000000000000000000000000999000000000999900000000000999000009990000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999900000009999909000999099999900099999900000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999999999999999999999999999999999999999999999999
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
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a5a4b4a5a5a4c4e4f4b4a5a5a5a4f4b4
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a40000c4000000000000f4e4e4000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070300000000000000000000030000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000810000008100000081000081008130
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000900000000000610000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000102000000000007000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005100000000003000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000061000000000000000000000000400000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000003000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d70000000000c7d792000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a7e7c7b7a5a7c7d7c7b7a5a5a7c7e7b7
__gff__
0000000804041010101000000000000002000000040400000000000000000000020000000404000000000000000000000000000004040000000000000000000000000000020200000000020202020202000000000404000000000202000200020000000004040000000000000000000200000000040400000000020202020202
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
5c5c5c5c3c3c3c3c3c3c3c3c3c3c3c3c3c2c2d2e2f0000000000000000000000000000000000000000000000000000003c3d3e3f3f3f3f3f3f003f3c3d3e3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666000000000000
2e2e2e3c5c3c3c3c3c3c3c3c3c3c3c3c3c3c3d3e3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888888
4a4c4e4b5a5a5a5a5a5a5a5a5a5a5a5a0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066000000000000000000
2e2e2e2e4b5a4a2e2e2e2e4b5a5a4a4b5e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666000000888888
0a2e0d0e2e4e2e2e2e2e2e2e4c4e2e2e2f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666000000000000
003c3d3e3f3c3d3e3f3c003e003c3d3e3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0c0d0e5c0c0d0e0f0c0d000000000e0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1f1c1d1e5c5c1d1e1f0000000000001e1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f2c2d2e2f2c2d2e2f2c00000000002e2f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f3c3d3e3f3c3d3e3f3c3d3e3f3c3d3e3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006d7b7a1a1a3a3b2c2d00002c2d2e0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a6f5a5a7a1a1a1a3c3d3e3f3c3d3e1f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
006d5f5a5a5a7a0000006d7b7a0000002f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7c5f5a5a5a5a5a7a7c7e7b5a5a7a7e7d3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
005e5e5e5e5e5e5e5e5e5e5e5e5e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0d0e0f000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c1d1e1f000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002c2d2e2f000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c3d3e3f000000000000000000000000
__sfx__
000100000205002050020500305003050040500305003050020500205001050050500505018050040500505003050040501f05004050010500305002050010501f05021050230500105002050010500305003050
