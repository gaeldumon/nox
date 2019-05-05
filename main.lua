io.stdout:setvbuf('no')
love.graphics.setDefaultFilter('nearest')

local game = require('game')
local menu = require('menu')

current_screen = 'menu'

GAME_WIDTH = love.graphics.getWidth()
GAME_HEIGHT = love.graphics.getHeight()

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function love.load()
	menu.Load()
  	game.Load()
end

function love.update(dt)
	if current_screen == 'menu' then
		menu.Update(dt)
	elseif current_screen == 'game' then
		game.Update(dt)
	end
end

function love.draw()
	if current_screen == 'menu' then
		menu.Draw()
	elseif current_screen == 'game' then
		game.Draw()
	end
end

function love.keypressed(key)
	if current_screen == 'menu' then
		if key == 'space' then
			current_screen = 'game'
		end
	end
end
