local Vector = require "vector"
local Utility = require "utility"

local Input = {}

function Input.getMouseCoords()
	return Vector(love.mouse.getX(),love.mouse.getY())
end

function Input.getSelectedTile()
	return Board.screenToMap(Input.getMouseCoords())
end

function Input.update()
	local mx,my = love.mouse.getX(), love.mouse.getY()

	if not love.mouse.isDown(1) then
		local dest = Board.screenToMap(Input.getMouseCoords())
		if Characters[turnNum].beingDragged and dest:distance(Characters[turnNum].pos)==1 and Board.isInBounds(dest) and turnState == "move" then
			Characters[turnNum].pos = Board.screenToMap(Input.getMouseCoords())		
			turnState = "selectCard"
		end
		Characters[turnNum].beingDragged = false
	end
end

function love.mousepressed(x,y,button,istouch,presses)
	if button==1 then

		local mapCoords = Board.screenToMap(Input.getMouseCoords())
		if Board.isInBounds(mapCoords) then
			Input.tileClicked(mapCoords)
		end

		local selectedCard = UI.getSelectedCard(Characters[turnNum].deck)
		if selectedCard~=nil and (turnState == "selectCard" or turnState == "move") then
			Characters[turnNum].castingCard = selectedCard --Start casting spell
			selectedCard.toRemove = true
			turnState = "specifyCast"
		end

	end
end

function Input.tileClicked(tile)
	if tile:matches(Characters[turnNum].pos) and turnState == "move" then
		Characters[turnNum].beingDragged = true
	end

	if turnState == "specifyCast" then
		local charPos = Characters[turnNum].pos
		if Characters[turnNum].castingCard.castInputType == "shoot" then
			if Board.tileMeetsCriteria(tile,{Board.isInShootingRange,Board.isInBounds}) then
				local charPos = Characters[turnNum].pos
				local args = {
				tile = charPos:add(tile:take(charPos):normalise()),
				caster = Characters[turnNum],
				}
				Entities.addEntity("fireball",args)
				turnState = "updateEntities"
			end
		end
	end
end

return Input