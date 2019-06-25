local Vector = require "vector"
local Board = require "board"
local Characters = require "characters"
local Cards = require "cards"
local Class = require "class"
local UI = require "ui"
local Input = require "input"

local entities = {}
local ui = {}

local macroState = "inGame"
turnNum = 1
local updateNum = 0 --is 0 when not updating
local animTimer = 0

local font = love.graphics.newFont("assets/fonts/Roboto-Regular.ttf", 48)

function love.load()
	Characters.load()
	Board.load()
	love.window.setFullscreen(true)
	love.graphics.setFont(font)
	arrow = UI.arrow(Vector(0,100),Vector(100,100),100,10,30,40)
end

function love.draw()
	Board.draw()
	Characters.draw()
	--UI stuff:
	UI.drawDeck(Characters[turnNum].deck)
	arrow.stop=getMouseCoords()
	arrow:update()
	arrow:draw()
end

function love.update(dt)
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		if mouseWasUp then
			local mapCoords = screenToMap(getMouseCoords())
			if mapCoords:matches(Characters[turnNum].pos) then
				Characters[turnNum].beingDragged = true
			end
		end
		mouseWasUp = false
	else
		if not mouseWasUp then
			local dest = screenToMap(getMouseCoords())
			if Characters[turnNum].beingDragged and dest:distance(Characters[turnNum].pos)==1 and isInBounds(dest) then
				Characters[turnNum].pos = screenToMap(getMouseCoords())
				Characters[turnNum].beingDragged = false
			end
		end
		mouseWasUp = true
	end

	Input.update()
	UI.update(dt)
end