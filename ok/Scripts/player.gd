extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $"Node/Dash timer"
@onready var dash_particles: GPUParticles2D = $"Dash Particles"
@onready var attack_area: Area2D = $"Attack Area"
@onready var attack_CD: Timer = $"Node/Attack CD"
@onready var attack_timer: Timer = $"Node/Attack timer"

var dash_speed = 500
var dash_duration = 0.4
var is_dashing = false
var dash_direction = Vector2.ZERO
var attack_cooldown = 0.5
var attacking = false
var abs_velocity_x = abs(velocity.x)
var attack_offset_left: = Vector2(-12,0)
var attack_offset_right = Vector2(12,0)

func _ready() -> void:
	dash_timer.connect("timeout", _on_dash_timer_timeout)
	var scene_name = get_tree().current_scene.name
	if Global.world_pos.has(scene_name):
		global_position = Global.world_pos[scene_name]

func _physics_process(delta: float) -> void:

	# Adds gravity to the player preventing floating
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Allows for the player to Jump as well as Double jump if they press again
	if is_on_floor():
		Global.jump_count = 0
	if Input.is_action_just_pressed("Jump") and Global.jump_count < Global.max_jump:
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

	if Input.is_action_just_pressed("Attack") and attacking == false:
		attacking = true
		attack_area.monitoring = true
		attack_timer.start()
		attack_CD.start()
	character_sprite(direction)

	move_and_slide()

func start_dash(input_dir: float) -> void:
	is_dashing = true
	dash_direction = Vector2(input_dir, 0).normalized()
	dash_timer.start(dash_duration)
	dash_particles.rotation_degrees = 180 if input_dir < 0 else 0
	dash_particles.restart()

func _on_dash_timer_timeout() -> void:
	is_dashing = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Breakable"):
		body.break_apart()
		print("scoob")
		
	if body.is_in_group("Enemies"):
		body.hit()
		
func change_sprite(animation:String) -> void:
	sprite.play(animation)


func _on_attack_cd_timeout() -> void:
	attacking = false

func _on_attack_timer_timeout() -> void:
	attack_area.monitoring = false

func character_sprite(direction:float) -> void:

	if direction > 0:
		sprite.flip_h = false
		attack_area.position = attack_offset_right

	elif direction < 0:
		sprite.flip_h = true
		attack_area.position = attack_offset_left

	if Global.hurt == 1:
		change_sprite("Hurt Animation")

	elif attacking == true:
		change_sprite("new_animation")

	else:
		if is_on_floor():
			if direction != 0:
				if abs_velocity_x < 150:
					change_sprite("Run animation")
				else:
					change_sprite("Sprint animation")
			elif Input.is_action_pressed("Sit"):
				change_sprite("Sit animation")
			else:
				change_sprite("Idle animation")
		elif not is_on_floor() and velocity.y < 0:
			change_sprite("Jump animation")
		else:
			change_sprite("Falling animation")
			
