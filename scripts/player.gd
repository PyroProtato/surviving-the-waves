extends CharacterBody2D

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

var character_direction : Vector2
@export var speed = 90000  # Adjust speed as needed

@onready var interact_hitbox: CollisionShape2D = $Area2D/CollisionShape2D

func _physics_process(delta):
	if game_manager.in_menu == false:

		#All Movement
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down"):
			character_direction.x = Input.get_axis("move_left", "move_right")
			character_direction.y = Input.get_axis("move_up", "move_down")
			character_direction = character_direction.normalized()
			
			velocity = character_direction * speed * delta
		
		else:
			velocity = Vector2(0, 0)
		
		move_and_slide()
		
		
		#Moves the hitbox
		if Input.is_action_just_pressed("move_up"):
			interact_hitbox.position = Vector2(0, -150)
			interact_hitbox.rotation_degrees = -180
		if Input.is_action_just_pressed("move_left"):
			interact_hitbox.position = Vector2(-100, 0)
			interact_hitbox.rotation_degrees = -270
		if Input.is_action_just_pressed("move_down"):
			interact_hitbox.position = Vector2(0, 150)
			interact_hitbox.rotation_degrees = 0
		if Input.is_action_just_pressed("move_right"):
			interact_hitbox.position = Vector2(100, 0)
			interact_hitbox.rotation_degrees = -90
	
	
