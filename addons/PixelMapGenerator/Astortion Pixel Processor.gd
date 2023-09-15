@tool
extends Node

var spritePath: String #path to reference sprite. Must use a unique color for every pixel, and attempt to represent geometry between frames by shared points of the same color that move.

func processAssets(path):
	spritePath = path
	print(spritePath)
	var mapPath = spritePath.get_basename() + '.map.' + spritePath.get_extension() #path to reference map. This acts as your template for your lookups later.
	var spriteImage:= getImage(spritePath)
	var mapImage:= getImage(mapPath)
	
	var skinColors: PackedColorArray = makeColorArray(spriteImage)
	var mapColors: PackedColorArray= makeColorArray(mapImage)
	var mapCoords:PackedVector2Array= makeCoordArray(mapImage)
	
	updateSkinColors(mapColors, mapCoords, skinColors)
	finalizeAndExport(spriteImage, skinColors)

func getImage(filePath: String) -> Image: #returns the Image from a texture.
	var fileTexture = load(filePath)
	var fileImage:Image = fileTexture.get_image()
	return fileImage

func makeColorArray(texture: Image) -> Array: #Generates color array for every pixel row by row for every collumn. Left to right top to bottom.
	var ColorData:= []
	for y in texture.get_size().y:
		for x in texture.get_size().x:
			var ImageColor:= texture.get_pixel(x,y) #not in 0-255 format!
			ColorData.append(ImageColor)
	return ColorData

func makeCoordArray(texture: Image) -> Array: #Generates coordinates for every pixel row by row for every collumn. Left to right top to bottom.
	var CoordData:= []
	for y in texture.get_size().y:
		for x in texture.get_size().x:
			CoordData.append(Vector2i(x,y))
	return CoordData

func updateSkinColors(mapColors: Array, mapCoords, skinColors):
	for s in skinColors.size():
		for m in mapColors.size(): 
			if skinColors[s] == mapColors[m]: #compares the color of every pixel on the map to a given skin color
				skinColors[s].r = mapCoords[m].x / 255 #saves the color as the UV coordinate from the map and convers it to a 0-1 color format
				skinColors[s].g = mapCoords[m].y / 255
				skinColors[s].b = 0

func finalizeAndExport(spriteImage, skinColors): #creates a new image the same size as the reference sprite sheet
	var source:= Image.create(spriteImage.get_size().x, spriteImage.get_size().y, false, Image.FORMAT_RGBA8)
	var source_color: Array = [] 
	var color_index:int = 0
	for y in source.get_size().y:
		for x in source.get_size().x:
			source.set_pixel(x,y,skinColors[color_index])
			color_index+=1
	return source
#	var png_path := str(spritePath.get_basename(), ".source.png")
#	source.save_png(png_path)
#	print("Generated: ", png_path)
