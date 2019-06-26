local Vector = require "vector"
local Characters = require "characters"
local Utility = require "utility"
local Board = require "board"

local Input = {}

function Input.update()
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		local mapCoords = Board.screenToMap(Utility.getMouseCoords())
		if mapCoords:matches(Characters[turnNum].pos) then
			Characters[turnNum].beingDragged = true
		end
	else
		local dest = Board.screenToMap(Utility.getMouseCoords())
		if Characters[turnNum].beingDragged and dest:distance(Characters[turnNum].pos)==1 and Board.isInBounds(dest) then
			Characters[turnNum].pos = Board.screenToMap(Utility.getMouseCoords())			
		end
		Characters[turnNum].beingDragged = false
	end
end

return Input