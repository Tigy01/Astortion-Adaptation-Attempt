@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = load("res://addons/PixelMapGenerator/ProcessAsset.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
	queue_free()
