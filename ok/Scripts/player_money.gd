extends Label

@onready var player_money: Label = $"."

func _process(delta: float) -> void:
	player_money.text = "Coins:" + str(Global.money)
