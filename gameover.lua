local def = require('define')

local this = {}

function this.load()
	this.text = {
		{"You may avoid\nthis kind of ground."},
		{"You were going to die\n no matter what anyway."},
		{"Maybe if you put\na little more effort..."},
		{"We are all to blame."},
		{"It is too late,\nwe are doomed."}
	}

	this.rand_n = love.math.random(1, #this.text)
	this.rand_x = love.math.random(10, def.SCREEN_WIDTH/1.5)
	this.rand_y = love.math.random(10, def.SCREEN_HEIGHT/1.5)

   	this.font = love.graphics.newFont('assets/fonts/sixty.ttf', 400)
end

function this.draw()
    love.graphics.setColor(def.color.dark_red)
    love.graphics.print(this.text[this.rand_n], this.rand_x, this.rand_y)
    love.graphics.setColor(1,1,1)
end

return this