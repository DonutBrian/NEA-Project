extends Area2D

@onready var timer: Timer = $Timer
@onready var box: CollisionShape2D = $CollisionShape2D

func _on_body_entered(_body: Node2D) -> void:
	print("SNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKE")
	Global.hurt = 1
	Engine.time_scale = 1
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	Global.hurt = 0
	get_tree().reload_current_scene()
