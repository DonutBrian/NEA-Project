extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var can_enter_door := true

func _on_body_entered(body: Node2D) -> void:
	
	if not can_enter_door:
		return
	
	can_enter_door = false
	var doorway_angle =  fmod(rotation_degrees , 360)
	var offset = Vector2.ZERO
	
	if abs(doorway_angle) < 10:
		offset = Vector2(-16, 0)
	elif abs(doorway_angle - 180) < 10:
		offset = Vector2(16, 0)
	elif abs(doorway_angle - 90) < 10:
		offset = Vector2(0, -16)
	elif abs(doorway_angle - 270) < 10:
		offset = Vector2(0, 16)
	Global.world_pos[get_tree().current_scene.name] = body.global_position + offset
		
	if Global.world_area == 0:
		call_deferred("Change_scene","res://Scenes/Whispering Grove/Whispering_grove_1.tscn")
		Global.world_area = 1
		
	elif Global.world_area == 1:
		call_deferred("Change_scene","res://Scenes/test.tscn")
		Global.world_area = 0

func Change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
