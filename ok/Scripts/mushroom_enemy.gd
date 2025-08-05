extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_disable_timer: Timer = $"Timers/Raycast disable timer"
@onready var stun_timer: Timer = $"Timers/Stun timer"
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var stun_hitbox: CollisionShape2D = $"Stun zone"/CollisionShape2D
@onready var mushroom_enemy: Node2D = $"."
@onready var stun_area: CollisionShape2D = $"StaticBody2D/Stun Area"
@onready var death_timer: Timer = $"Timers/Death timer"
@onready var hit_timer: Timer = $"Timers/Hit timer"
@onready var killzone: Area2D = $Killzone

enum State {IDLE, ATTACK, STUNNED, HIT, DEAD}

var health = 50
var state = State.IDLE
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.2
var knockback_timer = 0.0

func _process(_delta: float) -> void:
	
	if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
		raycast_disable_timer.start()
		state = State.ATTACK
		print(state)
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

func _on_stun_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	state = State.STUNNED
	print(state)
	sprite.play("Stun Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = false
	killzone.monitoring = false
	stun_hitbox.set_deferred("disabled", true)
	stun_timer.start()

func _on_killzone_body_entered(_body: Node2D) -> void:
	set_process(false)
	stun_area.set_deferred("disabled", true)

func apply_knockback(direction:Vector2, strength: float):
	knockback_velocity = direction.normalized() * strength
	knockback_timer = knockback_duration

func hit():
	state = State.HIT
	print(state)
	set_process(false)
	hit_timer.start()
	if health > 0:
		health -= 25
		sprite.play("Hit Animation")
		set_process(true)
		state = State.IDLE
	elif health	<= 0:
		death()

func death():
	state = State.DEAD
	print(state)
	death_timer.start()
	sprite.play("Death Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = false

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_stun_timer_timeout() -> void:
	if state == State.DEAD:
		return
	state = State.IDLE
	print(state)
	sprite.play("Idle Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = true
	stun_hitbox.disabled = false
	killzone.monitoring = true

func _on_raycast_disable_timer_timeout() -> void:
	if state == State.DEAD:
		return
	state = State.IDLE
	print(state)
	sprite.play("Idle Animation")
	for child in mushroom_enemy.get_children():
		if child is RayCast2D:
			child.enabled = true
		stun_hitbox.disabled = false

func _on_hit_timer_timeout() -> void:
	if state == State.DEAD:
		return
	state = State.IDLE
	print(state)
	sprite.play("Idle Animation")
