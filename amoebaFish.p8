pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
end

function _update()
end

function _draw()
cls()
-- dbground()
--map(0,0) to first screen
--to title
map(112,48)
draw_title() 
--spr(1,64,20,2,1)

end
-->8
--draw background
function dbground()
fillp(0b1100011001101100)
rectfill(0,24,128,108,2)
fillp()
end
-->8
--draw title
function draw_title()
	circfill(64,64,95,2)
	circfill(64,64,82,0)
	circfill(64,64,80,13)
	circfill(64,64,70,0)
	circfill(64,64,68,2)
	circfill(64,64,50,0)
	circfill(64,64,49,13)
	circfill(64,64,40,0)
	circfill(64,64,39,2)
	circfill(64,64,20,0)
	circfill(64,64,19,13)
	circfill(64,64,18,0)
	fillp(0b1010010110100101)
	circfill(64,64,17,2)
	fillp()

	
	
	
		
end
__gfx__
00000000006666607760000000000000000000000000000000000000000000000000000000000000999999999999999999999999999999999999999900000000
00000000067777767776660000000000000000000000000000000000000000000000000000000000999990000009999909999999999999999999900000000000
00700700667756777777776000000600000000000000000000000000000000000000000000000000999900000000999900000999000000000000000000000000
00077000667666711777676000000760000000000000000000000000000000000000000000000000999000000000009900000000000000000000000000000000
00077000067777711775677600000076000000000000000000000000000000000000000000000000990000000000009900000000000000000000000000000000
00700700066777711776777600000076000000000000000000000000000000000000000000000000990000000000000900000000000000000000000000000000
00000000006677677777776077777760000000000000000000000000000000000000000000000000990000000000009900000000000000000000000000000000
00000000000666776666660066666600000000000000000000000000000000000000000000000000900000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999999990000000000000000000000000000000000000000
00000000000000000000aa0000030000000006600000000000000000000000000000000000000000999999990000000000000000000000000000000000000000
0000000000888800000aaa0000333003006666600000000000000000000000000000000000000000999999990000000000000000000000000000000000000000
000000000822288000aaaa0000033633006666000000000000000000000000000000000000000000999999999000000000000000000000000000000000000000
0000000008222880000aa00000066630000660000000000000000000000000000000000000000000999999999900000000000000000000000000000000000000
00000000008888000000000000033660000000000000000000000000000000000000000000000000999999999900000000000000000000000000000000000000
00000000000000000000000000336630000000000000000000000000000000000000000000000000999999999999000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999999999999999000000000000000000000000000000000
000000000000000000000a0000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000aaa0033033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000aaaa0036666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaa00006776600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaa00006776630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaaaa036666633000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000aa0a0030033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000900000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000990000000000009900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000990000000000000900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999000000000009900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999900000000009900000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999900000000999900000999000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000999990000009999909999999999999999999900000000000
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
00000000000000000000000000000000000000000000000000000066666666600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000213141516171819100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666666600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000223242526272829200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066000000000000888888888888888888000000000000000000000000000000000000000000
00000000000000000000000000233343536373839300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000243444546474849400000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066600000000000888888888888888888000000000000000000000000000000000000000000
00000000000000000000000000253545556575859500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666666600000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000263646566676869600888888888888888888000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000666666000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000273747576777879700000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000888800000000000000888888888888888888000000000000000000000000
00000000000000000000000000283848586878889800888888888888888888000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000066666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666666600000888806666600000000888888888888888888000000000000000000000000
00000000000000000000000000000066666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666666000000000066666666600000000000000000000000000000000000000000000000
00000000000000000000000000000066000000000000888888888888888888000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000066666666600000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000011
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000011
__map__
0000000000000000000000000000181800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666000000000000
0000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888888
8888888888881a1a1a1a1a1a1a1a1a1a07070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066000000000000000000
0000000000000a1818190b1a1a0a1e0b00070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666060000888888
88888888888818181800080c0e19000700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066666666000000000000
0000000000001817182400001907070700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12191c17171c0000001107070707070000000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000017121c0007070700070000000000000007070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707071207071107000023070007070000000000070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0711070000000000120707070707000000000000070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000707003b3a00002d0707070719130909000000070700070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000073b1a1a3a00191919071107070900000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05003b1a1a1a1a3a3b3a3e070707070900000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070707000000070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707000007070707070707070707070707000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000205002050020500305003050040500305003050020500205001050050500505018050040500505003050040501f05004050010500305002050010501f05021050230500105002050010500305003050
