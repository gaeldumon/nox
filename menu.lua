local menu = {}

local rain = {}
counter = 0

function MakeRain()
	local drop = {}
	drop.x = love.math.random(GAME_WIDTH / 2 - 200, GAME_WIDTH / 2 + 200)
	drop.y = 0
	drop.vy = 0
	drop.gravity = 6
	drop.width = 2
	drop.height = 10
	drop.color = {0, 255, 0}
	drop.delete = false

	table.insert(rain, drop)
end

function menu.Load()
	menu.img = love.graphics.newImage('images/nox-menu.png')
end

function menu.Update(dt)
	counter = counter + 1 * (60*dt)

	if counter >= 5 then
		MakeRain()
		counter = 0
	end

	local i
	for i, drop in ipairs(rain) do
		drop.vy = drop.gravity * (60*dt)
		drop.y = drop.y + drop.vy

		if drop.y > GAME_HEIGHT then
			drop.delete = true
			table.remove(rain, i)
		end
	end
end

function menu.Draw()
	love.graphics.draw(menu.img)

	local i
	for i, drop in ipairs(rain) do
		love.graphics.rectangle('fill', drop.x, drop.y, drop.width, drop.height)
	end
end

return menu