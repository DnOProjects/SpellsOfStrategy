local Vector = require "vector"
local Board = require "board"
local Characters = require "characters"
local Cards = require "cards"
local Class = require "class"
local UI = require "ui"
local Input = require "input"
local Utility = require "utility"

local entities = {}
local ui = {}

local macroState = "inGame"
turnNum = 1
local updateNum = 0 --is 0 when not updating
local animTimer = 0

function love.load()
	UI.load()
	Characters.load()
	Board.load()
	arrow = UI.arrow(Vector(0,100),Vector(100,100),100,10,30,40)
end

function love.draw()
	Board.draw()
	Characters.draw()
	--UI stuff:
	UI.drawDeck(Characters[turnNum].deck)
	arrow.stop=Utility.getMouseCoords()
	arrow:update()
	arrow:draw()
end

function love.update(dt)
	Input.update()
	UI.update(dt)
	Characters.update(dt)
end