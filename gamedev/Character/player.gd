extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_velocity : float = -250.0
@export var double_jump_velocity : float = -150.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jump : bool  = false 
var animation_locked : bool = false 
var direction : Vector2  = Vector2.ZERO
var was_in_air : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
	else :
		has_double_jump = false
		
		if was_in_air == true :
			land()
		
		was_in_air = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump from floor
			jump()
			velocity.y = jump_velocity
		elif not has_double_jump:
			# Double jump in air
			velocity.y = double_jump_velocity
			has_double_jump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 && animated_sprite.animation != "jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation()
	update_facing_direction()

func update_animation():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("fall")
		else : 
			if  direction.x != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0 :
		animated_sprite.flip_h  = true

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_start")
	animation_locked = true

func land():
	animated_sprite.play("jump_end")
	animation_locked = true

func _on_animated_sprite_2d_animation_finished() :
	if (animated_sprite.animation == "jump_end"):
		animation_locked = false
