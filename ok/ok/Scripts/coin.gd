extends Area2D

@onready var coin_id : String = ""

func _ready():
	coin_id = get_tree().current_scene.name + "_" + str(global_position)
	
	if Global.collected_coins.has(coin_id):
		queue_free()
func _on_body_entered(body: Node2D) -> void:
	if not Global.collected_coins.has(coin_id):
		Global.collected_coins[coin_id] = true
		Global.money += 1
		queue_free()
		print(Global.collected_coins)
