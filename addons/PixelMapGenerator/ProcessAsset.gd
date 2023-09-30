@tool
extends Control

@onready var text_edit = $ColorRect/VBoxContainer/HBoxContainer/TextEdit

var pixel_processor = preload("res://addons/PixelMapGenerator/AstortionPixelProcessor.gd").new()

var path_to_file

func process_selected_file():
	if path_to_file!= null:
		pixel_processor.process_assets(path_to_file)
		pixel_processor.scan()
	else:
		print('no file selected')

func _on_file_dialog_file_selected(path):
	path_to_file = path
	text_edit.text = (path)

func _on_file_select_button_pressed():
	$SelectReferenceFile.show()
