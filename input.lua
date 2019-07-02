local Vector = require "vector"

local Input = {}

function Input.getMouseCoords()
	return Vector(love.mouse.getX(),love.mouse.getY())
end

function Input.getSelectedTile()
	return Board.screenToMap(Input.getMouseCoords())
end

function Input.update()
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		local mapCoords = Board.screenToMap(Input.getMouseCoords())
		Input.tileClicked(mapCoords)
	else
		local dest = Board.screenToMap(Input.getMouseCoords())
		if Characters[turnNum].beingDragged and dest:distance(Characters[turnNum].pos)==1 and Board.isInBounds(dest) then
			Characters[turnNum].pos = Board.screenToMap(Input.getMouseCoords())			
		end
		Characters[turnNum].beingDragged = false
	end
end

function Input.tileClicked(tile)
	if tile:matches(Characters[turnNum].pos) then
		Characters[turnNum].beingDragged = true
	end
	if turnState == "specifyCast" then
		local charPos = Characters[turnNum].pos
	end
end

return Input