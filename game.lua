local def = require('define')
local transition = require('transition')
local hero = require('hero')

local this = {}

this.map = {}
this.map.grid = {}
this.map.fogGrid = {}
this.tilesheet = nil
this.tileTextures = {}
this.map.tileTypes = {}

this.map.grid = {
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

--[[this.map.grid2 = {
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
}]]

this.map.grid2 = {
    { 76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 15,15,15,68,14,11,11,11,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,14,14,14,13,13,13,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,14,14,14,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,14,14,14,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,15,15,15,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,15,15,15,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,15,15,15,10,10,10,13,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,15,15,13,13,13,13,13,10,55,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,14,15,15,13,10,10,10,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 14,15,15,15,13,10,10,10,10,10,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,15,15,15,13,10,10,10,10,10,10,10,10,10,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,14,14,14,14,14,14,14,14,14,14,14,14,14,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,37,14,14,14,14,14,14,14,14,14,14,14,14,14,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,37,37,19,19,19,19,19,19,19,19,19,19,19,19,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,37,37,37,20,20,20,20,20,20,20,20,20,20,20,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,37,37,37,21,21,21,21,21,21,21,21,21,21,21,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 },
    { 37,37,37,37,21,21,21,21,21,21,21,21,21,21,21,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76,76 }
}


this.map.fogGrid = {}

this.map.MAP_WIDTH = 32
this.map.MAP_HEIGHT = 23
this.map.TILE_WIDTH = 32
this.map.TILE_HEIGHT = 32

-----------------------------------------------HOMEMADE FUNCTIONS--------------------------------------------------

function this.map.isSolid(pID)
    local tileType = this.map.tileTypes[pID]
    if tileType == 'sea' or tileType == 'tree' or tileType == 'cactus' or tileType == 'rock' then
        return true
    end

    return false
end

function this.map.isTree(pID)
    local tileType = this.map.tileTypes[pID]
    if tileType == 'tree' then
        return true
    end

    return false
end

function this.map.isWater(pID)
    local tileType = this.map.tileTypes[pID]
    if tileType == 'water' then
        return true
    end

    return false
end

function this.map.isCactus(pID)
    local tileType = this.map.tileTypes[pID]
    if tileType == 'cactus' then
        return true
    end

    return false
end

function this.map.isLava(pID)
    local tileType = this.map.tileTypes[pID]
    if tileType == 'lava' then
        return true
    end

    return false
end

function this.map.isPlague(pID)
    local tileType = this.map.tileTypes[pID]
    if tileType == 'plague' then
        return true
    end

    return false
end

function this.map.loadFog(pMap)
	local l,c
    for l = 1, pMap.MAP_HEIGHT do
        pMap.fogGrid[l] = {}
        for c = 1, pMap.MAP_WIDTH do
            pMap.fogGrid[l][c] = 1
        end
    end
end

function this.map.clearFog(pLine, pCol)
	local fog_radius = 5
    local c,l
    for l = 1, this.map.MAP_HEIGHT do
        for c = 1, this.map.MAP_WIDTH do
            if l > 0 and l <= this.map.MAP_HEIGHT and c > 0 and c <= this.map.MAP_WIDTH then
                local dist = math.dist(c, l, pCol, pLine)
                if dist < fog_radius then
                    local alpha = dist / fog_radius
                    if this.map.fogGrid[l][c] > alpha then
                        this.map.fogGrid[l][c] = alpha
                    end
                end
            end
        end
    end
end

----Generate a "plague" tile at random coordinates
function this.makePlague(pMap)
    local random_line = love.math.random(1, pMap.MAP_HEIGHT)
    local random_col = love.math.random(1, pMap.MAP_WIDTH)
    if pMap.grid[random_line][random_col] ~= 76 then
        pMap.grid[random_line][random_col] = 76
    end
end

function this.map.mouseover(pMap)
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

function this.loadTextures(pTilesheet, pTableTextures, pMap)
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

function this.drawTextures(pMap, pTableTextures, pTilesheet)
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

function this.drawFog(pMap, pTableTextures, pTilesheet)
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

function this.load()

   	hero.load()

   	this.font = love.graphics.newFont('assets/fonts/sixty.ttf', 40)

   	this.timer_plague = 0
	this.freq_plague = 30
	this.sound_plague = love.audio.newSource('assets/sounds/plague.mp3', 'static')

   	this.music = love.audio.newSource('assets/sounds/cool.mp3', 'stream')
   	--Volume is set to zero cause musicFadeout in transition.lua will take care of putting the sound up
   	this.music:setVolume(0)
   
   	this.tilesheet = love.graphics.newImage('assets/images/tilesheet.png')
   	this.tileTextures[0] = nil

   	this.loadTextures(this.tilesheet, this.tileTextures, this.map)

    --Attributing a name for each used tile (used for the tile mouseover thing in draw and collisions with hero)
    this.map.tileTypes[1] = 'gravel'
    this.map.tileTypes[10] = 'grass'
    this.map.tileTypes[11] = 'grass'
    this.map.tileTypes[13] = 'sand'
    this.map.tileTypes[14] = 'sand'
    this.map.tileTypes[15] = 'sand'
    this.map.tileTypes[19] = 'water'
    this.map.tileTypes[20] = 'water'
    this.map.tileTypes[21] = 'sea'
    this.map.tileTypes[37] = 'lava'
    this.map.tileTypes[55] = 'tree'
    this.map.tileTypes[58] = 'tree'
    this.map.tileTypes[61] = 'tree'
    this.map.tileTypes[68] = 'cactus'
    this.map.tileTypes[129] = 'rock'
    this.map.tileTypes[142] = 'tree'
    this.map.tileTypes[169] = 'rock'
    this.map.tileTypes[76] = 'plague'
    ----

    this.map.loadFog(this.map)
    this.map.clearFog(hero.line, hero.column)
end

function this.update(dt)

	this.music:play()

	transition.screenFadeout(dt)
	transition.musicFadeout(dt, this.music, 0.5)

    hero.update(this.map, dt)

   	this.timer_plague = this.timer_plague + (60*dt)
   	if this.timer_plague >= this.freq_plague then
   		this.makePlague(this.map)
   		this.timer_plague = 0
   	end

   	if hero.escape == true then
   		this.map.grid = this.map.grid2
   	end

    if hero.die == true then
		this.music:stop()
		def.current_screen = 'gameover'
	end

end

function this.draw()

    this.drawTextures(this.map, this.tileTextures, this.tilesheet)
    if hero.escape == false then
    	this.drawFog(this.map, this.tileTextures, this.tilesheet)
    end
	hero.draw(this.map)

    do
    	local padding_bottom = 40
    	local padding_left = 20

    	love.graphics.setFont(this.font)

    	love.graphics.setColor(def.color.grey)
	    ----Printing hero stats and inventory
	    local str_wood = "Life : " .. tostring(hero.energy)
	    love.graphics.print(str_wood, padding_left, def.SCREEN_HEIGHT - padding_bottom)

	    local str_stats = "Wood : " .. tostring(hero.wood)
	    love.graphics.print(str_stats, padding_left*10, def.SCREEN_HEIGHT - padding_bottom)

	    local str_bucket = "Water Bucket : " .. tostring(hero.bucket)
	    love.graphics.print(str_bucket, padding_left*20, def.SCREEN_HEIGHT - padding_bottom)
	    ----
	    love.graphics.setColor(1,1,1)
	end

	transition.drawFadeout()
end

return this