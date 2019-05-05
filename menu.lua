local menu = {}

local rain = {}
counter = 0

function CreateDrops()
	local drop = {}
	drop.x = love.math.random(GAME_WIDTH / 2 - 200, GAME_WIDTH / 2 + 200)
	drop.y = 0
	drop.vy = 0
	drop.speed = 2
	drop.width = 2
	drop.height = 10
	drop.color = {0, 255, 0}

	table.insert(rain, drop)
end

function menu.Load()
	menu.img = love.graphics.newImage('images/nox-menu.png')
end

function menu.Update(dt)
	counter = counter + 1 * (60*dt)

	if counter >= 5 then
		CreateDrops()
		counter = 0
	end

	local i
	for i, drop in ipairs(rain) do
		drop.vy = drop.speed * (60*dt)
		drop.y = drop.y + drop.vy
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