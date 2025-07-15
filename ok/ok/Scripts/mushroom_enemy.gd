extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var Hitbox: CollisionShape2D = $Killzone/CollisionShape2D
@onready var stun_timer: Timer = $"Stun timer"
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_up: RayCast2D = $RayCastUp

func _process(delta: float) -> void:
	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		timer.start()
		if ray_cast_left.is_colliding():
			sprite.play("Attack Animation")
			sprite.flip_h = false
			
		elif ray_cast_right.is_colliding():
			sprite.play("Attack Animation")
			sprite.flip_h = true	
	elif ray_cast_up.is_colliding():
		sprite.play("Stun Animation")
		ray_cast_up.disable = true
		stun_timer.start()
		
func _on_timer_timeout() -> void:
	sprite.play("Idle Animation")

func _on_killzone_body_entered(body: Node2D) -> void:
	set_process(false)

func _on_stun_timer_timeout() -> void:
	sprite.play("Idle Animation")
	ray_cast_up.disable = false	
