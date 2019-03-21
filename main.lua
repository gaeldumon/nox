io.stdout:setvbuf('no')
love.graphics.setDefaultFilter('nearest')

local myGame = require('game')

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function love.load()
	love.window.setMode(1024, 780)
  
  	GAME_WIDTH = love.graphics.getWidth()
  	GAME_HEIGHT = love.graphics.getHeight()

  	myGame.Load()
end

function love.update(dt)
	myGame.Update(dt)
end

function love.draw()
	myGame.Draw()  
end

function love.keypressed(key)
end