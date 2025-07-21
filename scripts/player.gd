extends CharacterBody2D

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raft: TileMapLayer = %Raft
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

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
		
		#Updates occupied tiles
		raft.player_occupied_tiles = []
		var coord_rect = collision_shape_2d.shape.get_rect()
		coord_rect.size *= 0.5
		coord_rect.position = position
		coord_rect.position.x -= coord_rect.size.x/2
		var topleft_coords = raft.local_to_map(coord_rect.position)
		var bottomright_coords = raft.local_to_map(coord_rect.end)
		var topright_coords = Vector2i(bottomright_coords.x, topleft_coords.y)
		var bottomleft_coords = Vector2i(topleft_coords.x, bottomright_coords.y)
		
		raft.player_occupied_tiles.append(topleft_coords)
		raft.player_occupied_tiles.append(topright_coords)
		raft.player_occupied_tiles.append(bottomright_coords)
		raft.player_occupied_tiles.append(bottomleft_coords)
		
		
		
		
		#Animations
		var walking_a_direction = false
		if Input.is_action_pressed("move_up"):
			animated_sprite.play("upward_walk")
			walking_a_direction = true
			animated_sprite.flip_h = false
		if Input.is_action_pressed("move_down"):
			animated_sprite.play("downward_walk")
			walking_a_direction = true
			animated_sprite.flip_h = false
		if Input.is_action_pressed("move_left"):
			animated_sprite.play("horizontal_walk")
			walking_a_direction = true
			animated_sprite.flip_h = false
		if Input.is_action_pressed("move_right"):
			animated_sprite.play("horizontal_walk")
			walking_a_direction = true
			animated_sprite.flip_h = true
		if walking_a_direction == false:
			animated_sprite.play("idle")
		
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
	
	else:
		#When in menu
		animated_sprite.play("idle")
	
