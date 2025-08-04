extends Area2D

@onready var timer: Timer = $Timer
@onready var box: CollisionShape2D = $CollisionShape2D

func _on_body_entered(_body: Node2D) -> void:
	if Global.player_health > 0:
		print("body entered")
		Global.player_health -= 1
		if Global.player_health <= 0:
			print("SNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKE")
			Global.hurt = 1
			Engine.time_scale = 1
			timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	Global.hurt = 0
	Global.player_health += 3
	get_tree().change_scene_to_file("res://Scenes/UI/Death screen.tscn")
