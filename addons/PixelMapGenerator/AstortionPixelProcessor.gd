@tool
extends EditorScript

var sprite_path: String #path to reference sprite. Must use a unique color for every pixel, and attempt to represent geometry between frames by shared points of the same color that move.

func process_assets(path: String):
	sprite_path = path
	var map_path = sprite_path.get_basename() + '.map.' + sprite_path.get_extension() #path to reference map. This acts as your template for your lookups later.
	var sprite_image:= get_image(sprite_path)
	var map_image:= get_image(map_path)
	
	var skin_colors: PackedColorArray = make_color_array(sprite_image)
	var map_colors: PackedColorArray = make_color_array(map_image)
	var map_coords: PackedVector2Array = make_coord_array(map_image)
	
	update_skin_colors(map_colors, map_coords, skin_colors)
	finalize_and_export(sprite_image, skin_colors)

## Returns the Image from a texture.
func get_image(file_path: String) -> Image: 
	var file_texture: Texture2D = load(file_path)
	var file_image:Image = file_texture.get_image()
	return file_image

## Generates color array for every pixel row by row for every collumn. Left to right top to bottom.
func make_color_array(texture: Image) -> Array: 
	var color_data:= []
	for v in texture.get_size().y:
		for u in texture.get_size().x:
			var image_color:= texture.get_pixel(u,v) #not in 0-255 format!
			color_data.append(image_color)
	return color_data

## Generates coordinates for every pixel row by row for every collumn. Left to right top to bottom.
func make_coord_array(texture: Image) -> Array: 
	var coord_data:= []
	for v in texture.get_size().y:
		for u in texture.get_size().x:
			coord_data.append(Vector2i(u,v))
	return coord_data

## Updates each skin color value to be the cooresponding coordinate on the map
func update_skin_colors(map_colors: Array, map_coords, skin_colors):
	for s in skin_colors.size():
		for m in map_colors.size(): 
			if skin_colors[s] == map_colors[m]: #compares the color of every pixel on the map to a given skin color
				skin_colors[s].r = map_coords[m].x / 255 #saves the color as the UV coordinate from the map and convers it to a 0-1 color format
				skin_colors[s].g = map_coords[m].y / 255
				skin_colors[s].b = 0
## Creates a new image the same size as the reference sprite sheet
func finalize_and_export(sprite_image, skin_colors):
	var source:= Image.create(sprite_image.get_size().x, sprite_image.get_size().y, false, Image.FORMAT_RGBA8)
	var source_color: Array = [] 
	var color_index:int = 0
	for y in source.get_size().y:
		for x in source.get_size().x:
			source.set_pixel(x,y,skin_colors[color_index])
			color_index+=1
	var png_path := str(sprite_path.get_basename(), ".source.png")
	source.save_png(png_path)
	print("Generated: ", png_path)

func scan():
	get_editor_interface().get_resource_filesystem().scan()
