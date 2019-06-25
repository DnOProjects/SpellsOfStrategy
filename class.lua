local Class = {}

Class.__index = Class

function Class:new() end

function Class:derive(type) --To make a new sub-class (	fruit = Class:derive("Fruit"); apple = fruit:derive("apple")	)
    local cls = {}
    cls["__call"] = Class.__call
    cls.type = type
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)
    return cls
end

function Class:__call(...) --To make an object of a class (apple1 = Apple(); apple2 = Apple())  								
    local inst = setmetatable({}, self)--IMPORTANT: these objects cannot be derived from - only classes
    inst:new(...)
    return inst
end

function Class:getType() --Returns the type of class a class is
    return self.type
end

return Class