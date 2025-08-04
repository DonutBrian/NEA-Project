extends Node2D

func _ready() -> void:
	Global.last_scene_path = get_tree().current_scene.scene_file_path
	print(Global.last_scene_path)
