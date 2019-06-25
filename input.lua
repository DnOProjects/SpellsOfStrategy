local Vector = require "vector"

local Input = {}

function Input.update()
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		if mouseWasUp then
			local mapCoords = screenToMap(getMouseCoords())
			if mapCoords:matches(characters[turnNum].pos) then
				characters[turnNum].beingDragged = true
			end
		end
		mouseWasUp = false
	else
		if not mouseWasUp then
			local dest = screenToMap(getMouseCoords())
			if characters[turnNum].beingDragged and dest:distance(characters[turnNum].pos)==1 and isInBounds(dest) then
				characters[turnNum].pos = screenToMap(getMouseCoords())
				characters[turnNum].beingDragged = false
			end
		end
		mouseWasUp = true
	end
end

function getMouseCoords()
	return Vector(love.mouse.getX(),love.mouse.getY())
end

return Input