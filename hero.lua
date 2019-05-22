local hero = {}

hero.Frames = {}
hero.currentFrame = 1

hero.line = 2
hero.column = 2

hero.keyPressed = false
hero.actionPressed = false

hero.cut = 0
hero.wood = 0
hero.bucket = 0
hero.energy = 5
hero.escape = false

hero.die = false

tree_cut = false
craft_bucket = false

hero.sound_cut = nil
hero.sound_craftBucket = nil
hero.sound_getWood = nil
hero.sound_waterOnLava = nil
hero.sound_die = nil
hero.sound_hurt = nil

function hero.Load()
	hero.Frames[1] = love.graphics.newImage('images/player_1.png')
	hero.Frames[2] = love.graphics.newImage('images/player_2.png')
	hero.Frames[3] = love.graphics.newImage('images/player_3.png')
	hero.Frames[4] = love.graphics.newImage('images/player_4.png')

	hero.sound_cut = love.audio.newSource('sounds/cut.wav', 'static')
	hero.sound_cut:setVolume(0.5)
	hero.sound_craftBucket = love.audio.newSource('sounds/craft.wav', 'static')
	hero.sound_waterOnLava = love.audio.newSource('sounds/wateronlava.wav', 'static')
	hero.sound_waterOnLava:setVolume(0.3)
	hero.sound_hurt = love.audio.newSource('sounds/hurt.wav', 'static')
	hero.sound_hurt:setVolume(0.2)
	hero.sound_die = love.audio.newSource('sounds/death.wav', 'static')
end

function hero.Update(pMap, dt)

	if hero.die == false then

		----HERO ANIMATION
		hero.currentFrame = hero.currentFrame + ( 4 * dt)
		if math.floor(hero.currentFrame) > #hero.Frames then
			hero.currentFrame = 1
		end
		----

		----HERO ACTIONS - @BUG SOURCE -> Index a Map line that does not exist
		hero.actionID = pMap.grid[hero.line + 1][hero.column]
		hero.lavaActionID = pMap.grid[hero.line][hero.column + 1]

		if love.keyboard.isDown('e', 'f') then

			if hero.actionPressed == false then

				----ACTIONS : CUT TREE, CRAFT A BUCKET, POOR WATER BUCKET ON LAVA
				if love.keyboard.isDown('e') then

					if pMap.isTree(hero.actionID) == true then
						hero.cut = hero.cut + 1
						hero.sound_cut:play()
					end

					if pMap.isLava(hero.lavaActionID) == true then
						if hero.bucket > 0 then
							pMap.grid[hero.line][hero.column + 1] = 53
							hero.bucket = hero.bucket - 1
							hero.sound_waterOnLava:play()
						end
					end

				end

				if love.keyboard.isDown('f') then

					if craft_bucket == true then
						hero.bucket = hero.bucket + 1
						hero.wood = hero.wood - 6
						hero.sound_craftBucket:play()
					end

				end
				----

				hero.actionPressed = true
			end
		else
			hero.actionPressed = false
		end
		----

		if hero.cut == 3 then
			tree_cut = true
			pMap.grid[hero.line + 1][hero.column] = 10
			hero.wood = hero.wood + 3
			hero.cut = 0
		else
			tree_cut = false
		end

		if hero.wood >= 6 then
			craft_bucket = true
		else
			craft_bucket = false
		end

		----Reseting strike counter when you change tree
		if pMap.isTree(hero.actionID) == false then
			hero.cut = 0
		end
		----

		----HERO DIES - GAME OVER STATE - hero.die is used in Game to pause hero update, make text, stop game music.
		do
			local id = pMap.grid[hero.line][hero.column]
			if pMap.isPlague(id) == true or hero.energy == 0 then
				hero.die = true
				hero.energy = 0
				hero.sound_die:play()
			end
		end
		----

		----HERO CONTROLS AND COLLISIONS
		if love.keyboard.isDown('up', 'right', 'down', 'left') then

			if hero.keyPressed == false then

				local old_column = hero.column
				local old_line = hero.line

				if love.keyboard.isDown('up') and hero.line > 1 then
					hero.line = hero.line - 1
				end
				--@BUG SOURCE TO FIX : something about the controls after escaping 
				if love.keyboard.isDown('right') and hero.column < pMap.MAP_WIDTH or hero.line > 12 then
					hero.column = hero.column + 1
					if hero.column > pMap.MAP_WIDTH then
						hero.escape = true
						hero.column = 1
					end
				end

				if love.keyboard.isDown('down') and hero.line < pMap.MAP_HEIGHT then
					hero.line = hero.line + 1
				end

				if love.keyboard.isDown('left') and hero.column > 1 then
					hero.column = hero.column - 1
				end

				local id = pMap.grid[hero.line][hero.column]

				----COLLISION WITH SOLID TILES (hero stays on his tile) + CLEARING FOG
				if pMap.isSolid(id) == true then
					hero.column = old_column
					hero.line = old_line
				else
					pMap.clearFog(hero.line, hero.column)
				end
				----

				----COLLISION WITH HURTING TILES (LAVA, CACTUS)
				if pMap.isCactus(id) == true or pMap.isLava(id) == true then
					if hero.energy > 0 then
						hero.energy = hero.energy - 1
					else
						hero.energy = 0
					end
					hero.sound_hurt:play()
				end
				----

				hero.keyPressed = true
			end
		else
			hero.keyPressed = false
		end
		----

	else
		hero.currentFrame = 1
	end

end

function hero.Draw(pMap)
	local x = (hero.column - 1) * pMap.TILE_WIDTH
	local y = (hero.line - 1) * pMap.TILE_HEIGHT
	local hero_h = hero.Frames[math.floor(hero.currentFrame)]:getHeight()
	love.graphics.draw(hero.Frames[math.floor(hero.currentFrame)], x, y-hero_h/2, 0, 2, 2)
end

return hero