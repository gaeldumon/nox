local Hero = {}

Hero.Frames = {}
Hero.currentFrame = 1
Hero.line = 1
Hero.column = 1
Hero.keyPressed = false
Hero.actionPressed = false
Hero.cut = 0
Hero.sound_cut = nil
Hero.wood = 0
Hero.sound_getWood = nil
Hero.energy = 10
Hero.sound_energy = nil
Hero.sound_hurt = nil
Hero.drink = false
tree_cut = false

function Hero.Load()
	Hero.Frames[1] = love.graphics.newImage('images/player_1.png')
	Hero.Frames[2] = love.graphics.newImage('images/player_2.png')
	Hero.Frames[3] = love.graphics.newImage('images/player_3.png')
	Hero.Frames[4] = love.graphics.newImage('images/player_4.png')

	Hero.sound_cut = love.audio.newSource('sounds/Shield.wav', 'static')
	Hero.sound_cut:setVolume(0.5)
	Hero.sound_getWood = love.audio.newSource('sounds/Shield.wav', 'static')
	Hero.sound_getWood:setVolume(0.5)
	Hero.sound_hurt = love.audio.newSource('sounds/Hero_Hurt.wav', 'static')
	Hero.sound_hurt:setVolume(0.2)
	Hero.sound_energy = love.audio.newSource('sounds/energy.wav', 'static')
end

function Hero.Update(pMap, dt)
	----Hero animation
	--0.1 incrementation to reduce animation speed (10 times slower than +1 incrementation)
	Hero.currentFrame = Hero.currentFrame + ( 4 * dt)
	if math.floor(Hero.currentFrame) > #Hero.Frames then
		Hero.currentFrame = 1
	end
	----

	----IF YOU PRESS C OR D (aka actions) - It works if you have the tile on your right (i.e Hero.column+1)
	if love.keyboard.isDown('c', 'd') then
		if Hero.actionPressed == false then
			local action_id = pMap.Grid[Hero.line + 1][Hero.column]

			if love.keyboard.isDown('c') then
				if pMap.isTree(action_id) == true then
					Hero.cut = Hero.cut + 1
					Hero.sound_cut:play()
					print("Cuting...")
				end
			end

			if love.keyboard.isDown('d') then
				if pMap.isWater(action_id) == true then
					if Hero.energy < 10 then
						Hero.energy = Hero.energy + 1
						Hero.sound_energy:play()
						print('Drinking...')
					end
				end
			end

			Hero.actionPressed = true
		end
	else
		Hero.actionPressed = false
	end
	----

	----This block is used to reset the cuts counter (Hero.cut) to zero if the Hero is no longer adjacent to a tree
	----this way each time I change tree for another I begin a fresh cuts count
	do
		local id = pMap.Grid[Hero.line + 1][Hero.column]
		if pMap.isTree(id) == false then
			Hero.cut = 0
		end
	end
	----

	----Tree-is-cut state, meaning you get 3 wood logs, cut counter is reset to 0, and tree_cut is true
	if Hero.cut == 3 then
		print("Tree is cut !")
		tree_cut = true
		Hero.sound_getWood:play()
		Hero.wood = Hero.wood + 3
		Hero.cut = 0
	else
		tree_cut = false
	end
	----

	----IF YOU PRESS ARROWS (walk one by one, collide with solids, clear fog)
	if love.keyboard.isDown('up', 'right', 'down', 'left') then

		if Hero.keyPressed == false then

			local old_column = Hero.column
			local old_line = Hero.line

			if love.keyboard.isDown('up') and Hero.line > 1 then
				Hero.line = Hero.line - 1
			end

			if love.keyboard.isDown('right') and Hero.column < pMap.MAP_WIDTH then
				Hero.column = Hero.column + 1
			end

			if love.keyboard.isDown('down') and Hero.line < pMap.MAP_HEIGHT then
				Hero.line = Hero.line + 1
			end

			if love.keyboard.isDown('left') and Hero.column > 1 then
				Hero.column = Hero.column - 1
			end

			local id = pMap.Grid[Hero.line][Hero.column]

			----Hero collides with solid tiles he stays on his "previous" tile
			if pMap.isSolid(id) == true then
				Hero.column = old_column
				Hero.line = old_line
				print("Collision avec : " .. pMap.TileTypes[id])
			else
				pMap.clearFog(Hero.line, Hero.column)
			end
			----

			if pMap.isCactus(id) == true or pMap.isLava(id) == true then
				if Hero.energy > 0 then
					Hero.energy = Hero.energy - 1
				else
					Hero.energy = 0
				end
				Hero.sound_hurt:play()
			end

			Hero.keyPressed = true
		end
	else
		Hero.keyPressed = false
	end
	----
end

function Hero.Draw(pMap)
	local x = (Hero.column - 1) * pMap.TILE_WIDTH
	local y = (Hero.line - 1) * pMap.TILE_HEIGHT
	love.graphics.draw(Hero.Frames[math.floor(Hero.currentFrame)], x, y, 0, 2, 2)

	----If tree is cut (Hero.cut 3 times) then replacing tree tile with grass tile
	----I write it here and not in Game cause it's a result of the Hero action on the map... bad idea ?
	if tree_cut == true then
		pMap.Grid[Hero.line + 1][Hero.column] = 10
	end
	----
end

return Hero