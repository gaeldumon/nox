local def = require('define')

local gameover = {}

function gameover.Draw()
    love.graphics.setColor(223,0,0)
    love.graphics.print("YOU DEAD !", def.SCREEN_WIDTH / 2 - 200, def.SCREEN_HEIGHT / 2, 0, 5, 5)
    love.graphics.setColor(255,255,255)
end

return gameover