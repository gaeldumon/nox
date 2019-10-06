love.graphics.setDefaultFilter('nearest')

local def = require('define')
local game = require('game')
local menu = require('menu')
local gameover = require('gameover')

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function love.load()
	def.current_screen = 'menu'
	menu.load()
  	game.load()
  	gameover.load()
end

function love.update(dt)
	if def.current_screen == 'menu' then
		menu.update(dt)
	elseif def.current_screen == 'game' then
		game.update(dt)
	end
end

function love.draw()
	if def.current_screen == 'menu' then
		menu.draw()
	elseif def.current_screen == 'game' then
		game.draw()
	elseif def.current_screen == 'gameover' then
		gameover.draw()
	end
end

function love.keypressed(key)
	if def.current_screen == 'menu' then
		menu.keypressed(key)
	end
end
