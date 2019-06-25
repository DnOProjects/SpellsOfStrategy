local Assets = {}

function Assets.getImage(name)
	return Assets.images[name]
end

Assets.images={}
	Assets.images.chiSticker=love.graphics.newImage("assets/images/chiSticker.png")

return Assets