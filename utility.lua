local Vector = require "vector"

local Utility = {}

function Utility.index(list,index) --input: list={a={b={c="cat"}}}; index = "a.b.c" --> output: "cat"
	for sub in string.gmatch(index,'([^.]+)') do
    	list=list[sub]
	end
	return list
end

function Utility.round(x,decimalPlaces)
  local mult = 10^(decimalPlaces or 0) --decimalPlaces default to 0
  return math.floor(x * mult + 0.5) / mult
end

function Utility.findByTag(list,tagName,tagContent) --leave tag content blank to filter for any occurance of the tag
	for i=1,#list do
		local i = list[i]
		if i[tagName] then
			if (tagContent==nil) or (i[tagName]==tagContent) then
				return i
			end
		end
	end
end

function Utility.getQuadratic(d,e,f)
	--Inputs points d,e and f
	--Returns values a,b and c of quadratic formula
	local ma1 = (d[1]-e[1]) / ((e[1]^2)-(d[1]^2))
	local ca1 = (e[2]-d[2]) / ((e[1]^2)-(d[1]^2))

	local ma2 = (e[1]-f[1]) / ((f[1]^2)-(e[1]^2))
	local ca2 = (f[2]-e[2]) / ((f[1]^2)-(e[1]^2))

	local b = (ca2-ca1) / (ma1-ma2)
	local a = ma1*b + ca1
	local c = d[2]-a*d[1]^2-b*d[1]

	return {a=a,b=b,c=c}
end

function Utility.getNeighbours(position)
	local neighbours = {}
	neighbours[1] = position:add(Vector(1,0))
	neighbours[2] = position:add(Vector(-1,0))
	neighbours[3] = position:add(Vector(0,1))
	neighbours[4] = position:add(Vector(0,-1))
	return neighbours
end


return Utility