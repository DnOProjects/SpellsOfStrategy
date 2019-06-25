local Vector = require "vector"
local Character = require "character"
local Cards = require "cards"
local Class = require "class"
local UI = require "ui"

board = {}
board.size = Vector(16,8)
board.tileSize = 100

characters = {Character(1,1)}

local entities = {}
local ui = {}

local macroState = "inGame"
turnNum = 1
local updateNum = 0 --is 0 when not updating
local animTimer = 0

local font = love.graphics.newFont("assets/fonts/Roboto-Regular.ttf", 48)

function love.load()
	for i=1,8 do 
		characters[1]:addToDeck("fireball")
	end
	love.window.setFullscreen(true)
	love.graphics.setFont(font)
	arrow = UI.arrow(Vector(0,100),Vector(100,100),100,10,30,40)
end

function love.draw()
	for x=1,board.size[1] do
		for y=1,board.size[2] do
			love.graphics.rectangle("line",x*board.tileSize,y*board.tileSize,board.tileSize,board.tileSize)
		end
	end
	for i=1,#characters do
		local c = characters[i]
		love.graphics.circle("fill",(c.pos[1]+0.5)*board.tileSize,(c.pos[2]+0.5)*board.tileSize,board.tileSize/2)
	end

	--UI stuff:
	UI.drawDeck(characters[turnNum].deck)
	arrow.stop=getMouseCoords()
	arrow:update()
	arrow:draw()
end

local mouseWasUp = true

function love.update(dt)
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if love.mouse.isDown(1) then
		if mouseWasUp then
			local mapCoords = screenToMap(getMouseCoords())
			if mapCoords:matches(characters[turnNum].pos) then
				characters[turnNum].beingDragged = true
			end
		end
		mouseWasUp = false
	else
		if not mouseWasUp then
			local dest = screenToMap(getMouseCoords())
			if characters[turnNum].beingDragged and dest:distance(characters[turnNum].pos)==1 and isInBounds(dest) then
				characters[turnNum].pos = screenToMap(getMouseCoords())
				characters[turnNum].beingDragged = false
			end
		end
		mouseWasUp = true
	end

	UI.update(dt)

end

function getMouseCoords()
	return Vector(love.mouse.getX(),love.mouse.getY())
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

function makeMove(characterNum,moveData)
	if characterNum==turnNum then

	end
end