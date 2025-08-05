extends Area2D

@onready var death_timer: Timer = $"Death Timer"
@onready var box: CollisionShape2D = $CollisionShape2D
@onready var i_frame: Timer = $"I-Frame"

var player_inside = false
var player_can_take_damage = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = true
		print("yes")
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = false
		print("stop")

func _process(_delta: float) -> void:
	if player_inside == true and player_can_take_damage == true:
		if Global.player_health > 0:
			Global.player_health -= 1
			player_can_take_damage = false
			i_frame.start()
		if Global.player_health <= 0:
			set_process(false)
			print("SNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKE")
			Global.hurt = 1
			Engine.time_scale = 1
			death_timer.start()


func _on_i_frame_timeout() -> void:
	player_can_take_damage = true
	
func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1
	Global.hurt = 0
	Global.player_health += 3
	get_tree().change_scene_to_file("res://Scenes/UI/Death screen.tscn")
