local this = {}

this.current_screen = 'menu'
this.SCREEN_WIDTH = love.graphics.getWidth()
this.SCREEN_HEIGHT = love.graphics.getHeight()

function this.update_sprites(p_table, dt)
	local n
	for n, sprite in ipairs(p_table) do
		if sprite.update(dt) ~= nil and sprite.kill == false then
			sprite.update(dt)
		end
	end
end

----Kills all sprites so best suited for screen leaving for example
function this.kill_sprites(p_table)
	local n
	for n, sprite in ipairs(p_table) do
		if sprite.kill == false then
			sprite.kill = true
		end
	end
end

function this.purge_sprites(p_table)
	local n
	for n, sprite in ipairs(p_table) do
		if sprite.kill == true then
			table.remove(p_table, n)
		end
	end
end

function this.draw_sprites(p_table)
	local n
	for n, sprite in ipairs(p_table) do
		if sprite.draw() ~= nil and sprite.kill == false then
			sprite.draw()
		end
	end
end


return this

