extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var counter = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#while Input.is_action_just_pressed("Jump"):
		#counter = counter + 5
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY + counter

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		# Will change the characters speed based on if it is sprinting or not
		if Input.is_action_pressed("Sprint"):
			velocity.x = direction * (SPEED + 70)
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flips the sprite based on the direction the character is facing
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	# Controls what animation will be played depending on the action
	if Global.hurt == 1:
		sprite.play("Hurt Animation")
	else:
		if is_on_floor():
			if direction == 0:
				sprite.play("Idle animation")
			else:
				# If the character is running, depending on if its sprinting or running it will play a different animation
				# Abs ensures that the value is positive so it will change direction no matter the distance
				var abs_velocity_x = abs(velocity.x)
				if abs_velocity_x < 150:
					sprite.play("Run animation")
				else:
					sprite.play("Sprint animation")
	#
		elif not is_on_floor() and velocity.y < 0:
			sprite.play("Jump animation")
		else:
			sprite.play("Falling animation")
	move_and_slide()
