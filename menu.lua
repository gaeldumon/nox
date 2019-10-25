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

	this.text_1 = {}
	this.text_1.x = def.SCREEN_WIDTH/3
	this.text_1.y = def.SCREEN_HEIGHT/3
	this.text_1.msg = "NOX"
	this.text_1.font = love.graphics.newFont('assets/fonts/sixty.ttf', 200)
	this.text_1.color = def.color.nox_green

	this.text_2 = {}
	this.text_2.x = this.text_1.x + def.SCREEN_WIDTH/50
	this.text_2.y = this.text_1.y + def.SCREEN_HEIGHT/3
	this.text_2.msg = "Press ENTER to start"
	this.text_2.font = love.graphics.newFont('assets/fonts/sixty.ttf', 40)
	this.text_2.color = def.color.grey

	this.sound_rain = love.audio.newSource('assets/sounds/rain.mp3', 'stream')
	this.sound_rain:isLooping(true)
end

function this.update(dt)
	this.sound_rain:play()

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

	love.graphics.setFont(this.text_1.font)
	love.graphics.setColor(this.text_1.color)
	love.graphics.print(this.text_1.msg, this.text_1.x, this.text_1.y)

	love.graphics.setFont(this.text_2.font)
	love.graphics.setColor(this.text_2.color)
	love.graphics.print(this.text_2.msg, this.text_2.x, this.text_2.y)
	love.graphics.setColor(1,1,1)
end

function this.keypressed(key)
	if key == 'return' then
		this.sound_rain:stop()
		def.current_screen = 'context'
	end
end

return this