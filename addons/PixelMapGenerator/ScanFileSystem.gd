@tool
extends EditorScript

func scan():
	get_editor_interface().get_resource_filesystem().scan()
