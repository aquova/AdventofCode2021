pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- aoc 2021 day 11
-- @aquova

--	a visualizatoin of the
--	advent of code 2021 day 11
--	puzzle, done in pico-8

function _init()
	frames=0
	idx=0
	ripples={}
	input={
		{4,5,2,5,4,3,6,4,1,7},
		{1,8,5,1,2,4,2,5,5,3},
		{5,4,2,1,4,3,5,5,2,1},
		{8,4,3,1,3,2,5,4,4,7},
		{4,5,1,7,4,3,8,3,3,2},
		{3,5,2,1,2,6,2,1,1,1},
		{3,3,3,1,5,4,1,7,3,4},
		{4,3,5,1,8,3,6,6,4,1},
		{2,7,5,3,8,8,1,4,4,2},
		{7,7,1,7,6,1,6,8,6,3},
	}
end

function _update()
	frames+=1
	for r in all(ripples) do
		local dead=r:update()
		if dead then
			del(ripples,r)
		end
	end
	
	if frames%15==0 then
		idx+=1
		flash_step(input)
	end
end

function _draw()
	cls()
	
	for r in all(ripples) do
		r:draw()
	end
	
	for y=1,#input do
		for x=1,#input[y] do
			local c=input[y][x]==0 and 7 or 1
			local pos=cnvt_xy(x,y)
			circfill(pos.x,pos.y,3,c)
		end
	end

	print(idx,2,2,1)	
	print(idx,1,1,6)
end

function cnvt_xy(_x,_y)
	return {x=12*_x-2,y=12*_y-2}
end

function new_ripple(_x,_y)
	local r={
		r=3,max_r=15
	}
	
	local pos=cnvt_xy(_x,_y)
	r.x=pos.x
	r.y=pos.y
	
	function r:update()
		r.r+=1
		return r.r>=r.max_r
	end
	
	function r:draw()
		local c
		if r.r<7 then
			c=7
		elseif r.r<12 then
			c=6
		else
			c=5
		end
		circfill(r.x,r.y,r.r,c)
	end
	
	return r
end

function flash_spot(_g,_x,_y)
	local another=false
	for dx=-1,1 do
		for dy=-1,1 do
			local xx=_x+dx
			local yy=_y+dy
			if xx<1 or xx>10 or yy<1 or yy>10 then
				goto continue
			end
			if xx==x and yy==y then
				goto continue
			end
			if _g[yy][xx]>0 then
				_g[yy][xx]+=1
				if _g[yy][xx]>9 then
					another=true
					add(ripples,new_ripple(xx,yy))
				end 
			end
			::continue::
		end
	end
	_g[_y][_x]=0
	return another
end

function flash_step(_g)
	local triggered=false
	for y=1,#_g do
		for x=1,#_g[y] do
			_g[y][x]+=1
			if _g[y][x]>9 then
				triggered=true
				add(ripples,new_ripple(x,y))
			end
		end
	end
	
	while triggered do
		triggered=false
		for y=1,#_g do
			for x=1,#_g[y] do
				if _g[y][x]>9 then
					if flash_spot(_g,x,y) then
						triggered=true
					end
				end
			end
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
