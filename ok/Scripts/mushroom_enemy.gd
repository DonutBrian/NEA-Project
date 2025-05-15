extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var timer: Timer = $Timer
@onready var Hitbox: CollisionShape2D = $Killzone/CollisionShape2D
@onready var stun_timer: Timer = $"Stun timer"

func _process(delta: float) -> void:
	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		timer.start()
		if ray_cast_left.is_colliding():
			sprite.play("Attack Animation")
			sprite.flip_h = false
		elif ray_cast_right.is_colliding():
			sprite.play("Attack Animation")
			sprite.flip_h = true	

func _on_timer_timeout() -> void:
	sprite.play("Idle Animation")

func _on_killzone_body_entered(body: Node2D) -> void:
	set_process(false)

func _on_stun_zone_body_entered(body: Node2D) -> void:
	Hitbox.disabled = true		
	set_process(false)
	sprite.play("Stun Animation")
	stun_timer.start()
	Hitbox.disabled = true
	
