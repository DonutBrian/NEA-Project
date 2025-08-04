extends Control

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file(Global.last_scene_path)
