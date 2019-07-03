local Vector = require "vector"
local Utility = require "utility"
local Images = require "images"

local Board = {}

function Board.load()
	board = {}
	board.size = Vector(17,9)
	board.tileSize = 100
end

function Board.draw()
	for x=1,board.size[1] do
		for y=1,board.size[2] do
			love.graphics.setColor(0.5,0.5,0.5)
			love.graphics.draw(Images.tiles.stoneBrick.image,x*board.tileSize,y*board.tileSize)
			love.graphics.setColor(1,1,1,0.3)
			love.graphics.rectangle("line",x*board.tileSize,y*board.tileSize,board.tileSize,board.tileSize)
			love.graphics.setColor(1,1,1)
		end
	end
end

function Board.drawHighlight(position,color)
	if color=="green" then love.graphics.setColor(0,1,0) end
	if color=="red" then love.graphics.setColor(1,0,0) end
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

function Board.drawHighlightsWhere(criteria,color)
	for x=1,board.size[1] do
		for y=1,board.size[2] do
			local tile = Vector(x,y)
			if Board.tileMeetsCriteria(tile,criteria) then
				Board.drawHighlight(tile,color)
			end
		end
	end	
end

function Board.tileMeetsCriteria(tile,criteria)
	local failed = false
	for i=1,#criteria do
		failed = failed or (not criteria[i](tile))
	end
	return not failed
end

-- Tile check functions:

function Board.isInShootingRange(tile)
	local charPos = Characters[turnNum].pos
	if (charPos[1]==tile[1] or charPos[2]==tile[2]) and not(charPos:matches(tile)) then
		return true
	end
	return false
end

function Board.isInBounds(tile) 
	if tile[1]>0 and tile[1]<=board.size[1] and tile[2]>0 and tile[2]<=board.size[2] then
		return true
	end
	return false
end

return Board