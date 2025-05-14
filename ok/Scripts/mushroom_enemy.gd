extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var timer: Timer = $Timer
@onready var Hitbox: CollisionShape2D = $Killzone/CollisionShape2D

func _process(delta: float) -> void:
	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		timer.start()
		Hitbox.disabled = true	
		if ray_cast_left.is_colliding():
			sprite.play("Attack Animation")
			sprite.flip_h = false
		elif ray_cast_right.is_colliding():
			sprite.play("Attack Animation")
			sprite.flip_h = true	

func _on_timer_timeout() -> void:
	sprite.play("Idle Animation")
	Hitbox.disable = false

func _on_killzone_body_entered(body: Node2D) -> void:
	set_process(false)
