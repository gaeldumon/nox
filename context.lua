local def = require('define')

local this = {}

function this.load()
	this.text = {
		"An 2046.\n"..
		"Une substance appelee le NOX, pleut sur la Terre.\n".. 
		"Elle ne laisse derriere elle qu'une surface seche, verte et sans vie.\n"..
		"Chaque demie seconde, une parcelle est contaminee par le NOX et marcher dessus est synonyme de mort.\n"..
		"La seule issue de cet enfer est de s'enfuir vers une zone non pluvieuse.\n"..
		"L'acces a cette zone ne peut se faire que par la zone de lave en fusion, plus a l'Est.\n\n"..
		"Saurez vous sauver votre peau ?\n\n"..
		"TOUCHES : E pour couper et verser - F pour fabriquer - Fleches pour se deplacer.\n\n"..
		"Bonne chance. Appuyez sur ENTRER."
	}

	this.font = love.graphics.newFont('assets/fonts/sixty.ttf', 35)
	this.sound_rain = love.audio.newSource('assets/sounds/rain.mp3', 'stream')
	this.sound_rain:isLooping(true)
end

function this.update(dt)
	this.sound_rain:play()
end

function this.draw()
	love.graphics.setFont(this.font)
	love.graphics.setColor(def.color.grey)
	love.graphics.printf(this.text, 100, 90, 800, 'center')
	love.graphics.setColor(1,1,1)
end

function this.keypressed(key)
	if key == 'return' then
		this.sound_rain:stop()
		def.current_screen = 'game'
	end
end

return this