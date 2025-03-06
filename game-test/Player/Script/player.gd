class_name Player extends CharacterBody2D

var move_speed : float = 100.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	direction.y = Input.get_action_raw_strength("up") - Input.get_action_raw_strength("down")
	
	velocity = direction * move_speed * delta
	pass
