local def = require('define')

local tr = {}
tr.fadeoutAlpha = 1
tr.fadeinAlpha = 0

function tr.musicFadeout(dt, pMusic, pMaxVolume)
	local vol = pMusic:getVolume()
	if vol < pMaxVolume then
		vol = vol + (60*dt) / 600
	else
		vol = pMaxVolume
	end
	pMusic:setVolume(vol)
end

function tr.screenFadeout(dt)
	if tr.fadeoutAlpha > 0 then
		tr.fadeoutAlpha = tr.fadeoutAlpha - (60*dt) / 200
 	else
		tr.fadeoutAlpha = 0
	end
end

function tr.musicFadeIn(dt, pMusic)
	local vol = pMusic:getVolume()
	if vol > 0 then
		vol = vol - (60*dt) / 600
	else
		vol = 0
		pMusic:stop()
	end
	pMusic:setVolume(vol)
end

function tr.screenFadeIn(dt)
	if tr.fadeinAlpha < 1 then
		tr.fadeinAlpha = tr.fadeinAlpha + (60*dt) / 200
 	else
		tr.fadeinAlpha = 1
	end
end

function tr.drawFadeout()
	love.graphics.setColor(0,0,0, tr.fadeoutAlpha)
	love.graphics.rectangle('fill', 0, 0, def.SCREEN_WIDTH, def.SCREEN_HEIGHT)
	love.graphics.setColor(1,1,1,1)
end

function tr.drawFadein()
	love.graphics.setColor(0,0,0, tr.fadeinAlpha)
	love.graphics.rectangle('fill', 0, 0, def.SCREEN_WIDTH, def.SCREEN_HEIGHT)
	love.graphics.setColor(1,1,1,1)
end

return tr