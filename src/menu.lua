local def = require('define')

local this = {}

function this.create_rain(p_table)
	local drop = {}
	drop.x = love.math.random(5, def.SCREEN_WIDTH - 5)
	drop.y = 100
	drop.vy = 0
	drop.gravity = 6
	drop.width = 2
	drop.height = love.math.random(2, 10)
	drop.color = {0, 255, 0}
	drop.kill = false

	drop.update = function(dt)
		drop.vy = drop.gravity * (60*dt)
		drop.y = drop.y + drop.vy

		if drop.y > def.SCREEN_HEIGHT then
			drop.kill = true
		end
	end

	drop.draw = function()
		love.graphics.rectangle('fill', drop.x, drop.y, drop.width, drop.height)
	end

	table.insert(p_table, drop)
end

function this.load()
	this.bg = love.graphics.newImage('assets/images/nox-menu.png')
	this.rain = {}
	this.timer = 0
end

function this.update(dt)
	this.timer = this.timer + 1 * (60*dt)

	if this.timer >= 5 then
		this.create_rain(this.rain)
		this.timer = 0
	end

	def.update_sprites(this.rain, dt)
	def.purge_sprites(this.rain)
end

function this.draw()
	love.graphics.draw(this.bg)
	def.draw_sprites(this.rain)
end

function this.keypressed(key)
	if key == 'space' then
		def.current_screen = 'game'
	end
end

return this