pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- astro ★
god_mode=false
function _init()
	stop_time=false
	stop_timer=0
	cls()
	mode="start"
	t=0
	score=0
	wavetime=80
	shake=0
	--screen limits
	min_x=11
	max_x=127 - 8 - min_x
	min_y=0
	max_y=127 - 8 - min_y
	
	music(10, 1000)
	
	ship:init()
	enemies_init()
	en_bullets_init()
	waves_init()
	bullets_init()
	particles_init()
	combo_init()
	energies_init()
	create_starfield()
end

function _update()
	if t>=29999
	then t=0
	else t+=1	end
	
	if mode=="game" then
 	update_game()
 elseif mode=="wave" then
 	update_wave()
	elseif mode=="start" then
 	update_start()
 elseif mode=="over" then
 	update_over()
 elseif mode=="win" then
 	update_win()
 end
end

function _draw()
	doshake()

	if mode=="game" then
	 draw_game()
	elseif mode=="wave" then
	 draw_wave()
	elseif mode=="start" then
	 draw_start()
 elseif mode=="over" then
	 draw_over()
 elseif mode=="win" then
	 draw_win()
 end
end

function switch_mode(new_mode)
	released=false
	if new_mode=="game" then
		mode="game"
	elseif new_mode=="wave" then
		if wave==1 then
			music(-1, 1000)
	 	music_on=false
			t=0
		end
		mode="wave"
		wavetime=80
	elseif new_mode=="start" then
		mode="start"
		_init()
	elseif new_mode=="win" then
		mode="win"
		music_on=false
 elseif new_mode=="over" then
		mode="over"
		music_on=false
		music(9)
 end
end

-->8
--update
function update_game()
	if music_on==false and t>30 then
		music(0)
		music_on=true
	end
	
--	if (btnp(❎)) then
--		stop_time = not stop_time
--	end

	if stop_timer > 0 then
		stop_timer-=1
		return
	end
	
	if stop_time then
		return
	end
	
	if ship.lives<=0 then
		switch_mode("over")
	end
 
 h_map_movement = 0
 if (btn(⬅️)) then
		h_map_movement=
			h_spd_multiplier(⬅️)
 elseif (btn(➡️)) then
		h_map_movement=
			h_spd_multiplier(➡️)
 end
 
 v_map_movement = 0
 if (btn(⬆️)) then
 	 v_map_movement=
 	 	v_spd_multiplier(⬆️)
 elseif (btn(⬇️)) then
 	 v_map_movement=
 	 	v_spd_multiplier(⬇️)
 end
 
 ship:update()
 
 enemies_update(
 	h_map_movement,
 	v_map_movement)
 	
 en_bullets_update(
	 h_map_movement,
 	v_map_movement)
 	
 waves_update()
 
 bullets_update(
 	h_map_movement,
 	v_map_movement)
 	
 energies_update(
 	h_map_movement,
 	v_map_movement)
 	
 combo_update()
 	
 particles_update(
 	h_map_movement,
 	v_map_movement)
	
	update_starfield(
		h_map_movement,
		v_map_movement)
end

function update_wave()
	wavetime-=1
	if wavetime<=0 then
		switch_mode("game")
	end
	update_game()
end

function update_start()
	check_released()
	if released==true
	and (btnp(🅾️) or btnp(❎))
	then
		next_wave()
	end
end

function update_over()
	check_released()
	if released==true
	and (btnp(🅾️) or btnp(❎))
	then
		switch_mode("start")
	end
end

function update_win()
	check_released()
	if released==true
	and (btnp(🅾️) or btnp(❎))
	then
		switch_mode("start")
	end
end

function check_released()
	if not btn(🅾️)
	and not btn(❎)
	then
		released=true
	end
end

function has_collision(a,b)
	local a_left = a.x
	local a_top = a.y
	local a_right = a.x+7
	local a_bottom = a.y+7
	
	local b_left = b.x
	local b_top = b.y
	local b_right = b.x+7
	local b_bottom = b.y+7
	
	if a_top>b_bottom then return false end
	if b_top>a_bottom then return false end
	if a_left>b_right then return false end
	if b_left>a_right then return false end
	
	return true
end
-->8
--draw
function draw_game()
	cls()
 draw_starfield()
 enemies_draw()
 bullets_draw()
	ship:draw()
	particles_draw()
	energies_draw()
	en_bullets_draw()
	draw_ui()
end

function draw_wave()
	draw_game()
	
	print("wave "..wave,56,31,blink_text())
end

function draw_start()
	cls(1)
	
	print("★ astro ★",46,31,2)
	print("★ astro ★",45,30,12,2)
	
	blink("press 🅾️ / ❎",40,80,7,2)
end

function draw_over()
	cls(2)
	
	blink("game over",45,30,13,1)
	
	blink("press 🅾️ / ❎",40,80,7,5)
end

function draw_win()
	cls(3)
	
	print("★ you win ★",45,30,blink_text())
	
	print("score: "..score,45,50,blink_text())
	
	blink("press 🅾️ / ❎",40,80,7,5)
end

function blink(val,x,y,col,back_col)
	if flr(t)%30<15 then
			print(val,x,y,back_col)
			print(val,x-1,y-1,col)
	else
			print(val,x,y,col)
	end
end

function blink_text()
	if flr(t)%30<15 then
		return 7
	else
		return 5
	end
end

function doshake()
	local shakex=rnd(shake)
	local shakey=rnd(shake)
	
	camera(shakex,shakey)
	
	if shake>10 then
		shake*=0.9
	else
		shake-=1
		if shake<1 then
			shake=0
		end
	end
end
-->8
--starfield

function create_starfield()
	star_count=100

	starx={}
	stary={}
	starspd={}

	for i=0,star_count do
		starx[i]=flr(rnd(128))
		stary[i]=flr(rnd(128))
		starspd[i]=rnd(2.5)+0.5
		if starspd[i]>2 then
			starspd[i]=starspd[i]-1
		end
	end
end

function update_starfield(
				h_map_movement,
				v_map_movement)
	x_dir = h_map_movement
--	v_map_movement
	y_dir = v_map_movement
--	if btn(⬆️) then
--		y_dir = 1.5
--	elseif btn(⬇️) then
--	 y_dir = 0.5
--	end
	
	for i=0,star_count do
		local sy=stary[i]
		sy+=starspd[i] + y_dir
		if sy > 127 then
			starx[i]=flr(rnd(127))
			sy-=127
		elseif sy < 0 then
			starx[i]=flr(rnd(127))
			sy+=127
		end
		stary[i]=sy
	
		local sx=starx[i]
		sx+=x_dir
		if sx>127 then
			stary[i]=flr(rnd(127))
			sx-=127
		elseif sx<0 then
			stary[i]=flr(rnd(128))
			sx+=127		
		end
		starx[i]=sx
	end
end

function draw_starfield()
	for i=0,star_count do
		local star_color = 6
		local star_speed = starspd[i]
		
		if star_speed<1 then
			star_color=1
		elseif star_speed<1.5 then
			star_color=13
		else
			pset(starx[i], stary[i]-1, 13)
			pset(starx[i], stary[i]-2, 1)
		end
		
		pset(starx[i], stary[i], star_color)
	end
end

-->8
--speed multiplier

function h_spd_multiplier(_h_dir)
	return 0
--	if _h_dir==⬅️ then
--		if ship.x<=min_x then
--			return ship.h_vel
--		else
--			return 0
--		end
--	elseif _h_dir==➡️ then
--		if ship.x>=max_x then
--			return ship.h_vel*-1
--		else
--			return 0
--		end
--	end
end

function v_spd_multiplier(_v_dir)
	return 0
--	if _v_dir==⬆️ then
--		if ship.y<=min_y then
--			return ship.v_vel
--		else
--			return 0
--		end
--	elseif _v_dir==⬇️ then
--		if ship.y>=max_y then
--			return ship.v_vel*-1
--		else
--			return 0
--		end
--	end
end
-->8
--ship

muzzle=0
muzzle_size=3
default_iframes=40

ship={
	x=64,
	y=64,
	h_vel=3,
	v_vel=2,
	hull={
		sp=1
	},
	weapon={
		sp=5,
		cooldown=30,
		bullet_type=1
	},
	trail={
		sp=7,
		size={2,3,4}
		--trail sizes
		--{ idle, regular, max }
		--0=off / 4=max
	},
	--sprites
	sp={
		--flip x
		flpx=false,
		hull=1,
		weapon=5,
		trail=7
	},
	--weapon
	w_cooldown=0,
	--trail
	t_offset=1,
	
	liues=10,
	max_lives=10,
	iframes=0
}

function ship:init()
	self.lives=self.max_lives
	self.x=64
	self.y=64
	self.iframes=0
end

function ship:update()
	--reset sprites
	self.sp.hull=self.hull.sp
	self.sp.weapon=self.weapon.sp
	self.sp.flpx=false
	
	if self.iframes>0 then
		self.iframes-=1
	end
	
	--movement
	if btn(⬅️) then
		self:movex(⬅️)
	elseif btn(➡️) then
	 self:movex(➡️)
	end
	
	if btn(⬆️) then
		self:movey(⬆️)
		self.t_offset=
			self.trail.size[3]+2
	elseif btn(⬇️) then
		self:movey(⬇️)
		self.t_offset=
			self.trail.size[1]+2
	else
		self.t_offset=
			self.trail.size[2]+2
	end
	
	if btn(🅾️) 
	and self.w_cooldown<=0
	then self:shoot()
	end
	
	if god_mode and btn(❎) then
		for en in all(enemies) do
			en:take_hit()
		end
	end
	
	if self.w_cooldown > 0 then
		self.w_cooldown-=1
	end
	
	if muzzle>0 then
		muzzle-=1
	end
end

function ship:draw()
	if self.iframes>0
	and sin(t/5)<0.1
	then
		return
	end
	
	draw_trail(
		self.sp.trail,
		self.x,
		self.y+self.t_offset)
		
	--recoil
 local recoil=
 	flr(
 		self.weapon.cooldown
 		/self.w_cooldown
 	)<=2 and 1 or 0
 
	draw_weapon(
	  self.sp.weapon,
	  self.x,
	  self.y+recoil,
	  self.sp.flpx)
	if self.flash_t
	and self.flash_t > 0
	then
		self.flash_t-=1
		local col=self.flash_c or 7
		for i=1,15 do
			pal(i,col)
		end
	end
	
	if self.iframes>0 then
		pal(12,8)
	end
	spr(
		self.sp.hull,
		self.x,ship.y,
		1,1,
		self.sp.flpx)
	pal()
end

function ship:movex(dir)
	if dir==⬅️ then
		self.x-=self.h_vel
		if self.x <= min_x then
			self.x = min_x
		end
		self.sp.hull=
			self.hull.sp+1
		self.sp.weapon=
			self.weapon.sp+1
		self.sp.flpx=true
	elseif dir==➡️ then
	 self.x+=self.h_vel
	 if self.x >= max_x then
			self.x = max_x
		end
	 self.sp.hull=
			self.hull.sp+1
		self.sp.weapon=
			self.weapon.sp+1
		self.sp.flpx=false
	end
end

function ship:movey(dir)
	if dir==⬆️ then
		self.y-=self.v_vel
		if self.y <= min_y then
			self.y = min_y
		end
	elseif dir==⬇️ then
	 self.y+=self.v_vel
	 if self.y >= max_y then
			self.y = max_y
		end
	end
end

function ship:shoot()
	bullet:new(
		self.x,
		self.y-4,
		self.weapon.bullet_type
	)
	
--	self.w_cooldown=
--		self.weapon.cooldown
	self.w_cooldown=
		self.weapon.cooldown

	
	muzzle=muzzle_size
end

function ship:take_hit()
	if self.iframes<=0
	and not god_mode then
		stop_timer=15
		self.lives-=1
		self.iframes=default_iframes
		sfx(1)
--		explode(
--			self.x+4,
--			self.y+4,
--			true)
		shake=combo_level*3
		combo_reset()
	end

	if self.lives<=0 then
		shake=32
		stop_timer=60
	end
end

function draw_weapon(sp,x,y,flpx)
	--muzzle
	if muzzle>0 then
		circfill(x+3,y-1,muzzle,7)
		circfill(x+4,y-1,muzzle,7)
	end
 --weapon
	spr(
		sp,
		x,y-4,
		1,1,
		flpx)
end

--trail_anim={
--	frames={
--		{sp=sp},
--		{sp=sp,flpx=true}
--	},
--	fr_t=4
--}

function draw_trail(sp,x,y)
	spr(sp,x,y,1,1,flr(t/4)%2==0)
end


-->8
--weapons
weapons={
-- form 1 (starter weapon)
	[1]={sp=5, cooldown=20, bullet_type=1},
	[2]={sp=5, cooldown=16, bullet_type=1},
	[3]={sp=5, cooldown=12, bullet_type=1},

	-- form 2 (first transformation)
	[4]={sp=21, cooldown=10, bullet_type=2},
	[5]={sp=21, cooldown=8,  bullet_type=2},
	[6]={sp=21, cooldown=7,  bullet_type=2},

	-- form 3 (strong / aggressive)
	[7]={sp=37, cooldown=6, bullet_type=3},
	[8]={sp=37, cooldown=5, bullet_type=3},
	[9]={sp=37, cooldown=5, bullet_type=3},

	-- form 4 (peak power)
	[10]={sp=53, cooldown=4, bullet_type=4},
	[11]={sp=53, cooldown=3, bullet_type=4},
	[12]={sp=53, cooldown=2, bullet_type=4},
--	[1]={
--		sp=5,
--		cooldown=20,
--		bullet_type=1
--	},
--	[2]={
--		sp=5,
--		cooldown=7,
--		bullet_type=1
--	},
--	[3]={
--		sp=5,
--		cooldown=5,
--		bullet_type=2
--	},
--	[4]={
--		sp=21,
--		cooldown=5,
--		bullet_type=3
--	},
--	[5]={
--		sp=37,
--		cooldown=5,
--		bullet_type=4
--	},
}
	
-->8
--bullets

bullet_types={
	[1]={sp=3,v_vel=2,sound=24},
	[2]={sp=19,v_vel=3,sound=25},
	[3]={sp=35,v_vel=4,sound=26},
	[4]={sp=51,v_vel=4,sound=27},
}

bullet={
	x,y,
	v_vel=4,
	h_vel=0,
	sp
}

function bullet:new(x,y,b_type)
	local bt = bullet_types[b_type]
	local obj={
		x=x,y=y,
		v_vel=bt.v_vel,
		sp=bt.sp
	}
	sfx(bt.sound)
	obj=setmetatable(obj,{__index=self})
	add(bullets,obj)
	return obj
end

function bullet:update(h_map_mov,v_map_mov)
	if self.y < -8 then
		return false
	end
	self.y-=self.v_vel-v_map_mov
	self.x+=h_map_mov
	return true
end

function bullet:draw()
	local anim_frame=flr(t/8)%2
	
--	draw_trail(7,self.x,self.y+4)
	spr(
		self.sp+1,
		self.x,self.y,
		1,1,
		anim_frame==0)
	spr(
		self.sp,
		self.x,self.y,
		1,1,
		anim_frame==0)
end

function bullet:take_hit()
	sfx(3)
	del(bullets, self)
	sparks(
		self.x+4,
		self.y+4,
		self.h_vel*2,
		self.v_vel*-3
	)
end

function bullets_init()
	bullets={}
end

function bullets_update(
		h_map_mov,
 	v_map_mov
 )

	for b in all(bullets) do
		if not
			b:update(h_map_mov,v_map_mov)
		then
			del(bullets, b)
		end
	end
end

function bullets_draw()
	for b in all(bullets) do
		b:draw()
	end
end
-->8
--enemies

enemy={
	x=-8,
	y=-30,
	target={x=64,y=20},
	hp=5,
	sp_default=8,
	sp=8,
	flpx=false,
	flash=0,
	t=0,
	is_atk=false,
	bullet_type=1,
	energy=1
}

en_types={
	[1]={
		sp=8,
		hp=3,--3,
		bullet_type=1,
		energy=3,
		atk=function(self)
			self.y+=2
			self.x+=sin(t/16)*3
			if ship.x > self.x then
				self.x+=0.5
			else
				self.x-=0.5
			end
		end
	},
	[2]={
		sp=24,
		hp=4,--5,
		bullet_type=1,
		energy=5,
		upd=function(self)
			if self.y<0 then
				self.x_atk=nil
			end
		end,
		atk=function(self)
			if self.x_atk then
				self.x=self.x_atk+self.x
				return
			end
			
			if self.y < ship.y then
				self.y+=1
			elseif self.x > ship.x then
				self.x_atk=-2
			else
				self.x_atk=2
			end
		end
	},
	[3]={
		sp=40,
		hp=10,--3,
		bullet_type=1,
		energy=10,
		atk=function(self)
		 self.atk_target_x =
		 	self.atk_target_x or self.x
		 self.atk_target_y =
		 	self.atk_target_y or self.y
			self.atk_t=self.atk_t or 10
			if self.y>ship.y then
				self.y+=1
				self.atk_target_y=
					self.target.y
				return
			end
			
			if self.atk_t >0 then
				self.atk_t-=1
			else
				self.atk_target_y=self.y+15
				self.atk_t=15+rnd(30)
			end
			self.atk_target_x=ship.x
--			self.y+=1
--			self.x+=sin(t/8)*8
			local diff=self.atk_target_x-self.x
			self.x+=diff/10
		
			local diff=self.atk_target_y-self.y
			self.y+=diff/20
		end
	},
	[4]={
		sp=56,
		hp=7,--3,
		bullet_type=1,
		atk=function(self)
			self.y+=1
			self.x+=sin(t/16)
			if ship.x > self.x then
				self.x+=0.3
			else
				self.x-=0.3
			end
		end
	},
	[5]={
		sp=72,
		hp=3,--3,
		bullet_type=1,
		atk=function(self)
			self.y+=1+sin((t/8)+1)*4
			self.x+=sin(t/16)*4
			if ship.x > self.x then
				self.x+=0.5
			else
				self.x-=0.5
			end
		end
	},
}

en_flash_time=2

function enemy:new(
		x, y, en_id, t,
		upd)

	local en_t=en_types[en_id]
	local obj={
		x=x,
		target={x=x,y=y},
		hp=en_t.hp,
		sp=en_t.sp,
		sp_default=en_t.sp,
		flpx=en_t or rnd(1)<0.5,
		t=t or 0,
		bullet_type=en_t.bullet_type or self.bullet_type,
		energy=en_t.energy or self.energy,
		upd=upd or en_t.upd or self.upd,
		atk=en_t.atk or self.atk
	}
	obj=setmetatable(obj,{__index=self})
	add(enemies,obj)
	return obj
end

function enemy:upd(self)
end

function enemy:atk(self)
	self.y+=1.5
end

function enemy:spawn_energy(self)
	energies_spawn(
		self.x+4,
		self.y+4,
		self.energy)
end

function enemy:shoot(self,ang)
	self.flash=en_flash_time+3
	en_bullet:new(
		self.x,
		self.y+4,
		sin(ang),
		cos(ang),
		self.bullet_type
	)
--	self.w_cooldown=
--		self.weapon.cooldown
--	muzzle=muzzle_size
end

function enemy:spreadshoot(self,num,ang)
	ang=ang or 0
	for i=1,num do
		self:shoot(self,ang)
		ang+=1/num
	end
end

function enemy:spinningshoot(
		self,
		shots,
		num)
	self.spinning_shots=shots
	self.spinning_num=num
end

function enemy:aimshoot(self)
	local x1=self.x
	local y1=self.y
	local x2=ship.x
	local y2=ship.y
	local ang=atan2(y2-y1,x2-x1)
	self:shoot(self,ang)
end

function enemy:update(h_map_mov,v_map_mov)
	if self.t>0 then
		self.t-=1
		return true
	end
	
	if self.is_atk then
		self:atk(self)
	else
		if self.x<self.target.x then
			local diff=self.target.x-self.x
			self.x+=max(0.5,diff/5)
		end
		
		if self.x>self.target.x then
			local diff=self.target.x-self.x
			self.x+=min(-0.5,diff/5)
		end
	
		if self.y<self.target.y then
			local diff=self.target.y-self.y
			self.y+=max(0.5,diff/5)
		end
	end
	
	self:upd(self)
	self.sp+=0.2
	if self.sp>=self.sp_default+4 then
		self.sp=self.sp_default
	end
	
	for bullet in all(bullets) do
		if has_collision(self,bullet) then
			bullet:take_hit()
			self:take_hit()
		end
	end
	
	if t%5==0
	and self.spinning_shots
	and self.spinning_shots>0
	then
		self.spinning_shots-=1
		local num = self.spinning_num or 4
		for i=1,num do
			enemy:spreadshoot(self,num,time()/4)
		end
	end
	
	if has_collision(self,ship) then
		ship:take_hit()
	end
	
	if self.y>130 
	or self.x>140
	or self.x<-16
	then
		self.is_atk = false
		self.y=-10
	end
	
--	if self.y>140
--	if self.x>140
--	or self.x<-16
--	then
--		del(enemies, self)
--	end
	return true
end

function enemy:draw()
--	if flr(t/15)%2==0 then
--		pal(8,10)
--	else
	if self.is_atk then
		pal(12,8)
	end
	
	if self.flash>=0 then
		self.flash-=1
		for i=1,15 do
			pal(i,7)
		end
	end
	spr(
		self.sp,
		self.x,
		self.y,
		1,1,
		self.flpx
	)
	pal()
end

function enemy:take_hit()
	self.hp-=1
	self.flash=en_flash_time
	if self.hp<=0 then
		sfx(2)
		shake=combo_level
		del(enemies, self)
		score+=1
		enemy:spawn_energy(self)
		explode(
			self.x+4,
			self.y+4)
		if not self.is_atk then
			trigger_attack()
		end
	end
end

function trigger_attack()
	if #enemies>0 then
		local en=enemies[flr(rnd(#enemies))+1]
		if not en.is_atk then
			en.is_atk=true
			return true
		end
	end
	return false
end

function trigger_shoot()
	if #enemies>0 then
		local en=enemies[flr(rnd(#enemies))+1]
		if not en.is_atk then
--			en:shoot(en,0)
--			en:spreadshoot(en,8,rnd())
--			en:spinningshoot(en,5,8)
			en:aimshoot(en)
			return true
		end
	end
	return false
end

function enemies_init()
	enemies={}
end

function enemies_update(
		h_map_mov,
 	v_map_mov
 )

	for e in all(enemies) do
		if not
			e:update(h_map_mov,v_map_mov)
		then
			del(enemies, e)
		end
	end
	
	if #enemies<=0 then
		next_wave()
	end
end

function enemies_draw()
	for e in all(enemies) do
		e:draw()
	end
end
-->8
--enemy bullets

en_bullet_types={
	[1]={sp=64,spd=2,sound=0}
}

en_bullet={
	x,y,
	v_vel=2,
	h_vel=0,
	sp
}

function en_bullet:new(
		x,y,
		h_vel,v_vel,
		b_type)
	local bt = en_bullet_types[b_type]
	local obj={
		x=x,y=y,
		h_vel=h_vel*bt.spd,
		v_vel=v_vel*bt.spd,
		sp=bt.sp
	}
	sfx(bt.sound)
	obj=setmetatable(obj,{__index=self})
	add(en_bullets,obj)
	return obj
end

function en_bullet:update(h_map_mov,v_map_mov)
	if has_collision(self,ship) then
		ship:take_hit()
		self:take_hit()
		return false
	end
	if self.y > 136 then
		return false
	end
	self.y+=self.v_vel-v_map_mov
	self.x+=self.h_vel+h_map_mov
	return true
end

function en_bullet:draw()
	local anim_frame=flr(t/3)%4
	if anim_frame == 3 then
		anim_frame = 1
	end
	
	--draw_trail(7,self.x,self.y+4)
	spr(
		self.sp+anim_frame,
		self.x,
		self.y)
end

function en_bullet:take_hit()
	sfx(3)
	del(en_bullets, self)
	sparks(
		self.x+4,
		self.y+4,
		self.h_vel*4,
		self.v_vel*4,
		20, 14
	)
end

function en_bullets_init()
	en_bullets={}
end

function en_bullets_update(
		h_map_mov,
 	v_map_mov
 )

	for b in all(en_bullets) do
		if not
			b:update(h_map_mov,v_map_mov)
		then
			del(en_bullets, b)
		end
	end
end

function en_bullets_draw()
	for b in all(en_bullets) do
		b:draw()
	end
end
-->8
--stages

en_waves={
	-- 1: simple intro (breathing room)
	[1]={
		{1,1,0,0,0,0,1,1},
		{0,1,1,0,0,1,1,0},
	},
	
	-- 2: basic density
	[2]={
		{1,1,1,1,1,1,1,1},
		{0,1,1,1,1,1,1,0},
		{0,0,1,0,0,1,0,0},
	},
	
	-- 3: introduce discs (edges pressure)
	[3]={
		{2,0,0,0,0,0,0,2},
		{1,1,1,1,1,1,1,1},
		{0,1,0,0,0,0,1,0},
	},
	
	-- 4: discs + swarm
	[4]={
		{2,2,0,0,0,0,2,2},
		{1,1,1,1,1,1,1,1},
		{1,0,1,0,0,1,0,1},
	},
	
	-- 5: first tank introduction (protected center)
	[5]={
		{1,1,1,1,1,1,1,1},
		{0,1,1,3,3,1,1,0},
		{0,0,1,0,0,1,0,0},
	},
	
	-- 6: tanks + discs interaction
	[6]={
		{2,0,1,0,0,1,0,2},
		{1,1,1,1,1,1,1,1},
		{0,1,3,0,0,3,1,0},
		{0,0,1,0,0,1,0,0},
	},
	
	-- 7: wall + flankers
	[7]={
		{2,2,2,0,0,2,2,2},
		{1,1,1,1,1,1,1,1},
		{3,3,3,0,0,3,3,3},
		{0,1,0,0,0,0,1,0},
	},
	
	-- 8: heavy pressure (mixed roles)
	[8]={
		{2,1,2,1,1,2,1,2},
		{1,1,1,1,1,1,1,1},
		{1,3,1,0,0,1,3,1},
		{3,1,3,0,0,3,1,3},
	},
	
	-- 9: tank formation (forces repositioning)
	[9]={
		{0,3,0,3,3,0,3,0},
		{1,1,1,1,1,1,1,1},
		{2,0,2,0,0,2,0,2},
		{1,1,0,0,0,0,1,1},
	},
	
	-- 10: chaos wave (test everything)
	[10]={
		{2,2,2,1,1,2,2,2},
		{1,1,1,3,3,1,1,1},
		{3,1,3,1,1,3,1,3},
		{1,3,1,0,0,1,3,1},
		{3,3,3,3,3,3,3,3},
	},

--	[1]={
--		{1,1,1,1,1,1,1,1},
--		{1,1,1,0,0,1,1,1},
--		{0,1,0,0,0,0,1,0}
--	},
--	[2]={
--		{1,1,1,1,1,1,1,1},
--		{1,1,1,1,1,1,1,1},
--		{1,1,1,0,0,1,1,1},
--		{0,1,0,0,0,0,1,0}
--	},
--	[3]={
--		{2,2,2,0,0,2,2,2},
--		{1,1,1,1,1,1,1,1},
--		{0,1,1,1,1,1,1,0},
--		{0,0,1,0,0,1,0,0}
--	},
--	[4]={
--		{2,2,2,1,1,2,2,2},
--		{1,1,1,1,1,1,1,1},
--		{1,1,1,3,3,1,1,1},
--		{3,1,3,0,0,3,1,3},
--		{0,3,0,0,0,0,3,0},
--	},
--	[5]={
--		{2,1,1,2,2,1,1,2},
--		{2,1,1,2,2,1,1,2},
--		{1,1,1,3,3,1,1,1},
--		{3,1,1,1,1,1,1,3},
--		{3,3,3,3,3,3,3,3},
--	},
}

t_atk=0
t_sht=0

function waves_init()
	wave=0
end

function waves_update()
	if t_atk>0 then
		t_atk-=1
	elseif trigger_attack() then
		t_atk=100+flr(rnd(40))
	end
	if t_sht>0 then
		t_sht-=1
	elseif trigger_shoot() then
		t_sht=15+flr(rnd(30))
	end
end

function next_wave()
	wave+=1
	t_sht=150
	t_atk=270
	
	
	if wave>#en_waves then
		switch_mode("win")
	else
		switch_mode("wave")
	end
	
	local curr_wave=en_waves[wave]
	local y=8+4
	local en_t=60
	for line in all(curr_wave) do
		local x=16
		for en_id in all(line) do
			if en_id>0 then
				enemy:new(x,y,en_id,en_t)
				en_t+=1
			end
			x+=12
		end
		y+=12
	end	
end

-->8
--particles
particle={
	x,y,
	age=0,
	maxage=10,
	size=1,
	h_vel=1,
	v_vel=1,
	constant=false,
	colrs
}

function explode(x,y,constant)
	constant=constant or false
	particle:new({
			x=x,y=y,
			age=0,
			maxage=0,
			size=8,
			h_vel=0,
			v_vel=0,
			colrs={7},
			constant=constant,
			draw=function(p)
				circ(p.x,p.y,12-p.size,7
			)
			end
		}
	)
	for i=1,15 do
		particle:new({
				x=x,y=y,
				age=0,
				maxage=10+rnd(10),
				size=1+rnd(3),
				h_vel=(rnd()-0.5)*12,
				v_vel=(rnd()-0.5)*12,
				colrs={7,10,9,8,2,5},
				constant=constant,
				draw=function (p)
					local col
					for i=1,#p.colrs do
						if p.age >= (i-1)*2.5 then
							col=p.colrs[i]
						end
					end
					circfill(
						p.x,
						p.y,
						p.size,
						col
					)
				end
			}
		)
	end
	particle:new({
			x=x,y=y,
			age=0,
			maxage=0,
			size=8,
			h_vel=0,
			v_vel=0,
			colrs={7},
			constant=constant,
			draw=function(p)
				circfill(p.x,p.y,p.size,7
			)
			end
		}
	)
end

function sparks(
		x,y,
		h_vel,v_vel,
		qtd, col
	)
	qtd = qtd or 5
	for i=1,qtd do
		particle:new({
				x=x,y=y,
				age=0,
				maxage=2+rnd(16),
				size=1,
				h_vel=h_vel+(rnd()-0.5)*5,
				v_vel=v_vel+(rnd())*-6,
				draw=function(p)
					local colr = col or 10
					if p.age>p.maxage/2 then
						colr=5
					end
					pset(p.x,p.y,colr)
				end
			}
		)
	end
end

function energy_lost(x,y,qtd,size)
	size=size or 6
	particle:new({
			x=x,y=y,
			age=0,
			maxage=0,
			size=size,
			h_vel=0,
			v_vel=0,
			constant=true,
			colrs={12},
			draw=function(p)
				circ(p.x,p.y,size+4-p.size,12)
			end
		}
	)
	sparks(
		x,y,
		10,0,qtd,12
	)
	sparks(
		x,y,
		-10,0,qtd,12
	)
--	local ang=0
--	local step=1/qtd
--	for i=1,qtd do
--		local hv=
--		local vv=
--		sparks(
--			x,y,
--			0,0,
--			1, 12
--		)
--	end
	particle:new({
			x=x,y=y,
			age=0,
			maxage=0,
			size=size,
			h_vel=0,
			v_vel=0,
			constant=true,
			colrs={7},
			draw=function(p)
				circfill(p.x,p.y,p.size,7
			)
			end
		}
	)
end

function particle:new(obj)
	obj=setmetatable(obj,{__index=self})
	add(particles,obj)
	return obj
end

function particle:update(h_map_mov,v_map_mov)
	self.h_vel=self.h_vel*0.7
	self.v_vel=self.v_vel*0.7
	self.x+=self.h_vel+h_map_mov
	self.y+=self.v_vel+v_map_mov+1
	self.age+=1
	if self.age>=self.maxage then
		self.size-=1
		if self.size<=0 then
			return false
		end
	end
	return true
end

function particle:draw()
	
end

function particles_init()
	particles={}
end

function particles_update(
		h_map_mov,
 	v_map_mov
 )

	for e in all(particles) do
		if e.constant then
			return
		end
		if not
			e:update(h_map_mov,v_map_mov)
		then
			del(particles, e)
		end
	end
end

function particles_draw()
	for e in all(particles) do
		if e.constant then
			if not
				e:update(0,0)
			then
				del(particles, e)
			end
		end
		e:draw()
	end
end

-->8
--combo
c_levels={
	5,5,5,
	20,20,20,
	30,30,30,
	40,40,40
}

function combo_init()
	combo=0
	combo_level=1
	update_ship_weapon()
end

function combo_update()
end

function combo_reset()
	local qt=ceil(
		(((combo_level-1)*10)+combo)/2
	)
	local x=ship.x+4
	local y=ship.y-4
	energy_lost(x,y,qt,combo_level)
	combo=0
	combo_level=1
	update_ship_weapon()
end

function combo_up(p)
	p = p or 0
	combo+=p
	if combo>=c_levels[combo_level] then
		combo_level_up()
	end
end

function combo_level_up()
	if combo_level>=#weapons then
--		combo=10
		return
	end
	
	stop_timer=30
	sfx(16)
	combo-=c_levels[combo_level]
	combo_level+=1
	update_ship_weapon()
end

function update_ship_weapon()
	ship.weapon=weapons[combo_level]
end

-->8
--energy
energy={
	x,y,
	age=0,
	maxage=10,
	size=1,
	h_vel=0,
	v_vel=0,
	points=1
}

function energy:new(obj)
	obj=setmetatable(obj,{__index=self})
	add(energies,obj)
	return obj
end

function energy:update(h_map_mov,v_map_mov)
	if has_collision(self,ship) then
--		self:take_hit()
		combo_up(self.points)
		ship.flash_t=3
		ship.flash_c=12
		sfx(17)
		return false
	end
	
	--magnet
	local dx=ship.x-self.x
 local dy=ship.y-self.y
 local d2=dx*dx+dy*dy
 local d_max=40
	local force=0.04
 if d2<(d_max*d_max) then
 	self.h_vel+=dx*force
		self.v_vel+=dy*force
 end

	self.x+=self.h_vel+h_map_mov
	self.y+=self.v_vel+v_map_mov
	self.h_vel=self.h_vel*0.9
	self.v_vel=self.v_vel*0.9
	self.age-=1
	if self.age<0 then
--		self.size-=1
--		if self.size<=0 then
		return false
--		end
	end
	return true
end

function energy:draw()
	self.size=flr(t/4)%3
	local colr = 12
--	if flr(rnd(4))%4==0 then
--		colr=7
--	end
	if self.age<30
	and flr(t/2)%2==0
	then
		colr=5
	end
	circfill(self.x,self.y,self.size,colr)	
end

function energies_init()
	energies={}
end

function energies_update(
		h_map_mov,
 	v_map_mov
 )

	for e in all(energies) do
		if not
			e:update(h_map_mov,v_map_mov)
		then
			del(energies, e)
		end
	end
end

function energies_draw()
	for e in all(energies) do
		e:draw()
	end
end


--energy={
--	x,y,
--	age=0,
--	maxage=10,
--	size=1,
--	h_vel=0,
--	v_vel=0,
--	colrs
--}
function energies_spawn(x,y,qtd)
	qtd = qtd or 1
	local step_ang=1/qtd
	for i=1,qtd do
		local ang=(i-1)*step_ang
		energy:new({
				x=x,y=y,
				age=90+rnd(30),
				size=1,
				h_vel=sin(ang)*2,
				v_vel=cos(ang)*2
			}
		)
	end
end

-->8
--ui

ui_life_sp=16
ui_margin=3

function draw_ui()
--	min_x=16
--	max_x=127 - 8 - min_x
--	min_y=0
--	max_y=127 - 8 - min_y
	draw_frame()
	draw_lives()
	draw_combo()
	draw_weapons()
	print("score: "..score,72, 3, 7)
	
	pal()
end

function draw_lives()
	for i=0,ship.max_lives-1 do
		if ship.lives>=i+1 then
			pal(1,8)
		else
			pal()
		end
		spr(
			ui_life_sp,
			2,
			i*8+ui_margin)
	end
	pal()
end

function draw_combo()							
	print(
		pad_number(combo_level,2),
		118,
		2,
		12
	)
	
	local bar={
		x=120,y=10,l=100,w=3
	}
	
	local fill=flr(
		combo*100/c_levels[combo_level]
	)
	
	rect_round(
		bar.x-1,
		bar.y-1,
		bar.x+bar.w+1,
		bar.y+bar.l+1,
		6
	)
	
	rectfill(
		bar.x,
		bar.y,
		bar.x+bar.w,
		bar.y+bar.l,
		1
	)
	
	rectfill(
		bar.x,
		bar.y+bar.l,
		bar.x+bar.w,
		bar.y+bar.l-fill,
		12
	)
--	pset(bar.x-1,
--						bar.y-1,5)
--	pset(bar.x+bar.w+1,
--						bar.y-1,5)
--	pset(bar.x-1,
--						bar.y+bar.l+1,5)
--	pset(bar.x+bar.w+1,
--						bar.y+bar.l+1,5)
	
--	line(
--		bar.x+1,
--		bar.y+2,
--		bar.x+1,
--		bar.y+bar.l-32,
--		7
--	)
end

function draw_weapons()
	local wp=ship.weapon
	local bt=bullet_types[
		wp.bullet_type
	]
	rect_round(1,116,10,126,11)
	rectfill(2,117,9,125,3)
	spr(
		wp.sp,
		2,115)
	rect_round(117,116,126,126,11)
	rectfill(118,117,125,125,3)
	spr(
		bt.sp,
		118,117)
end

function draw_frame()
	rect(
		0,0,
		127,127,
		6)
	pset(0,0,0)
	pset(0,127,0)
	pset(127,0,0)
	pset(127,127,0)
	
	rect_round(
		0,0,
		min_x,127,
		6)
	rectfill(
		1,1,
		min_x-1,127-1,
		5)
	rect_round(
		max_x+8,0,
		127,127,
		6)
	rectfill(
		max_x+8+1,0+1,
		127-1,127-1,
		5)
end

function rect_round(x1, y1, x2, y2, col)
  rectfill(x1+1, y1, x2-1, y2, col)
  rectfill(x1, y1+1, x2, y2-1, col)
end

function pad_number(val, len)
  local s = tostr(val)
  while #s < len do s = "0"..s end
  return s
end
-->8
-- animation

--function animate(animation,x,y)
--	local an_t=animation.t
--												or animation.fr_t
--												or 15
--	local curr_fr=
--		animation.curr_fr or 1
--		
--	if (an_t<=0) then
--		curr_fr+=1
--		if curr_fr>#animation.frames
--		then
--			curr_fr=1
--			an_t=
--				animation.frames[curr_fr].fr_t
--				or animation.fr_t
--				or 15
--		end
--	end
--	
--	animation.t = an_t-1
--	animation.curr_fr=curr_fr
--	
--	draw_curr_frame(
--		animation,x,y
--	)
--end

--function draw_curr_frame(an,x,y)
--	local frame=
--		an.frames[an.curr_fr]
--
--	spr(
--		frame.sp,
--		x,
--		y,
--		1,1,
--		frame.flpx or false
--	)
--end
__gfx__
0000000000000000000000000000000000000000000000000000000000089000000cc00000055000000000000000000000000000000000000000000000000000
0000000000077000000077000000000000000000000000000000000000099000000550000c5665c00c0550c000c00c0000000000000000000000000000000000
007007000076670000076600000aa0000000000000000000000000000009a0000056650000688600005665000005500000005500005500000000000000000000
00077000006cc6000056cc0000a7aa00000000000000000000000000000a00000c6886c000566500006886000056650000006650056600000000000000000000
0007700007c77c70056c776000aaaa00000000000006600000006000000000000056650000066000005665000068860000060067760060000000000000000000
0070070076c77c67076c7765000aa000000000000056650000056000000000000006600000c55c000c0660c00c5665c000650022220056000000000000000000
0000000005700750765706000000000000000000006666000000000000000000000550000000000000055000000660000665008e880056600000000000000000
0000000007000070007005000000000000000000000000000000000000000000000cc00000000000000000000005500000655528825556000000000000000000
0000000000000000000000000000000000000000000000000000000000000000006cc6000c6006c0006cc6000c6006c000000552255000000000000000000000
088008800007700000007700000000000000000000000000000000000000000006000060c600006c06000060c600006c00006655556600000000000000000000
811881180076670000076600000aa000000000000000000000000000000000006506605665066056650660566506605600007665566700000000000000000000
87111118006cc6000056cc0000acaa0000000000000000000000000000000000c066660c00686600c068860c0066860000007760067700000000000000000000
8171111807c77c70056c7760009ac90000000000000cc0000000c0000008b000c068860c00686600c066660c0066860000000700007000000000000000000000
0811118076c77c67076c7765000aa0000000000000c66c00000c6000000bc0006506605665066056650660566506605600000000000000000000000000000000
00811800057007507657060000090000000000000066660000000000000cd00006000060c600006c06000060c600006c00000000000000000000000000000000
0008800007000070007005000000000000000000000000000000000000dd0000006cc6000c6006c0006cc6000c6006c000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000890000000000000000000000000000000000000000000000000000000000000000000
00033000000bb0000000b00000000000000000000000000000000000000990000000000000055000000550000005500000000000000000000000000000000000
003bb3000039930000039000000aa0000000000000000000000000000009a00060055006c068860c606886060068860000000000000000000000000000000000
03baab30009799000039790000acca00000000000000000000000000000a00001068860150666605506666056066660600000000000000000000000000000000
03baab30039999300539990000acca0000000000cc0cc0cc0000cc00000000006566665665566556655665565056650500000000000000000000000000000000
003bb3000b3993b005b39300009aa9000000000000c66c0000cc600000000000665cc56666000066cc0000ccc500005c00000000000000000000000000000000
000330000bb33bb005bb3b000009000000000000006666000000000000000000066cc6600cc66cc0066666606600006600000000000000000000000000000000
00000000030000300030030000000000000000000000000000000000000000000000000000000000000000000666666000000000000cc000000cc00000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc00000cc7c0006cc7c60000cc000
000bb000000880000000bb0000000000000000000000000000000c00000000000000000000000000000000000000000000cc7c0006cc7c6062cc7c2606cc7c60
003aab00002aa200000b3300000770000000000000000000000001c0000000000070070000700700007007000070070006cc7c6068cccc86682cc28662cc7c26
0babbab000a7aa0000537c00007cc70000000000c00cc00c0000cc00000000000007700000077000000770000007700068cccc86688cc88606822860682cc286
0babbab002aaaa200b3cbb3000acca0000000000ccc22cccc1cc22000000000000077000000770000007700000077000688cc886068888600066660006822860
00baab00082aa280bb3cbb3500acca0000000000002662000c026000000000000070070000700700007007000070070006888860006666000002200000666600
000bb00008822880003b0300009aa900000000000066660000000000000000000000000000000000000000000000000000666600000220000000000000022000
000000000200002000b0050000089000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000088888800000000000000000000bbb88888bbb000000000000000000
000ee000000ee000000770000000000000000000000000000000000000000000000000008b2aa2b800000000000000000008bbb888bbb8000000000000000000
00e22e0000e88e00007cc700000000000000000000000000000000000000000008888880088aa880088888800000000000088888888888000000000000000000
0e2782e00e87e8e007c77c7000000000000000000000000000000000000000008b2aa2b8000880008b2aa2b80888888000082622222628000000000000000000
0e2882e00e8ee8e007c77c700000000000000000000000000000000000000000088aa88000093000088aa8808b2aa2b800022262226220000000000000000000
00e22e0000e88e00007cc7000000000000000000000000000000000000000000000880000003900000088000088aa88300002222222200000000000000000000
000ee000000ee0000007700000000000000000000000000000000000000000000009390900093009000939090008803900000222ee20000000bbb88888bbb000
0000000000000000000000000000000000000000000000000000000000000000000393930003939300039393000393930000088880ee0000008bbb888bbb8000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000993b00000000008888888880000
00033000000bb0000003300000000000000000000000000000000000000000000000000000000000000000000000000000000aa3300bb990000262222262b990
003bb30000b77b00003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000aa990bbbaa900002622e62bbaa9
03b77b300b7bb7b003b77b30000000000000000000000000000000000000000000000000000000000000000000000000000009b300000aa900000888e0000aa9
03b77b300b7bb7b003b77b300000000000000000000000000000000000000000000000000000000000000000000000000000993300000099000099330e000099
003bb30000b77b00003bb300000000000000000000000000000000000000000000000000000000000000000000000000000099aa9933aa99000099aa9933aa99
00033000000bb000000330000000000000000000000000000000000000000000000000000000000000000000000000000000a3b99ab3ab300000a3b99ab3ab30
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003309aa99330000003309aa99330
00000000000000000000000000000000000000000000000000000000000000000000120000021210001212000012120000000000000000000000000000000000
00099000000990000007700000000000000000000000000000000000000000000012212000212021002102120120012000000000000000000000000000000000
00944900009aa9000079970000000000000000000000000000000000000000000021000300100002021000010021000300000000000000000000000000000000
0949a49009a79a900797797000000000000000000000000000000000000000000001200000021003002120320001200000000000000000000000000000000000
094aa49009a99a900797797000000000000000000000000000000000000000000202102000200200008218000202102000000000000000000000000000000000
00944900009aa9000079970000000000000000000000000000000000000000000820028000822800282332820823328000000000000000000000000000000000
00099000000990000007700000000000000000000000000000000000000000000282282000288200023003200280082000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000021120002100120000000000000000000000000000000000000000000000000
__label__
06666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666660
655555555556000000000000000000000000000d0000000000000000000000600000000000000000000000000000000000000000000000000000655555555556
6555555555560000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065ccc5ccc556
65555555555600000000000000000000000000000000000000000000d0000000000000000000000007700771077077707770000000007770000065c5c555c556
655885588556000000000000000000000000000000000000000000000000000000000000000000007000700d707070707000070000007070000065c5c5ccc556
6588888888560000000000000000000000000000000000000000000000000000000000000000000077707006707077007700000000007770000065c5c5c55556
6587888888560000000000000000000000000000000000000d000000000000d0000000000000000000707000707070707000070000007070000065ccc5ccc556
65887888885600000000000000000000000000000000000000000000000000000000000000000000770007707700707077700000010077700000655555555556
65588888855600000000000000000000000000000000000000000d0000000000000000000000000000000d000000000000000000000000000000655555555556
6555888855560000000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655566665556
65555885555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655611116556
65555555555600000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000655611116556
65588558855600000000000000000000000000000000000000000000000000000000000000d00005500000000005500000000005500000000000655611116556
65888888885600000c0550c000000c0550c000000c0550c000000c0550c000000c0550c000600c5665c000000c5665c000000c5665c000000000655611116556
65878888885600000056650000000056650000000056650000000056650000000056650000000068860000000068860000000068860000000000655611116556
65887888885600000068860000000068860000000d68860000000068860000000068860000000056650000000056650000000056650000000000655611116556
65588888855600000056650000000056650100000056650000000056650000010056650000000006600000000006600000000006600000000000655611116556
65558888555600000c0660c000000c0660c000000c0660c000000c0660c0000d0c0660c0000000c55c00000000c55c00000000c55c0000000000655611116556
655558855556000000055000000000055000000000055000000000055000000600055000000000d0000000000000000000000000000000000000655611116556
65555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655611116556
65588558855600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655611116556
65888888885600000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000100000655611116556
65878888885600000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000010000000d00000655611116556
658878888856000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000d0000000600000655611116556
6558888885560000000000000000000550000000000550000000000cc0000000000cc0000000000cc0000000000cc00000000060000000000000655611116556
65558888555600000000000000000c5665c000000c5665c000000005500000000005500000000005500000000005500d00000000000000000000655611116556
6555588555560000000000000000006886000000d06886000000d056650000000056650000000056650000000056650000000000000000000000655611116556
65555555555600000000000000000056650000000056650000000c6886c000000c6886c000000c6886c000000c6886c000000000000000000000655611116556
65588558855600000000000000000006600000000006600000000056650000000056650000000056650000000d56650000000000000000000000655611116556
658888888856000000000000000000c55c00000000c55c0000000006600000000006601000000006600000000006600000000000000000000000655611116556
658788888856000000000000000000000000000000000000000000055000000000055000000000055000000000055000000000000000000000006556cccc6556
6588788888560000000000000000000000000000000000000000000cc0000000000cc0000000000cc0000000000cc000000000000000000000006556cccc6556
655888888556000000000000000000000000000000010000000000000000000000000000000001000000000000000000000000000000000000006556cccc6556
6555888855560000000000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655558855556000001000000000000000000000000060000000000100000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000000006556cccc6556
6558855885560000000000000000000000000000000cc000000000600000000000000d000000000cc000000000000000000000000000000000006556cccc6556
658888888856000000000000000000000000000000055000000000000000000000000000000000055000000000000000000000000000000000006556cccc6556
658788888856000000000000000000000000000000566500000000000000000000001000000000566500000000000000000000000000000000006556cccc6556
65887888885600000000000000000000000000000c6886c000000000000000000000d00000000c6886c0000000000000000000000000000000006556cccc6556
65588888855600d000000000000000000000000000566500000000000000000000006000000000566500000000000000000000000000000000006556cccc6556
655588885556000000000000000000000000000000066000000000000000000000000000000000066000000000000000000000000000000000006556cccc6556
655558855556000000000000000000000000000000055000000000000000000aa0000000000000055000000000000001000000000000000000006556cccc6556
6555555555560000000000000000000000000000000cc00000000000000000aa7a0000000000000cc00000000000000d000000000000000000006556cccc6556
65588558855600000000000100000000000000000000000000000000000000aaaa000000000000000000000000000006000000000000000000006556cccc6556
65888888885600000000000d000000000000000000000000000000000000000aa0000000000000000000000000000000000000000000000000006556cccc6556
658788888856000000000006000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000006556cccc6556
65887888885600000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000006556cccc6556
655888888556000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000006556cccc6556
65558888555600000000000000000000000000000000000000000000000000000000010000000000000000000000000000000d000000000000006556cccc6556
655558855556000000000000000000000000000010000000000000000000000000000d00000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000006556cccc6556
655885588556000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000006556cccc6556
658888888856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
6587888888560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d6556cccc6556
658878888856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000006556cccc6556
6558888885560000100000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000000000000006556cccc6556
655588885556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000006556cccc6556
655558855556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
65588558855600000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000006556cccc6556
658888888856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
658788888856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000006556cccc6556
658878888856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000006556cccc6556
65588888855600000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000d000006556cccc6556
65558888555600000000000000000000000000000000000000000000000d00000000000000d000000000000000000000000000000000006000006556cccc6556
655558855556000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655885588556000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000006556cccc6556
65811881185600000000000000000000000000000000000000000000000d000000000000d00000000000000000000000000000000000000000006556cccc6556
658711111856000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000006556cccc6556
6581711118560000000000000000000000000000000000000000000000000000000000000000000000000d0000000000000000000000000000006556cccc6556
655811118556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655581185556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655558855556000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655885588556000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000001000006556cccc6556
65811881185600000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000006556cccc6556
658711111856000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000006556cccc6556
658171111856000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655811118556000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000006556cccc6556
65558118555600000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655558855556000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000006556cccc6556
65555555555600000000000000000000000d000000000000000000000000000000000000000000000000000000000000000000000100000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
65555555555600100000000000000000000010000000000000000000000000d000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000d0000000000000000000000000000000000000000000000d000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000100000000000000000000010000000000000000000000000000000000000000000000000000100000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000006556cccc6556
65555555555600000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000d000000006556cccc6556
6555555555560000000000000000000000000000000000000000000000000d0000000000000000000010000000000000000000000006000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000001000006556cccc6556
65555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000660000000000000000000000000000000000000000000000000006556cccc6556
655555555556000d00000000000000000000000000000000000000000000005775000000000000000000000000000000000000010000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000007667000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000006cc6000000000000000000000000000000000000000000000000006556cccc6556
65555555555600000000000000000000000000000000000000000000000007c77c700000000000000000000000000000000000000000000000006556cccc6556
65555555555600000000000000000000000000000000000000000000000076c77c670000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000057997500000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000070a90700000000000000000000000000000000000000000000000006556cccc6556
6555555555560000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000006556cccc6556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
655555555556000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006556cccc6556
65555555555600000d00000000000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000655566665556
65555555555600000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655555555556
65555555555600000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000655555555556
655555555556000000000000000000000000000000000000000000000000000000000000000000000000d0000000000000000000000000000000655555555556
65555555555600000000000000010000000000000000000000000000000000000000000000000000000060000000000000000000000000000000655555555556
65bbbbbbbb560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065bbbbbbbb56
6b33333333b6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006b33333333b6
6b33333333b6000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000006b33333333b6
6b33366333b60d0000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000006b333aa333b6
6b33566533b60000000000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000006b33a7aa33b6
6b33666633b6000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000006b33aaaa33b6
6b33333333b6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006b333aa333b6
6b33333333b6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006b33333333b6
6b33333333b6000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000006b33333333b6
6b33333333b6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006b33333333b6
65bbbbbbbb560000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000065bbbbbbbb56
06666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666660

__sfx__
000100001d3501a35017350133500f3500c3500835007350053500430005300093000830006300053000230001300000000000001000010000100000000004001a70017700157001370011700107001070010700
45040000346102b5302964022550206501855016640106300b6000760003600076000660004600036000260002600056000260001600016000f6000e6000e6000e6000e6000e6000e6000e6000f6000f60010600
0003000016150101500c1500815004150350501a0502d050200502005027050210502a05027000210002a0001d000110000d0000a0000600017000200002500026000080000e000140001700004000080000a000
000200001d05026650130501c650131500c650051500265001650251002a1002e1002f1002b1001f10013100111001a10015100121000c1000010000100001000010000100001000010000100001000010000100
0016000005055050550505505055050550505507055070550a0550a0550a0550a0550a0550a0550c0550c0550705507055070550705507055070550c0550c0550305503055030550305503055030550705507055
011600001f75024750297502975027750227501f75022750247502475029750297502975027750227501f7501f7501f7501f7502275024750247502775027750227501f7501d7501d7501d7501d7501f7001f700
011600001f75024750297502975027750227501f75022750247502475029750297502975027750297502e7502e7502e7502e75022750247502475027750277502475024750227502775027750297502975005700
391600001f75024700297502970027750227001f75022700247502470029750297002975027700227501f7001f7501f7001f7502270024750247002775027700227501f7001d7501d7501d7501d7501f7001f700
391600001f75024700297502970027750227001f75022700247502470029750297002975027700297502e7002e7502e7002e75022700247502470027750277002475024700227502770027750297502975005700
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c1600001f75224752297522975227752227521f75222752247522475229752297522975227752227521f7521f7521f7521f7521d74218742187420f7420f7420a73207732117321173211732117321f7021f702
081e00001f70224702297022970227702227021f70222702247022470229702297022970227702227021f7021f7021f7021f7022270224702247022770227702227021f7021d7021d7021d7021d7021f7021f702
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00000705005050110500e050190501605024050200502705026050000002505026000280502b0502f05000000280002b0002f000000000000000000000000000000000000000000000000000000000000000
000200002e7502e7502e7502e75035750357503575035750007002c7002d7002d7002670025700257002570025700267002670026700007000070000700007000070000700007000070000700007000070000700
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000029750227501e7501b7501c7501e750237502d700057000470005700097000870006700057000270001700007000070001700017000170000700007001a70017700157001370011700107001070010700
0002000025050200501a050170501e0501a05015050120500c0500c05005000090000800006000050000200001000000000000001000010000100000000000001a00017000150001300011000100001000010000
0002000012050100500d0502a050240501d0501a050100500c0500900005000010000000006000040000300001000000000000000000010000100000000000001a00017000150001300011000100001000010000
00020000200501e0501b0501805014050110500e0500c0500a0500805006050040500800006000050000200001000000000000001000010000100000000000001a00017000150001300011000100001000010000
000200000800006000050000200001000000000000001000010000100000000000001a00017000150001300011000100001000010000000000000000000000000000000000000000000000000000000000000000
__music__
01 04454647
01 04054644
00 04064644
00 04054744
00 04064544
00 44074744
00 47070844
00 04074544
02 04070844
04 0a424344
01 04424344
03 04054344

