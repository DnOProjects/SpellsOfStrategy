local Class = require "class"

local Vector = Class:derive("Vector")

function Vector:new(a,b,isPolar)
	if isPolar then--a=dir, b=mag
		self[1] = math.cos(a)*b
		self[2] = math.sin(a)*b
	else --is cartesian by default (a=x,b=y)
		self[1]=a
		self[2]=b
	end
end

function Vector:intersects(vector) --calculates line intersections given starting and ending points
	if (self[1]>=vector[1] and self[1]<=vector[2]) or (self[2]>=vector[1] and self[2]<=vector[2]) then return true end
	return false
end

function Vector:matches(vector)
	if self[1]==vector[1] and self[2]==vector[2] then
		return true
	end
	return false
end

function Vector:distance(vector)--takes 2 points
	local xDist = math.abs(vector[1]-self[1])
	local yDist = math.abs(vector[2]-self[2])
	return math.sqrt(xDist^2 + yDist^2)
end

function Vector:scale(s)
	return Vector(self[1]*s,self[2]*s)
end

function Vector:getLength()
	return math.sqrt(self[1]^2 + self[2]^2)
end

function Vector:normalise()
	local d = math.sqrt(self[1]^2,self[2]^2)
	assert(d>0)
	return Vector(self[1]/d,self[2]/d)
end

function Vector:getAdverage(vector)
	return Vector((self[1]+vector[1])/2,(self[2]+vector[2])/2)
end

function Vector:add(vector)
	return Vector(self[1]+vector[1],self[2]+vector[2])
end

function Vector:take(vector)
	return Vector(self[1]-vector[1],self[2]-vector[2])
end

function Vector:getNormal()
	return Vector(-self[2],self[1])
end

function Vector:abs()
	return Vector(math.abs(self[1]),math.abs(self[2]))
end

function Vector:getInverted()
	return Vector(-self[1],-self[2])
end

function Vector:polarise()
	local dir = math.atan2(self[2],self[1])
	return {dir=dir,mag=self[1]/math.cos(dir)}
end

function Vector:print()
	print(self[1],self[2])
end

return Vector