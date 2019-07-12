local Class = require "class"
local Animation = require "animation"
local Sprite = Class:derive("Sprite")
local Images = require "images"

function Sprite:new(imageName,w,h,num_frames)

	local imagedata = Utility.index(Images,imageName)
	
	--If only image supplied, a 1 frame still is assumed
	local num_frames = num_frames or 1
	local w = w or imagedata.w
	local h = h or imagedata.h

	self.imageName = imageName

	self.timer=0
	self.playing_backwards=false
	self.frame_num=1

	self.animations={}
	self.current_animation = "none"


	--Generating list of frames from spritesheet
	self.frames={}
	for y=1,math.floor(imagedata.h/h) do
		for x=1,math.floor(imagedata.w/w) do
			if #self.frames<num_frames then
				self.frames[#self.frames+1]=love.graphics.newQuad((x-1)*w,(y-1)*h,w,h,imagedata.w,imagedata.h)
			end
		end
	end
	self.frame=self.frames[self.frame_num]
end

--only [name] and [play_mode] are mandatory parameters
function Sprite:addAnimation(name,play_mode,start_frame,end_frame,fps,last_frame)--adds an animation to the animations list
	--Play mode options: play, loop, bounce, still(1 frame)
	self.animations[name]=Animation(self,start_frame,end_frame,play_mode,last_frame,fps)
end

function Sprite:setAnimation(name,jump_to_percent)--changes the current animation
	self.current_animation=name
	local animation = self.animations[self.current_animation]

	--If a second arguement is given, the animation starts at that percentage through
	local jump_to_percent = jump_to_percent or 0
	self.frame_num = Utility.round(animation.length*jump_to_percent,0)+animation.start_frame
	self.timer=0
	self.play_mode=animation.play_mode
	self.playing_backwards=(self.play_mode=="backwards_loop")
end

function Sprite:getAnimation()--returns current animation name
	return self.current_animation
end

function Sprite:setFrame(frame_num)
	self.frame_num = frame_num
end

function Sprite:update(dt)
	if self.current_animation ~= "none" and self.play_mode~="still" then
		local animation = self.animations[self.current_animation]
		self.timer = self.timer+dt
		if self.timer>=animation.spf then
			self.timer=animation.spf-self.timer
			if not (self.playing_backwards) then
				self.frame_num=self.frame_num+1
			else
				self.frame_num=self.frame_num-1
			end
			if self.frame_num>animation.end_frame then
				if self.play_mode=="loop" then
					self.frame_num=animation.start_frame
				elseif self.play_mode=="bounce" then
					self.playing_backwards = not (self.playing_backwards)
					self.frame_num=animation.end_frame-1
				else
					self.frame_num = animation.last_frame--going to ending frame of animation
					self.current_animation="none"
				end
			elseif self.frame_num<animation.start_frame and self.playing_backwards then
				if self.play_mode=="backwards_loop" then
					self.frame_num=animation.end_frame
				elseif self.play_mode=="bounce" then
					self.playing_backwards = false
					self.frame_num=animation.start_frame+1
				end
			end
			self.frame=self.frames[self.frame_num]
		end
	end
end

return Sprite