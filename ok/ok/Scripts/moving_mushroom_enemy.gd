extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var timer: Timer = $Timer

const SPEED = 50
const distance = 100
const gravity = 800
var direction = -1
var start_position = Vector2()

func _ready() -> void:
	start_position = position
	
func _physics_process(delta: float) -> void:
	if not ray_cast_up.is_colliding():
		velocity.y += gravity * delta
	move_and_slide()
	
func _process(delta: float) -> void:
	sprite.play("Run Animation")
	position.x += direction * SPEED * delta
	var offset = position.x - start_position.x
	if abs(offset) >= distance:
		direction = direction * -1
	if direction < 0:
		sprite.flip_h = false
	elif direction > 0:
		sprite.flip_h = true
		
	if ray_cast_left.is_colliding():
		sprite.play("Attack Animation")
		sprite.flip_h = false
		timer.start()

	elif ray_cast_right.is_colliding():
		sprite.play("Attack Animation")
		sprite.flip_h = true
		timer.start()


func _on_timer_timeout() -> void:
	sprite.play("Idle Animation")


func _on_killzone_body_entered(body: Node2D) -> void:
	set_process(false)
	
