@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name():
	return "pixelmap.importer"

func _get_visible_name():
	return "Pixel Map"

func _get_recognized_extensions():
	return ["reference", "ref"]

func _get_save_extension():
	return "png"

func _get_resource_type():
	return "Texture2D"

func _get_preset_count():
	return Presets.size()
	
func _get_preset_name(preset):
	match preset:
		Presets.DEFAULT:
			return[{"name": "use_red_anyway", "default_value": false}]
		_:
			return "Unknown"

func _get_import_options(i,l):
	return true

func _import(source_file, save_path, options, platform_variants, gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FAILED
	else:
		print("this is doing something")
	var tex = Texture2D.new()
	tex.set()
	var filename = save_path + "." + _get_save_extension()
	return ResourceSaver.save(tex, filename)
