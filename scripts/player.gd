extends CharacterBody2D

var character_direction : Vector2
@export var speed = 90000  # Adjust speed as needed

func _physics_process(delta):

	#All Movement
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down"):
		character_direction.x = Input.get_axis("move_left", "move_right")
		character_direction.y = Input.get_axis("move_up", "move_down")
		character_direction = character_direction.normalized()
		
		velocity = character_direction * speed * delta
	
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide()
	
	
