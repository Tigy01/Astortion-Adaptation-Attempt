@tool
extends Control

var process_script = preload("res://addons/PixelMapGenerator/Astortion Pixel Processor.gd").new()

var pathToFile

func ProcessSelectFile():
	if pathToFile!= null:
		process_script.processAssets(pathToFile)
		var scan = load("res://addons/PixelMapGenerator/ScanFileSystem.gd").new()
		scan.scan()
	else:
		print('no file selected')

func _on_file_dialog_file_selected(path):
	pathToFile = path
	$"VBoxContainer/File Select Button".text = ('Select File: ' + path.substr(0,35)+ '...')

func _on_file_select_button_pressed():
	$SelectReferenceFile.show()
