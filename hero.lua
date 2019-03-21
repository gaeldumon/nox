local Hero = {}

Hero.Frames = {}
Hero.currentFrame = 1
Hero.line = 1
Hero.column = 1
Hero.keyPressed = false
Hero.actionPressed = false
Hero.cut = 0
tree_cut = false

function Hero.Load()
	Hero.Frames[1] = love.graphics.newImage('images/player_1.png')
	Hero.Frames[2] = love.graphics.newImage('images/player_2.png')
	Hero.Frames[3] = love.graphics.newImage('images/player_3.png')
	Hero.Frames[4] = love.graphics.newImage('images/player_4.png')
end

function Hero.Update(pMap, dt)
	----Hero animation
	--0.1 incrementation to reduce animation speed (10 times slower than +1 incrementation)
	Hero.currentFrame = Hero.currentFrame + ( 4 * dt)
	if math.floor(Hero.currentFrame) > #Hero.Frames then
		Hero.currentFrame = 1
	end
	----

	----Dealing with the Hero ability to do actions (cut trees, drink...)
	if love.keyboard.isDown('c', 'd') then

		if Hero.actionPressed == false then

			local action_id = pMap.Grid[Hero.line][Hero.column + 1]

				if pMap.isTree(action_id) == true then

					if love.keyboard.isDown('c') then
						print("Cuting...")
						Hero.cut = Hero.cut + 1
					end

				end

			if love.keyboard.isDown('d') then

				if pMap.isWater(action_id) == true then
					print('Drinking...')
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
		local id = pMap.Grid[Hero.line][Hero.column+1]
		if pMap.isTree(id) == false then
			Hero.cut = 0
		end
	end
	----

	if Hero.cut == 3 then
		print("Tree is cut !")
		tree_cut = true
		Hero.cut = 0
	else
		tree_cut = false
	end

	----Dealing with the Hero ability to move around and collide with solids
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

			----Hero collides with solid tiles types (see Game.Map.isSolid() in game.lua)
			local id = pMap.Grid[Hero.line][Hero.column]

			if pMap.isSolid(id) == true then
				print("Collision with : " .. pMap.TileTypes[id])
				Hero.column = old_column
				Hero.line = old_line
			else
				pMap.clearFog(Hero.line, Hero.column)
			end
			----

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

	if tree_cut == true then
		pMap.Grid[Hero.line][Hero.column + 1] = 10
	end
end

return Hero