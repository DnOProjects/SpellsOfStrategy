local UI = require "ui"
local Input = require "input"

Board = require "board"
Characters = require "characters"
Cards = require "cards"
Entities = require "entities"

--local entities = {}
--local ui = {}

macroState = "inGame"
turnState = "selectCard"
turnNum = 1
local updateNum = 0 --is 0 when not updating
local animTimer = 0

function love.load()
	UI.load()
	Characters.load()
	Board.load()
end

function love.draw()
	Board.draw()
	Characters.draw()
	UI.draw()
end

function love.update(dt)
	Input.update()
	UI.update(dt)
	Characters.update(dt)
end