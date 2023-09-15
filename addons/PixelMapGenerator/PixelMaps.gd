@tool
extends EditorPlugin
var Dock

func _enter_tree():
	Dock = preload("res://addons/PixelMapGenerator/ProcessAsset.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, Dock)

func _exit_tree():
	remove_control_from_docks(Dock)
	Dock.free()
	queue_free()
