local Vector = require "vector"

local Board = {}

function Board.load()
	board = {}
	board.size = Vector(16,8)
	board.tileSize = 100
end

function Board.draw()
	for x=1,board.size[1] do
		for y=1,board.size[2] do
			love.graphics.rectangle("line",x*board.tileSize,y*board.tileSize,board.tileSize,board.tileSize)
		end
	end
end

function screenToMap(point)
	return Vector(math.floor(point[1]/board.tileSize),math.floor(point[2]/board.tileSize))
end

function isInBounds(point) 
	if point[1]>0 and point[1]<=board.size[1] and point[2]>0 and point[2]<=board.size[2] then
		return true
	end
	return false
end

return Board