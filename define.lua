local this = {}

this.current_screen = 'menu'
this.SCREEN_WIDTH = love.graphics.getWidth()
this.SCREEN_HEIGHT = love.graphics.getHeight()

this.color = {}
this.color.white = {1,1,1}
this.color.black = {0,0,0}
this.color.grey = {0.5,0.5,0.5}
this.color.red = {1,0,0}
this.color.dark_red = {188/255, 24/255, 9/255}
this.color.green = {0,1,0}
this.color.blue = {0,0,1}
this.color.sun_yellow = {244/255, 240/255, 2/255}
this.color.brown = {102/255, 51/255, 0}
this.color.startrek_blue = {101/255,117/255,166/255}
this.color.nox_green = {41/255,189/255,69/255}

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

