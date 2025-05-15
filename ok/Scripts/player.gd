extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $"Dash timer"
@onready var dash_particles: GPUParticles2D = $"Dash Particles"

var dash_speed = 500
var dash_duration = 0.4
var is_dashing = false
var dash_direction = Vector2.ZERO

func _ready() -> void:
	dash_timer.connect("timeout", _on_dash_timer_timeout)

func _physics_process(delta: float) -> void:
	
	# Adds gravity to the player preventing floating
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Allows for the player to Jump as well as Double jump if they press again
	if is_on_floor():
		Global.jump_count = 0
	if Input.is_action_just_pressed("Jump") and Global.jump_count < Global.MAX_JUMP:
		velocity.y = Global.JUMP_VELOCITY 
		Global.jump_count += 1
		
	var direction := Input.get_axis("Left", "Right")
	
	# Start Dash
	if Input.is_action_just_pressed("Dash") and !is_dashing and direction != 0:
		start_dash(direction)

	# While dashing
	if is_dashing:
		velocity.x = dash_direction.x * dash_speed
	else:
		# Regular movement
		if direction:
			if Input.is_action_pressed("Sprint"):
				velocity.x = direction * (Global.SPEED + 70)
			else:
				velocity.x = direction * Global.SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, Global.SPEED)


		# Jump
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = Global.JUMP_VELOCITY

		
		
		
		

	# Flips the sprite based on the direction the character is facing
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if Global.hurt == 1:
		sprite.play("Hurt Animation")
	else:
		if is_on_floor():
			if direction != 0:
				var abs_velocity_x = abs(velocity.x)
				if abs_velocity_x < 150:
					sprite.play("Run animation")
				else:
					sprite.play("Sprint animation")
			elif Input.is_action_pressed("Sit"):
				sprite.play("Sit animation")
			else:
				sprite.play("Idle animation")
	#
		elif not is_on_floor() and velocity.y < 0:
			sprite.play("Jump animation")
		else:
			sprite.play("Falling animation")
	move_and_slide()

func start_dash(input_dir: float) -> void:
	is_dashing = true
	dash_direction = Vector2(input_dir, 0).normalized()
	dash_timer.start(dash_duration)
	dash_particles.rotation_degrees = 180 if input_dir < 0 else 0
	dash_particles.restart()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	
