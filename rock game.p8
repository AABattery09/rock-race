pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	cls(0)
	timer=0
	wint=0
	blinkt=1
	scroll=127
	startscreen()
	map_setup()
	make_player()
	rock2uh()
	rock3()
		cursx=30
	cursy=50
	menu1=10
	menu2=7
	mode="story"
--	cursx=35
	--cursy=60
	n=10
	m=500
	xlock=true
	zlock=false
	txtwave=1
	lockout=0
	shopenter=1
	shop={}
--	nextwave()
end


function _update()
	blinkt+=1
	if mode=="menu" then
		upd_menu()
	elseif mode=="story" then
	 update_story()
	elseif mode=="shop" then
		upd_shop()
	elseif mode=="wager" then
		upd_wager()
	elseif mode=="rsg" then
	upd_rsg()
	elseif mode=="game" then
		_upd()
	elseif mode=="over" then
		upd_over()
	elseif mode=="win" then
		upd_win()
	elseif mode=="lose" then
		upd_lose()
	elseif mode=="marry" then
		upd_marry()
	end
	--spawnwave()

end


function _draw()
	_drw()
	if mode=="menu" then
		drw_menu()
	elseif mode=="story" then
	 draw_story()
 elseif mode=="shop" then
		drw_shop()
		elseif mode=="wager" then
		drw_wager()
		elseif mode=="rsg" then
	drw_rsg()
	elseif mode=="game" then
		_drw()
		elseif mode=="over" then
			drw_over()
		elseif mode=="win" then
			drw_win()
		elseif mode=="lose" then
			drw_lose()
		elseif mode=="marry" then
			drw_marry()
	end
end

function drwmyspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y,myspr.sprw,myspr.sprh)

end
-->8
--map

function map_setup()
	timer=0
	ani_frame=30
	
	wall=0
end

function upd_map()
	if timer<0 then
		timer=ani_frame
	end
	timer-=1
end

function drw_map()
	mapx=flr(p.x/16)*16
	mapy=flr(p.y/16)*16
		camera(mapx*8, mapy*8)

	map(0,0,0,0,128,64)
end	
-->8
--player code

function make_player()

p={}

p.x=0
p.y=7

p.ox=0
p.oy=0

p.maxox=2

p.w=1
p.h=1

p.spr=1
p.flip=false

p.spd=rnd(0.5)
end


function drw_player()
	spr(p.spr,p.x*8,p.y*8,1,1,p.flip)
end




function move_player()
	p.ox=p.x
	p.oy=p.y
	lockout-=1
	
	if btnp(❎) and lockout<=0 and xlock==false then
		p.x+=rnd(0.1)
		p.spr+=1
		xlock=true
		zlock=false
		lockout=2
		if p.spr>3 then
			p.spr=2
		end
	end
	
	if btnp(🅾️) and lockout<=0 and zlock==false then
		p.x+=rnd(0.3)
		p.spr+=1
		lockout=2
		xlock=false
		zlock=true
		if p.spr>3 then
			p.spr=2
		end
	end


end
-->8
--other rocks
function rock2uh()
	r={}
	
	r.spr=17
	r.x=0	
	r.y=8
	r.ox=0
	r.oy=0
	r.w=1
	r.h=1
	r.spd=rnd(0.29)
	
end

function rock3()
t={}
	
	t.spr=18
	t.x=0	
	t.y=9.2
	t.ox=0
	t.oy=0
	t.w=1
	t.h=1
	t.spd=rnd(0.29)
end



function drw_rock2()
		spr(r.spr,r.x,r.y*8,r.w,r.h)
end

function drw_rock3()
		spr(t.spr,t.x,t.y*8,t.w,t.h)
end

function move_rocks()
	if r.x<=p.x then
		r.x+=r.spd+rnd(0.9)
	elseif r.x>p.x then
		r.x+=r.spd
	end

	if t.x<=p.x then
		t.x+=t.spd+rnd(0.9)
	elseif t.x>p.x then
		t.x+=t.spd
	end	
end
-->8
--update

function _upd()
	move_player()
	move_rocks()
	if p.x>15 then
		mode="win"
		--[[if mode=="win" and m>=10001 then
			mode="marry"
		end]]--
	elseif r.x>(15*8) or t.x>(15*8) then
		mode="lose"
	end

end

function upd_menu()

	p.x=0
	r.x=0
	t.x=0
	if btnp(⬆️) then
	 cursy=50
	 	menu1=10
		menu2=7
	end
	
	if btnp(⬇️) then
	 cursy=65
	 	menu1=7
		menu2=10
	end

	
	
	if btnp(❎) or btnp(🅾️) then
		if cursy==50 then
		mode="wager"

		else
		mode="shop"

		end
	end
end



function upd_shop()
--placing the items
	placens({1,2,3})
	
	--moving the cursor
		if btnp(➡️) then
			cursx+=33
			if cursx>=95 then
				cursx=95
			end
		end
		if btnp(⬅️) then
			cursx-=33
			if cursx<=30 then
				cursx=30
			end
		end
		
		if m>=100 and btnp(🅾️) then
			del(shop,item)
			
			m-=100
		end
	
	
	
	--leaving the shop and dialogue
	if btnp(❎) then
		mode="menu"
		shopenter+=1
		if shopenter>50 then
			shopenter=2
		end
				

		

	--animating shop items
		for item in all(shop) do
			item.aniframe+=0.08
			
		if flr(item.aniframe) > #item.ani then
			item.aniframe=1
		end
		item.spr=item.ani[flr(item.aniframe)]

		end
	
	end
	
end


function upd_wager()
	if btnp(➡️) then
		n+=10
		if n>m then
		n=m
		end
	elseif btnp(⬅️) then
		n-=10
		if n<10 then
		n=10
		end

	end
	
	if btnp(🅾️) then
	m-=n
	mode="rsg"
	end
end

function upd_rsg()
	timer+=1
	if timer==60 then
		txtwave=2
	elseif timer==120 then
		txtwave=3
	elseif timer==160 then
		mode="game"
	end
	if mode=="game" then
		timer=0
		txtwave=1
	end	
end

function upd_over()
	n=10
	
	if btn(❎)==false and btn(🅾️)==false then
		btnreleased=true
	end
	if btnreleased then
		if btnp(❎) or btnp(🅾️) then
			mode="menu"
			p.spr=1
			m=500
			btnreleased=false
		end
	end
end

function upd_win()

	
	wint+=1
	if wint>20 then
	if mode== "win" and btnp(❎) or btnp(🅾️) then
		m+=(n*2)
		
	end
		if btnp(❎) or btnp(🅾️) then
			p.x=0
			r.x=0
			t.x=0
			if m>=1000 then
		mode="marry"
		else
			mode="menu"	
						n=10

		end
		end
		if mode=="wager" then
			wint=0
		end
	end
end

function upd_lose()
if m<=0 then
		mode="over"
end
wint+=1
	if wint>20 then
		if btnp(❎) or btnp(🅾️) then
			p.x=0
			r.x=0
			t.x=0
			if m>0 then
				mode="menu"
				n=10
			--elseif m==0 then
			--	mode="over"
			end
		end
		end
		if mode=="wager" then
			wint=0
		end
	
end



function upd_marry()
	n=10
	if btn(❎)==false and btn(🅾️)==false then
		btnreleased=true
	end
	if btnreleased then
		if btnp(❎) or btnp(🅾️) then
			mode="menu"
			m=500
			btnreleased=false
		end
	end
end
-->8
--draw

function _drw()
	cls()

	drw_map()
	drw_player()
	drw_rock2()
	drw_rock3()
		print("money:"..m,1,100,10)
	
end

function drw_menu()
 rrectfill(0,35,129,80,0,0)
	print("rock race!!!",44,25,blink())
--	print("❎ or 🅾️ to start",58,40,7)
 print("race",45,50,menu1)
 print("shop",45,65,menu2)
	print("★",cursx,cursy,10)
end


function drw_shop()
	cls()
	print("money:"..m,1,1,10)
	spr(19,120,120,1,1)
	if shopenter==1 then
		print("welcome friend.",50,90,6)
		print("take what you need...",40,100,6)
		print("for the right price.",40,110,11)
		rect(33,80,125,120,5)
	end
	
	print("★",cursx,cursy+5,7)

	
	
	for item in all (shop) do
		drwmyspr(item)
	--	price=100
	print(item.price,item.x-2,item.y+10,10)
	end
	
end

function drw_wager()
--cls()
_drw()
print("how much would",35,20,7)
print("you like to wager?",30,30,7)
print("⬅️",40,40,blink())
print("➡️",80,40,blink())
print(n,58,40,blink())
end



function drw_rsg()
	cls()
	_drw()
	--print(t,50,50,6)
	print("ready?",50,30,7)	
	if txtwave==2 then
		cls()
		_drw()
		print("set?",55,30,7)
	elseif txtwave==3 then
		cls()
		_drw()
		print("go!!!",55,30,blink())
	end
end

function drw_game()
	cls()
	_drw()
end

function drw_over()
	cls()
	print("you are broke", 40,50,blink())
	print("❎ or 🅾️ to try again",25,70,7)
end

function drw_win()
	cls()
	
	_drw()
	p.spr=1
	print("winner!", 50,40,blink())
	print("❎ or 🅾️ to go again",25,48,blink())
end

function drw_lose()
	cls()
	_drw()
	p.spr=1
	print("too slow", 50,30,6)
	print("❎ or 🅾️ to try again",25,38,6)
end


function drw_marry()
	cls(14)
	print("rock marriage.",38,40,0)
	spr(34,62,50,2,2)
	spr(32,49,50,2,2)
	p.spr=1
end

function drwmyspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y)

end
-->8
--modes
function startscreen()
	mode="start"
end


-->8
--functions

function blink()
	local banim={10,10,10,6,6,7,7,7,7,7,10,10,10}
	if blinkt>#banim then
		blinkt=1
	end
	return banim[blinkt]
end


function scrolltxt()
 scroll-=.2
 if btn(2) then
  scroll-=.5
 end
 
 if btn(3) then
  scroll+=1
 end
end

function cprint(txt,x,y,c)
 print(txt,x-#txt*2,y,c)
end
-->8
--[[ to do

1. increase rock speed when you win

3. random text lines while racing

4. sfx

5. music

6. try again text delete when broke text appears

7. timer when marriage or game over so player
			doesn't mash through it
			
8. maybe change ready to rock

]]

function update_story()
 scrolltxt()
 
 
 if btn(4)==false and btn(5)==false then
  btnreleased=true
 end
	if btnreleased then
	 if btnp(4) and scroll<=100 then
	  mode="menu"
	  sfx(1)
	  btnreleased=false
	 end
	end

end
function draw_story()

cls(0)



if scroll<=100 then
 print("🅾️",115,3,blink())
end
print("⬆️ ⬇️ ",3,3,blink())
--if wave==0 then
cprint("rockathan,",64,scroll,7)
cprint("who loves rockmantha,",64,scroll+10,7)
cprint("wants to take her hand(?)",64,scroll+20,7) 
cprint("in marriage.",64,scroll+30,7)
cprint("however, rockathan is broke.",64,scroll+40,7)
cprint("there was only one thing",64,scroll+50,7)
cprint(" he could do.",64,scroll+60,7)
cprint("rockathan entered himself",64,scroll+70,7)
cprint(" in the rock race!",64,scroll+80,7)
cprint("it was risky, but",64,scroll+90,7)
cprint("if he wins $1000, rockathan can",64,scroll+100,7)
cprint("pay for their wedding.",64,scroll+110,7)
cprint("now, on the field,",64,scroll+120,7)
cprint("rockathan is ready to rock.",64,scroll+130,7)

--cprint("🅾️",64,scroll+190,blink())




rect(0,0,127,127,14)




end

-->8
--shop

function makespr()
	local myspr={}
	myspr.x=0
	myspr.y=0
	myspr.ox=0
	myspr.oy=0
	myspr.maxox=0
	myspr.spr=0
	myspr.sprw=1
	myspr.sprh=1
	myspr.colw=8
	myspr.colh=8
	myspr.flip=false
	myspr.spd=0
	myspr.aniframe=1
	return myspr
end


function spawnen(entype,enx,eny)
	local item=makespr()
	item.x=enx*8
	item.y=50*8
	
	item.posx=enx
	item.posy=eny
	
	if entype==nil or entype==1 then
		item.spr=66
		item.ani={66,67}
		item.x=30
		item.y=50
		item.price=100
		
	elseif entype==2 then
		item.spr=69
		item.x=62
		item.y=50
		item.ani={69,70}
		item.price=300

	elseif entype==3 then
		item.spr=72
		item.x=95
		item.y=50
		item.ani={72,73}
		item.price=500
	end
	add(shop,item)

end

--[[function shopstuff(entype)
shop={}
	local item={}
	item.x=30
	item.y=50
	--myen.flash=0
	item.aniframe=1

	
	
	if entype==nil or entype==1 then
		item.spr=66
		item.ani={66,67}
		price=100
	elseif entype==2 then
		--orange guy
		item.spr=69
		item.x=50
		item.y=50
		item.ani={69,70}
		price=300
	elseif entype==3 then
		--other green guy
		item.spr=72
		item.x=70
		item.y=50
		item.ani={72,73}
		price=500
	end
	
	add(shop,item)
end]]
	
function placens(lvl)

	for x=1,3 do
		spawnen(lvl[x],x*8,50*8)
	end

end


function drwmyspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y)

end


--[[function spawnwave()
	if wave==1 then
		shopstuff(1)
	elseif wave==2 then
		shopstuff(2)
	elseif wave==3 then
		shopstuff(3)
	end
end

function nextwave()
	if m>500 then
		wave=2
	elseif m>800 then
		wave=3
	end
end]]
__gfx__
0000000000000000000000000000000000000000cccccccccccccccc4333334444444444cccccccc7777777777777777cccccccccccccccc0000000000000000
0000000000000000000000000000000000000000ccccccccccaaaacc3344434444444444ccccccccd7777777777777ddcccccccccccccccc0000000000000000
0070070000444400004444000044440000444400cccccccccaaaaaac3444443444444444ccccccccddddd777777ddddccccccccccccccccc0000000000000000
0007700008888880088888800888888008888880cccccccccaaaaaac3444943444449444ccccccccccccddddddddcccccccccccccccccccc0000000000000000
0007700005444450054444500544445005444450cccccccccaaaaaac3444444444444444cc33bb3bcccccccccccccccc33333ccccccccccc0000000000000000
0070070004544540544455400545554004544540cccccccccaaaaaac4944444449444444c3bbb3bbccccccccccccccccbbbb333ccccccccc0000000000000000
00000000044994409955444009944440044aa440ccccccccccaaaacc44449444444494443bbbbbbbccccccccccccccccbbbbbb33cccccccc0000000000000000
00000000044994409944444009944440044aa440cccccccccccccccc4444449444444494bbbbb3bbccccccccccccccccbb3bbbbb33cccccc0000000000000000
00000000000000000000000000000000111111111111111111133bbbbbbbbbbbbbbbbbb13331111111111111bbb88bbb11111111000000000000000000000000
000000000000000000000000000000001111111111111111113bbb3bbbbbbbb33b333b3bbb33311111111111bb388b3b11111111000000000000000000000000
000000000055550000dddd000055555011111113111111133bbbbb3b33bbb3bbbbbbbbb3bbbbb33111111113bbb88bb311111113000000000000000000000000
00000000077777700aaaaaa0055555551111133b1111133bbbbbbbbbbbbb3bbbb33bbbbbbbbbbbb31111133bb3388bbb1111133b000000000000000000000000
00000000055555500dddddd00525529533388bbb33333bbbbbb33bbbb33bbbbbbbbbbbbbbbb3bbbb33388bbbbbb88bbb33333bbb000000000000000000000000
00000000055555500edddde005992295bbb88b3bbbbbbb3bb3bbbbbbbbbb3bbbbbb33bbbbb3bbb3bbbb88b3bbbb88bbbbbbbbb3b000000000000000000000000
00000000055555500dddddd005229266bb388b3bbb33bb3bb3bbbbbbbbbbbb3bb3bbbb3bbbbbbbbbbb388b3bb3b88b3bbb33bb3b000000000000000000000000
00000000055555500dddddd005555966bbb88bbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbb3b3bbbb3bbbb88bbb3bb88bb3bbbbbbbb000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000a666666a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000444444440000000a6aaaaaa6a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008888888888000000a44aaaa44a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000444444444400000a4444444444a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004e444444e40000004e444444e4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00017744447710000004477777744000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011775577110000007777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011175571110000007777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011111111110000077777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011111111110000777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000044400000444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000005cc7500057cc500000000000060000000600000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000005aaa50005aaa500000000000006600088066000000000000775770007757700000000000000000000000000000000000000000000000000
000000000000000005aaa50005aaa5000000000009877768a9877768000000007775777077757770000000000000000000000000000000000000000000000000
000000000000000005aaa50005aaa500000000000a977768aa977768000000007775767076757770000000000000000000000000000000000000000000000000
000000000000000005aaa50005aaa5000000000009866000a9866000000000000775670007657700000000000000000000000000000000000000000000000000
00000000000000000055500000555000000000000060000088600000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd

__gff__
0000000000000000000000000000000000000000010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0a0b0505050a0b050505050a0b05050600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050505090c0d0505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
151c16171719151c1516191c151c1c1400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1717171717171717171717171717171b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1717171717171717171717171717171b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1717171717171717171717171717171b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
