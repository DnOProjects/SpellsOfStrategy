local Vector = require "vector"
local Characters = require "characters"

local Input = {}

function Input.update()
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		if mouseWasUp then
			local mapCoords = screenToMap(getMouseCoords())
			if mapCoords:matches(Characters[turnNum].pos) then
				Characters[turnNum].beingDragged = true
			end
		end
		mouseWasUp = false
	else
		if not mouseWasUp then
			local dest = screenToMap(getMouseCoords())
			if Characters[turnNum].beingDragged and dest:distance(Characters[turnNum].pos)==1 and isInBounds(dest) then
				Characters[turnNum].pos = screenToMap(getMouseCoords())
				Characters[turnNum].beingDragged = false
			end
		end
		mouseWasUp = true
	end
end

function getMouseCoords()
	return Vector(love.mouse.getX(),love.mouse.getY())
end

return Input