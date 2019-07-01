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

function Board.drawHighlight(position,color)
	if color=="green" then love.graphics.setColor(0,1,0) end
	love.graphics.rectangle("line",position[1]*board.tileSize+5,position[2]*board.tileSize+5,board.tileSize-10,board.tileSize-10)
	love.graphics.setColor(1,1,1)
end

function Board.screenToMap(point)
	return Vector(math.floor(point[1]/board.tileSize),math.floor(point[2]/board.tileSize))
end

function Board.mapToScreen(point,center)
	local center = center or false
	local point = Vector(point[1]*board.tileSize,point[2]*board.tileSize)
	if center then
		point = point:add(Vector(board.tileSize,board.tileSize):scale(0.5))
	end
	return point
end

function Board.isInBounds(point) 
	if point[1]>0 and point[1]<=board.size[1] and point[2]>0 and point[2]<=board.size[2] then
		return true
	end
	return false
end

return Board