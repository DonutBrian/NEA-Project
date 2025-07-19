extends Label

@onready var player_money: Label = $"."

func _process(_delta: float) -> void:
	player_money.text = "Coins:" + str(Global.money)
