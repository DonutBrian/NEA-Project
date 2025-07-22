extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var Hitbox: CollisionShape2D = $Killzone/CollisionShape2D
@onready var stun_timer: Timer = $"Stun timer"
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var stun_hitbox: CollisionShape2D = $"Stun zone"/CollisionShape2D
@onready var mushroom_enemy: Node2D = $"."
@onready var stun_area: CollisionShape2D = $Area2D/"Stun area"
var health = 50
func _process(_delta: float) -> void:

	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		timer.start()
		if ray_cast_left.is_colliding():
			sprite.play("Attack Animation")
			for child in mushroom_enemy.get_children():
				if child is RayCast2D:
					child.enabled = false
			sprite.flip_h = false

		elif ray_cast_right.is_colliding():
			sprite.play("Attack Animation")
			for child in mushroom_enemy.get_children():
				if child is RayCast2D:
					child.enabled = true
			sprite.flip_h = true	

func _on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	sprite.play("Stun Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = false
	stun_hitbox.set_deferred("disabled", true)
	Hitbox.set_deferred("disabled", true)
	stun_timer.start()

func _on_timer_timeout() -> void:
	sprite.play("Idle Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = true
		stun_hitbox.disabled = false

func _on_killzone_body_entered(_body: Node2D) -> void:
	set_process(false)
	stun_area.set_deferred("disabled", true)

func _on_stun_timer_timeout() -> void:
	sprite.play("Idle Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = true
	stun_hitbox.disabled = false
	Hitbox.disabled = false

func hit():
	print("ahhhhhh")
	if health > 0:
		health -= 25
	elif health	<= 0:
		queue_free()	
