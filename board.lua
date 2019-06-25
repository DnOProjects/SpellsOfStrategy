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

return Board