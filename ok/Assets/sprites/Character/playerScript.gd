extends CharacterBody2D
@export var MoveSpeed:float=200
@export var Gravity:float=1300
@export var JumpForce:float=250
@export var JumpTime:float=0.2
@export var Health:float=2

@onready var Sprite:AnimatedSprite2D=$AnimatedSprite2D
@onready var Coll=$CollisionShape2D

signal isAnythingPressed

var isJumping:bool
var isSliding:bool
var JumpTimer:SceneTreeTimer
var CanMove:bool=1
var isDamaged:bool

func _ready():
	GameStart()
	
func _physics_process(delta):
	if not CanMove:
		if Input.is_anything_pressed():
			isAnythingPressed.emit()
	if CanMove:
		if not is_on_floor_only()and not isJumping:
			velocity.y+=Gravity*delta
		if (is_on_wall()) and not isJumping:
			velocity.y=(Gravity/15)
			isSliding=true
		else :
			isSliding=false
		var MoveAxis=Input.get_axis("MoveLeft","MoveRight")
		velocity.x=MoveAxis*MoveSpeed
		if Input.is_action_just_pressed("Jump") and (is_on_floor() or is_on_wall()) :
			JumpTimer=get_tree().create_timer(JumpTime)

		if Input.is_action_pressed("Jump") and JumpTimer.time_left>0:
			velocity.y= -JumpForce
			isJumping=true
		else:isJumping=false
		HandleAnim()
		move_and_slide()
	
func HandleAnim():
	if not velocity.x==0:
		if velocity.x>0:
			Sprite.flip_h=false
		else:
			Sprite.flip_h=true
	if not isDamaged and CanMove:
		if is_on_floor():
			if velocity.x==0:
				Sprite.play("Idle")
			else:Sprite.play("Run")
		elif not is_on_wall():
			if velocity.y>0:
				Sprite.play("Jump")
			if velocity.y<0:
				Sprite.play("Fall")
		elif is_on_wall_only():
			Sprite.play("Slide")
		

#This is Called from the enemy when it collides with the player
func TakeDamage(Damage:float):
	if Health>0:
		print("Took Damage")
		isDamaged=true
		Health-=Damage
		print("You Have:",Health," Health")
		Sprite.play("TakeDamage")
		await Sprite.animation_finished
		isDamaged=false
	
	if Health<1:
		CanMove=false
		print("You Died")
		Sprite.play("Death")
		Coll.disabled=true
		var T=get_tree().create_timer(3)
		await T.timeout
		get_tree().reload_current_scene()
		
#This is Called from the Victory flag when it collides with the player
func Victory():
	print("You Won")
	CanMove=false
	Coll.disabled=true
	Sprite.play("Victory")
	var T=get_tree().create_timer(3)
	await T.timeout
	get_tree().reload_current_scene()


func GameStart():
	CanMove=false
	JumpTimer=get_tree().create_timer(0)#the Jump Timer has to be created in init otherwise there's an error
	await isAnythingPressed
	print("Moving")
	CanMove=true
	
