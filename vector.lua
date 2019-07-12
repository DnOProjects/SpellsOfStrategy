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

--Functions:

	function Vector:intersects(vector) --calculates line intersections given starting and ending points
		if (self[1]>=vector[1] and self[1]<=vector[2]) or (self[2]>=vector[1] and self[2]<=vector[2]) then return true end
		return false
	end

	function Vector:unpack()
		return self[1],self[2]
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

	function Vector:getAdverage(vector)
		return Vector((self[1]+vector[1])/2,(self[2]+vector[2])/2)
	end

	function Vector:polarise()
		local dir = math.atan2(self[2],self[1])
		return {dir=dir,mag=self[1]/math.cos(dir)}
	end

	function Vector:print()
		print(self[1],self[2])
	end

	--Vector operations
	function Vector:add(vector)-- +
		return Vector(self[1]+vector[1],self[2]+vector[2])
	end
	function Vector:take(vector)-- -
		return Vector(self[1]-vector[1],self[2]-vector[2])
	end
	function Vector:matches(vector)-- ==
		if self[1]==vector[1] and self[2]==vector[2] then
			return true
		end
		return false
	end

	--Getting related vectors
	function Vector:getInverted()
		return Vector(-self[1],-self[2])
	end
	function Vector:getNormal() --line perpendicular in gradient
		return Vector(-self[2],self[1])
	end
	function Vector:normalise() --between 0-1
		local d = math.sqrt(self[1]^2+self[2]^2)
		return Vector(self[1]/d,self[2]/d)
	end


	--Rounding functions
	function Vector:abs()
		return Vector(math.abs(self[1]),math.abs(self[2]))
	end
	function Vector:ceil()
		return Vector(math.ceil(self[1]),math.ceil(self[2]))
	end
	function Vector:round(dps) --dps = Decimal PlaceS
		return Vector(Utility.round(self[1],dps),Utility.round(self[2],dps))
	end

return Vector