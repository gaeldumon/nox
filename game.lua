local def = require('define')
local transition = require('transition')

local game = {}

game.hero = require('hero')

game.map = {}
game.map.grid = {}
game.map.fogGrid = {}
game.tilesheet = nil
game.tileTextures = {}
game.map.tileTypes = {}

game.map.grid = {
    { 21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21 },
    { 21,10,10,10,10,11,11,11,10,10,10,13,10,10,10,10,10,10,10,14,15,15,129,15,15,15,15,15,15,68,15,21 },
    { 21,10,61,10,11,19,19,19,11,10,10,13,10,10,169,10,10,10,10,13,14,15,15,15,15,15,15,15,15,15,15,21 },
    { 21,10,10,11,19,19,19,19,19,11,10,13,10,10,10,10,10,10,10,10,13,14,15,15,15,68,15,15,15,15,15,21 },
    { 21,10,10,11,19,19,19,19,19,11,10,13,10,10,10,10,10,10,61,10,10,14,15,15,15,15,15,15,15,15,15,21 },
    { 21,10,61,10,11,19,19,19,11,10,10,13,10,10,10,10,10,10,10,10,10,14,15,15,129,15,15,15,68,15,129,21 },
    { 21,10,10,10,10,11,11,11,10,10,61,13,10,10,10,10,10,10,10,10,10,14,15,15,15,15,15,15,15,15,15,21 },
    { 21,13,13,13,13,13,13,13,13,13,13,13,10,10,10,10,10,169,10,10,10,13,14,15,15,15,15,15,15,15,15,21 },
    { 21,10,10,10,10,10,10,10,13,10,10,10,10,10,10,10,10,10,10,10,61,10,13,14,14,14,14,14,14,14,15,21 },
    { 21,10,10,10,10,10,10,10,13,55,10,58,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,13,14,21 },
    { 21,10,10,10,10,10,10,10,13,10,10,10,55,10,58,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,21 },
    { 21,10,10,10,10,10,10,10,13,10,58,10,10,10,10,10,10,169,10,10,10,10,10,10,61,10,10,10,10,10,1,21 },
    { 21,10,10,10,10,10,10,10,13,10,10,10,58,10,10,10,10,10,10,10,10,61,10,10,10,10,10,10,10,1,37,37 },
    { 21,10,10,10,13,13,13,13,13,10,55,10,10,10,55,10,10,10,10,10,10,10,10,10,10,10,10,1,1,37,37,37 },
    { 21,10,10,10,13,10,10,10,10,10,10,10,55,10,10,10,10,169,10,10,10,10,10,10,10,10,1,37,37,37,37,37 },
    { 21,10,10,10,13,10,10,10,10,142,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,1,37,37,37,37,37,37 },
    { 21,10,10,10,13,10,10,10,10,10,10,10,10,142,10,10,10,10,10,10,10,169,10,10,1,37,37,37,37,37,37,37 },
    { 21,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,37,37,37,37,37,37,37 },
    { 21,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,37,37,37,37,37,37,37 },
    { 19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,1,37,37,37,37,37,37,37 },
    { 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,1,37,37,37,37,37,37 },
    { 21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,1,37,37,37,37 },
    { 21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,1,37,37,37 }
}

grid2 = {
    { 15,15,14,15,14,10,10,10,10,61,10,13,10,10,10,10,10,10,13,14,15,15,15,15,15,15,15,15,15,15,15,15 },
    { 15,15,14,14,14,11,11,11,10,10,10,13,10,10,10,10,10,10,10,14,15,15,129,15,15,15,15,15,15,68,15,15 },
    { 15,15,68,14,68,19,19,19,11,10,10,13,10,10,169,10,10,10,10,13,14,15,15,15,15,15,15,15,15,15,15,15 },
    { 15,15,15,15,14,19,19,19,19,11,10,13,10,10,10,10,10,10,10,10,13,14,15,15,15,68,15,15,15,15,15,15 },
    { 15,68,15,15,14,19,19,19,19,11,10,13,10,10,10,10,10,10,61,10,10,14,15,15,15,15,15,15,15,15,15,15 },
    { 15,15,15,15,14,19,19,19,11,10,10,13,10,10,10,10,10,10,10,10,10,14,15,15,129,15,15,15,68,15,129,15 },
    { 15,15,15,68,14,11,11,11,10,10,61,13,10,10,10,10,10,10,10,10,10,14,15,15,15,15,15,15,15,15,15,15 },
    { 14,14,14,14,14,13,13,13,13,13,13,13,10,10,10,10,10,169,10,10,10,13,14,15,15,15,15,15,15,15,15,15 },
    { 14,14,14,14,14,10,10,10,13,10,10,10,10,10,10,10,10,10,10,10,61,10,13,14,14,14,14,14,14,14,15,129 },
    { 14,14,14,14,14,10,10,10,13,55,10,58,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,13,14,14 },
    { 14,14,15,15,15,10,10,10,13,10,10,10,55,10,58,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10 },
    { 14,14,15,15,15,10,10,10,13,10,58,10,10,10,10,10,10,169,10,10,10,10,10,10,61,10,10,10,10,10,1,1 },
    { 14,14,15,15,15,10,10,10,13,10,10,10,58,10,10,10,10,10,10,10,10,61,10,10,10,10,10,10,10,1,37,37 },
    { 14,14,15,15,13,13,13,13,13,10,55,10,10,10,55,10,10,10,10,10,10,10,10,10,10,10,10,1,1,37,37,37 },
    { 14,14,15,15,13,10,10,10,10,10,10,10,55,10,10,10,10,169,10,10,10,10,10,10,10,10,1,37,37,37,37,37 },
    { 14,15,15,15,13,10,10,10,10,142,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,1,37,37,37,37,37,37 },
    { 37,15,15,15,13,10,10,10,10,10,10,10,10,142,10,10,10,10,10,10,10,169,10,10,1,37,37,37,37,37,37,37 },
    { 37,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,37,37,37,37,37,37,37 },
    { 37,37,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,37,37,37,37,37,37,37 },
    { 37,37,37,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,1,37,37,37,37,37,37,37 },
    { 37,37,37,37,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,1,37,37,37,37,37,37 },
    { 37,37,37,37,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,1,37,37,37,37 },
    { 37,37,37,37,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,1,37,37,37 }
}

game.map.fogGrid = {}

game.map.MAP_WIDTH = 32
game.map.MAP_HEIGHT = 23
game.map.TILE_WIDTH = 32
game.map.TILE_HEIGHT = 32

game.music = nil

timer_plague = 0
freq_plague = 20

-----------------------------------------------HOMEMADE FUNCTIONS--------------------------------------------------

function game.map.isSolid(pID)
    local tileType = game.map.tileTypes[pID]
    if tileType == 'sea' or tileType == 'tree' or tileType == 'cactus' or tileType == 'rock' then
        return true
    end

    return false
end

function game.map.isTree(pID)
    local tileType = game.map.tileTypes[pID]
    if tileType == 'tree' then
        return true
    end

    return false
end

function game.map.isWater(pID)
    local tileType = game.map.tileTypes[pID]
    if tileType == 'water' then
        return true
    end

    return false
end

function game.map.isCactus(pID)
    local tileType = game.map.tileTypes[pID]
    if tileType == 'cactus' then
        return true
    end

    return false
end

function game.map.isLava(pID)
    local tileType = game.map.tileTypes[pID]
    if tileType == 'lava' then
        return true
    end

    return false
end

function game.map.isPlague(pID)
    local tileType = game.map.tileTypes[pID]
    if tileType == 'plague' then
        return true
    end

    return false
end

function game.map.loadFog(pMap)
	local l,c
    for l = 1, pMap.MAP_HEIGHT do
        pMap.fogGrid[l] = {}
        for c = 1, pMap.MAP_WIDTH do
            pMap.fogGrid[l][c] = 1
        end
    end
end

function game.map.clearFog(pLine, pCol)
    --print("Clear fog!")
    local c,l
    for l = 1, game.map.MAP_HEIGHT do
        for c = 1, game.map.MAP_WIDTH do
            if l > 0 and l <= game.map.MAP_HEIGHT and c > 0 and c <= game.map.MAP_WIDTH then
                local dist = math.dist(c, l, pCol, pLine)
                if dist < 5 then
                    local alpha = dist / 5
                    if game.map.fogGrid[l][c] > alpha then
                        game.map.fogGrid[l][c] = alpha
                    end
                end
            end
        end
    end
end

----Generate a "plague" tile at random coordinates
function game.makePlague(pMap)
    local random_line = love.math.random(1, pMap.MAP_HEIGHT)
    local random_col = love.math.random(1, pMap.MAP_WIDTH)
    if pMap.grid[random_line][random_col] ~= 76 then
        pMap.grid[random_line][random_col] = 76
    end
end

function game.map.mouseover(pMap)
	local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    --We add one because of 1-based tables in lua (instead of 0)
    local col = math.floor(mouseX / pMap.TILE_WIDTH) + 1
    local line = math.floor(mouseY / pMap.TILE_HEIGHT) + 1
    if col > 0 and col <= pMap.MAP_WIDTH and line > 0 and line <= pMap.MAP_HEIGHT then
      	local id = pMap.grid[line][col]
      	print("Type de tile = ".. tostring(pMap.tileTypes[id]) .. " (ID = " .. tostring(id) .. ")")
    else
      	print("Hors du tableau")
    end
end

function game.loadTextures(pTilesheet, pTableTextures, pMap)
    local nb_cols = pTilesheet:getWidth() / pMap.TILE_WIDTH
    local nb_lines = pTilesheet:getHeight() / pMap.TILE_HEIGHT
    local l,c
    local id = 1
    for l = 1, nb_lines do
      	for c = 1, nb_cols do
        	pTableTextures[id] = love.graphics.newQuad(
	          	(c - 1) * pMap.TILE_WIDTH, 
	          	(l - 1) * pMap.TILE_HEIGHT, 
	          	pMap.TILE_WIDTH, 
	          	pMap.TILE_HEIGHT, 
	          	pTilesheet:getWidth(),
	          	pTilesheet:getHeight()
        	)
        	id = id + 1
      	end
    end
end

function game.drawTextures(pMap, pTableTextures, pTilesheet)
	----Drawing the actual textures "cut" off the tilesheet
    local c, l
    for l = 1, pMap.MAP_HEIGHT do
      	for c = 1, pMap.MAP_WIDTH do
        	local id = pMap.grid[l][c]
        	local texQuad = pTableTextures[id]
        	if texQuad ~= nil then
            	local x = (c - 1) * pMap.TILE_WIDTH
            	local y = (l - 1) * pMap.TILE_HEIGHT
            	love.graphics.draw(pTilesheet, texQuad, x, y)
       		end
      	end
    end
end

function game.drawFog(pMap, pTableTextures, pTilesheet)
    local c, l
    for l = 1, pMap.MAP_HEIGHT do
      	for c = 1, pMap.MAP_WIDTH do
        	local id = pMap.grid[l][c]
      		local texQuad = pTableTextures[id]
        	if texQuad ~= nil then
            	local x = (c - 1) * pMap.TILE_WIDTH
            	local y = (l - 1) * pMap.TILE_HEIGHT

            	if pMap.fogGrid[l][c] > 0 then
                	love.graphics.setColor(0,0,0, pMap.fogGrid[l][c])
                	love.graphics.rectangle('fill', x, y, pMap.TILE_WIDTH, pMap.TILE_HEIGHT)
                	love.graphics.setColor(255,255,255)
            	end
       		end
      	end
    end
end

------------------------------------------------------------------------------------------------------------------

function game.Load()

   	game.hero.Load()

   	game.music = love.audio.newSource('sounds/cool.mp3', 'stream')
   	game.music:setVolume(0)
   
   	game.tilesheet = love.graphics.newImage('images/tilesheet.png')
   	game.tileTextures[0] = nil

   	game.loadTextures(game.tilesheet, game.tileTextures, game.map)

    --Attributing a name for each used tile (used for the tile mouseover thing in draw and collisions with hero)
    game.map.tileTypes[1] = 'gravel'
    game.map.tileTypes[10] = 'grass'
    game.map.tileTypes[11] = 'grass'
    game.map.tileTypes[13] = 'sand'
    game.map.tileTypes[14] = 'sand'
    game.map.tileTypes[15] = 'sand'
    game.map.tileTypes[19] = 'water'
    game.map.tileTypes[20] = 'water'
    game.map.tileTypes[21] = 'sea'
    game.map.tileTypes[37] = 'lava'
    game.map.tileTypes[55] = 'tree'
    game.map.tileTypes[58] = 'tree'
    game.map.tileTypes[61] = 'tree'
    game.map.tileTypes[68] = 'cactus'
    game.map.tileTypes[129] = 'rock'
    game.map.tileTypes[142] = 'tree'
    game.map.tileTypes[169] = 'rock'
    game.map.tileTypes[76] = 'plague'
    ----

    game.map.loadFog(game.map)
    game.map.clearFog(game.hero.line, game.hero.column)
end

function game.Update(dt)

	game.music:play()

	transition.screenFadeout(dt)
	transition.musicFadeout(dt, game.music, 0.5)

    game.hero.Update(game.map, dt)

   	timer_plague = timer_plague + 1 * (60*dt)
   	if timer_plague >= freq_plague then
   		game.makePlague(game.map)
   		timer_plague = 0
   	end

   	if game.hero.escape == true then
   		game.map.grid = grid2
   	end

    if game.hero.die == true then
		game.music:stop()
		def.current_screen = 'gameover'
	end

end

function game.Draw()

    game.drawTextures(game.map, game.tileTextures, game.tilesheet)
    game.drawFog(game.map, game.tileTextures, game.tilesheet)
	game.hero.Draw(game.map)

    do
    	local padding_bottom = 32
	    ----Printing hero stats and inventory
	    local str_wood = "LIFE : " .. tostring(game.hero.energy)
	    love.graphics.print(str_wood, 32, def.SCREEN_HEIGHT - padding_bottom, 0, 1.5, 1.5)

	    local str_stats = "WOOD : " .. tostring(game.hero.wood)
	    love.graphics.print(str_stats, 142, def.SCREEN_HEIGHT - padding_bottom, 0, 1.5, 1.5)

	    local str_bucket = "WATER BUCKET : " .. tostring(game.hero.bucket)
	    love.graphics.print(str_bucket, 274, def.SCREEN_HEIGHT - padding_bottom, 0, 1.5, 1.5)
	    ----
	end

	transition.drawFadeout()

end

return game