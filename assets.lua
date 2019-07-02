local Assets = {}

function Assets.getImage(name)
	return Assets.images[name]
end

Assets.images={}
	Assets.images.chiSticker=love.graphics.newImage("assets/images/chiSticker.png")
	Assets.images.stoneBrick=love.graphics.newImage("assets/images/stoneBrick.png")

return Assets