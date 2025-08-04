extends Label

@onready var player_UI: Label = $"."

func _process(_delta: float) -> void:
	player_UI.text = "Health:" + str(Global.player_health) + "\nCoins:" + str(Global.money)


	
