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
Hero.bucket = 0
Hero.sound_getWood = nil
Hero.energy = 10
Hero.sound_energy = nil
Hero.die = false
Hero.sound_die = nil
Hero.sound_hurt = nil
Hero.drink = false
tree_cut = false
bcraft = false

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
	Hero.sound_die = love.audio.newSource('sounds/Scream.wav', 'static')
end

function Hero.Update(pMap, dt)

	if Hero.die == false then

		----HERO ANIMATION
		--We increment by 0.1 to reduce animation speed (10 times slower than +1 incrementation)
		if Hero.die == false then
			Hero.currentFrame = Hero.currentFrame + ( 4 * dt)
			if math.floor(Hero.currentFrame) > #Hero.Frames then
				Hero.currentFrame = 1
			end
		else
			Hero.currentFrame = 1
		end
		----

		----HERO ACTIONS
		Hero.actionID = pMap.Grid[Hero.line + 1][Hero.column]

		if love.keyboard.isDown('c', 'd', 'f', 'v') then
			if Hero.actionPressed == false then

				----ACTION : CUT TREE
				if love.keyboard.isDown('c') then
					if pMap.isTree(Hero.actionID) == true then
						Hero.cut = Hero.cut + 1
						Hero.sound_cut:play()
						print("Cuting")
					end
				end
				----

				----ACTION : DRINK WATER
				if love.keyboard.isDown('d') then
					if pMap.isWater(Hero.actionID) == true then
						if Hero.energy < 10 then
							Hero.energy = Hero.energy + 1
							Hero.sound_energy:play()
							print('Drinking')
						end
					end
				end
				----

				----ACTION : CRAFT BUCKET
				if love.keyboard.isDown('f') then

				end
				----

				Hero.actionPressed = true
			end
		else
			Hero.actionPressed = false
		end
		----

		----RESETING TREE CUT COUNTER BETWEEN EACH TREES - Here because it's outside keyboard C action scope
		if pMap.isTree(Hero.actionID) == false then
			Hero.cut = 0
		end
		----

		if Hero.cut == 3 then
			tree_cut = true
		else
			tree_cut = false
		end

		if tree_cut == true then
			Hero.wood = Hero.wood + 3
			Hero.cut = 0
			pMap.Grid[Hero.line + 1][Hero.column] = 10
			Hero.sound_getWood:play()

			if Hero.wood % 6 == 0 then
				Hero.bucket = Hero.bucket + 1
				Hero.wood = 0
			end
		end

		----HERO CONTROLS (walk one by one, collide with solids, clear fog)
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

				----On keyboard push Hero collides with solid tiles : hero stays on his "previous" tile
				if pMap.isSolid(id) == true then
					Hero.column = old_column
					Hero.line = old_line
					print("Collision avec : " .. pMap.TileTypes[id])
				else
					pMap.clearFog(Hero.line, Hero.column)
				end
				----

				----On keyboard push if the hero collides with tiles that hurt him (cactus, lava)
				if pMap.isCactus(id) == true or pMap.isLava(id) == true then
					if Hero.energy > 0 then
						Hero.energy = Hero.energy - 1
					else
						Hero.energy = 0
					end
					Hero.sound_hurt:play()
				end
				----

				----HERO DIES - GAME OVER STATE - Hero.die is used in Game to pause hero update, make text, stop game music.
				if pMap.isPlague(id) == true then
					Hero.die = true
					Hero.energy = 0
					Hero.sound_die:play()
				end
				----

				Hero.keyPressed = true
			end
		else
			Hero.keyPressed = false
		end
		----

	end

end

function Hero.Draw(pMap)
	local x = (Hero.column - 1) * pMap.TILE_WIDTH
	local y = (Hero.line - 1) * pMap.TILE_HEIGHT
	love.graphics.draw(Hero.Frames[math.floor(Hero.currentFrame)], x, y, 0, 2, 2)
end

return Hero