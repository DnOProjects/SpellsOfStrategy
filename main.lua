local Input = require "input"

Utility = require "utility"
Board = require "board"
UI = require "ui"
Characters = require "characters"
Cards = require "cards"
Entities = require "entities"
Vector = require "vector"

--State variables
macroState = "inGame"
turnState = "move"
turnNum = 2
entityUpdating = 1 --index

function love.load()
	UI.load()
	Characters.load()
	Board.load()
end

function love.draw()
	Board.draw()
	Entities.draw()
	Characters.draw()
	UI.draw()
end

function love.update(dt)
	Input.update()
	UI.update(dt)
	Characters.update(dt)
	Entities.update(dt)
end