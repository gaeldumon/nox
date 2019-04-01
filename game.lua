local Game = {}

Game.Hero = require('hero')

Game.Map = {}
Game.Map.Grid = {}
Game.Map.FogGrid = {}
Game.tilesheet = nil
Game.TileTextures = {}
Game.Map.TileTypes = {}

Game.Map.Grid = {
    { 10,10,10,10,10,10,10,10,10,61,10,13,10,10,10,10,10,10,13,14,15,15,15,15,15,15,15,15,15,15,15,15   },
    { 10,10,10,10,10,11,11,11,10,10,10,13,10,10,10,10,10,10,10,14,15,15,129,15,15,15,15,15,15,68,15,15  },
    { 10,10,61,10,11,19,19,19,11,10,10,13,10,10,169,10,10,10,10,13,14,15,15,15,15,15,15,15,15,15,15,15  },
    { 10,10,10,11,19,19,19,19,19,11,10,13,10,10,10,10,10,10,10,10,13,14,15,15,15,68,15,15,15,15,15,15   },
    { 10,10,10,11,19,19,19,19,19,11,10,13,10,10,10,10,10,10,61,10,10,14,15,15,15,15,15,15,15,15,15,15   },
    { 10,10,61,10,11,19,19,19,11,10,10,13,10,10,10,10,10,10,10,10,10,14,15,15,129,15,15,15,68,15,129,15 },
    { 10,10,10,10,10,11,11,11,10,10,61,13,10,10,10,10,10,10,10,10,10,14,15,15,15,15,15,15,15,15,15,15   },
    { 13,13,13,13,13,13,13,13,13,13,13,13,10,10,10,10,10,169,10,10,10,13,14,15,15,15,15,15,15,15,15,15  },
    { 10,10,10,10,10,10,10,10,13,10,10,10,10,10,10,10,10,10,10,10,61,10,13,14,14,14,14,14,14,14,15,129  },
    { 10,10,10,10,10,10,10,10,13,55,10,58,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,13,14,14   },
    { 10,10,10,10,10,10,10,10,13,10,10,10,55,10,58,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10   },
    { 10,10,10,10,10,10,10,10,13,10,58,10,10,10,10,10,10,169,10,10,10,10,10,10,61,10,10,10,10,10,1,1    },
    { 10,10,10,10,10,10,10,10,13,10,10,10,58,10,10,10,10,10,10,10,10,61,10,10,10,10,10,10,10,1,37,37    },
    { 10,10,10,10,13,13,13,13,13,10,55,10,10,10,55,10,10,10,10,10,10,10,10,10,10,10,10,1,1,37,37,37     },
    { 10,10,10,10,13,10,10,10,10,10,10,10,55,10,10,10,10,169,10,10,10,10,10,10,10,10,1,37,37,37,37,37   },
    { 10,10,10,10,13,10,10,10,10,142,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,1,37,37,37,37,37,37   },
    { 10,10,10,10,13,10,10,10,10,10,10,10,10,142,10,10,10,10,10,10,10,169,10,10,1,37,37,37,37,37,37,37  },
    { 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,37,37,37,37,37,37,37    },
    { 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,1,37,37,37,37,37,37,37    },
    { 19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,1,37,37,37,37,37,37,37    },
    { 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,1,37,37,37,37,37,37    },
    { 21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,1,37,37,37,37    },
    { 21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,1,37,37,37    }
}

Game.Map.FogGrid = {}

Game.Map.MAP_WIDTH = 32
Game.Map.MAP_HEIGHT = 23
Game.Map.TILE_WIDTH = 32
Game.Map.TILE_HEIGHT = 32

Game.bottomPadding = 32
Game.music = nil
plague_count = 0

function Game.Map.isSolid(pID)
    local tileType = Game.Map.TileTypes[pID]
    if tileType == 'sea' or tileType == 'tree' or tileType == 'cactus' or tileType == 'rock' then
        return true
    end

    return false
end

function Game.Map.isTree(pID)
    local tileType = Game.Map.TileTypes[pID]
    if tileType == 'tree' then
        return true
    end

    return false
end

function Game.Map.isWater(pID)
    local tileType = Game.Map.TileTypes[pID]
    if tileType == 'water' then
        return true
    end

    return false
end

function Game.Map.isCactus(pID)
    local tileType = Game.Map.TileTypes[pID]
    if tileType == 'cactus' then
        return true
    end

    return false
end

function Game.Map.isLava(pID)
    local tileType = Game.Map.TileTypes[pID]
    if tileType == 'lava' then
        return true
    end

    return false
end

function Game.Map.clearFog(pLine, pCol)
    --print("Clear fog!")
    local c,l
    for l = 1, Game.Map.MAP_HEIGHT do
        for c = 1, Game.Map.MAP_WIDTH do
            if l > 0 and l <= Game.Map.MAP_HEIGHT and c > 0 and c <= Game.Map.MAP_WIDTH then
                local dist = math.dist(c, l, pCol, pLine)
                if dist < 5 then
                    local alpha = dist / 5
                    if Game.Map.FogGrid[l][c] > alpha then
                        Game.Map.FogGrid[l][c] = alpha
                    end
                end
            end
        end
    end
end

function Game.Map.plague()
    local random_line = love.math.random(1, Game.Map.MAP_HEIGHT)
    local random_col = love.math.random(1, Game.Map.MAP_WIDTH)
    if Game.Map.Grid[random_line][random_col] ~= 76 then
        Game.Map.Grid[random_line][random_col] = 76
    end
end

function Game.Load()
   Game.Hero.Load()
   
   Game.tilesheet = love.graphics.newImage('images/tilesheet.png')
   Game.TileTextures[0] = nil

   Game.music = love.audio.newSource('sounds/cool.mp3', 'stream')
   Game.music:setVolume(0.5)
   Game.music:play()

    --Reading/cuting each tilesheet tiles one by one : not related to the screen in any way
    local nb_cols = Game.tilesheet:getWidth() / Game.Map.TILE_WIDTH
    local nb_lines = Game.tilesheet:getHeight() / Game.Map.TILE_HEIGHT
    local l,c
    local id = 1
    for l = 1, nb_lines do
      for c = 1, nb_cols do
        Game.TileTextures[id] = love.graphics.newQuad(
          (c - 1) * Game.Map.TILE_WIDTH, 
          (l - 1) * Game.Map.TILE_HEIGHT, 
          Game.Map.TILE_WIDTH, 
          Game.Map.TILE_HEIGHT, 
          Game.tilesheet:getWidth(),
          Game.tilesheet:getHeight()
          )
        id = id + 1
      end
    end
    ----

    print("Game: loading textures...")
    --Attributing a name for each used tile (used for the tile mouseover thing in draw and collisions with Hero)
    Game.Map.TileTypes[1] = 'gravel'
    Game.Map.TileTypes[10] = 'grass'
    Game.Map.TileTypes[11] = 'grass'
    Game.Map.TileTypes[13] = 'sand'
    Game.Map.TileTypes[14] = 'sand'
    Game.Map.TileTypes[15] = 'sand'
    Game.Map.TileTypes[19] = 'water'
    Game.Map.TileTypes[20] = 'water'
    Game.Map.TileTypes[21] = 'sea'
    Game.Map.TileTypes[37] = 'lava'
    Game.Map.TileTypes[55] = 'tree'
    Game.Map.TileTypes[58] = 'tree'
    Game.Map.TileTypes[61] = 'tree'
    Game.Map.TileTypes[68] = 'cactus'
    Game.Map.TileTypes[129] = 'rock'
    Game.Map.TileTypes[142] = 'tree'
    Game.Map.TileTypes[169] = 'rock'
    ----
    print("Game: textures successfuly loaded.")

    print("Game: creation of the fog...")
    Game.Map.FogGrid = {}
    local l,c
    for l = 1, Game.Map.MAP_HEIGHT do
        Game.Map.FogGrid[l] = {}
        for c = 1, Game.Map.MAP_WIDTH do
            Game.Map.FogGrid[l][c] = 1
        end
    end
    print("Game: fog successfuly created")

    Game.Map.clearFog(Game.Hero.line, Game.Hero.column)
end

function Game.Update(dt)
    Game.Hero.Update(Game.Map, dt)
    plague_count = plague_count + 60*dt
    if plague_count >= 60 then
        Game.Map.plague()
        plague_count = 0
    end
end

function Game.Keypressed(key)
end

function Game.Draw()
    ----Drawing the actual textures "cut" off the tilesheet in Game.Load()
    local c, l
    for l = 1, Game.Map.MAP_HEIGHT do
      for c = 1, Game.Map.MAP_WIDTH do
        local id = Game.Map.Grid[l][c]
        local texQuad = Game.TileTextures[id]
        if texQuad ~= nil then
            local x = (c - 1) * Game.Map.TILE_WIDTH
            local y = (l - 1) * Game.Map.TILE_HEIGHT
            love.graphics.draw(Game.tilesheet, texQuad, x, y)
            --Drawing the fog
            if Game.Map.FogGrid[l][c] > 0 then
                love.graphics.setColor(0,0,0, Game.Map.FogGrid[l][c])
                love.graphics.rectangle('fill', x, y, Game.Map.TILE_WIDTH, Game.Map.TILE_HEIGHT)
                love.graphics.setColor(255,255,255)
            end
            ----
        end
      end
    end
    ----

    Game.Hero.Draw(Game.Map)

    ----Tile mouseover thing.
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    --We add one because of 1-based tables in lua (instead of 0)
    local col = math.floor(mouseX / Game.Map.TILE_WIDTH) + 1
    local line = math.floor(mouseY / Game.Map.TILE_HEIGHT) + 1
    if col > 0 and col <= Game.Map.MAP_WIDTH and line > 0 and line <= Game.Map.MAP_HEIGHT then
      local id = Game.Map.Grid[line][col]
      love.graphics.print("Type de tile : ".. tostring(Game.Map.TileTypes[id]) .. " (ID = " .. tostring(id) .. ")", 
        GAME_WIDTH - 200, 
        GAME_HEIGHT - Game.bottomPadding
        )
    else
      love.graphics.print("Hors du tableau !", 
        GAME_WIDTH - 200, 
        GAME_HEIGHT - Game.bottomPadding
        )
    end
    ----

    ----Printing Hero stats and inventory
    local str_wood = "BUCHES DE BOIS : " .. tostring(Game.Hero.wood)
    love.graphics.print(str_wood, 10, GAME_HEIGHT - Game.bottomPadding, 0, 1.5, 1.5)

    local str_stats = "ENERGIE : " .. tostring(Game.Hero.energy)
    love.graphics.print(str_stats, 232, GAME_HEIGHT - Game.bottomPadding, 0, 1.5, 1.5)
    ----
end

return Game