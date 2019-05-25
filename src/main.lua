io.stdout:setvbuf('no')
love.graphics.setDefaultFilter('nearest')

local def = require('define')
local game = require('game')
local menu = require('menu')
local gameover = require('gameover')

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function love.load()
	def.current_screen = 'menu'
	menu.Load()
  	game.Load()
end

function love.update(dt)
	if def.current_screen == 'menu' then
		menu.Update(dt)
	elseif def.current_screen == 'game' then
		game.Update(dt)
	end
end

function love.draw()
	if def.current_screen == 'menu' then
		menu.Draw()
	elseif def.current_screen == 'game' then
		game.Draw()
	elseif def.current_screen == 'gameover' then
		gameover.Draw()
	end
end

function love.keypressed(key)
	if def.current_screen == 'menu' then
		if key == 'space' then
			def.current_screen = 'game'
		end
	end
end
