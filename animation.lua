local Class = require "class"
local Animation = Class:derive("Animation")

function Animation:new(parent_sprite,start_frame,end_frame,play_mode,last_frame,fps)
	local fps = fps or 25
	local spf = fps^-1

	self.spf = spf

	--Start/End defaults to First/Last frames
	self.start_frame = start_frame or 1
	self.end_frame = end_frame or #parent_sprite.frames
	self.length = self.end_frame - self.start_frame

	self.play_mode = play_mode or "play" --defaults to play
	self.last_frame = last_frame or self.end_frame --what the frame changes to when the animation ends
	--												 - defaults to the last frame of the animation
end

return Animation