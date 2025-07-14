extends Area2D

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var raft: TileMapLayer = get_node("/root/Main/Raft")

var interactible = false

var spawn_rad = 10

var coords
var target_position

var SPEED = 60

func _ready() -> void:
	#Gets random position
	while true:
		var temp_x = randi_range(-spawn_rad, spawn_rad)
		var temp_y = randi_range(-spawn_rad, spawn_rad)
		#print(raft.)
		if Vector2i(temp_x, temp_y) not in raft.get_used_cells():
			#Sets position
			self.coords = Vector2(temp_x, temp_y)
			break
	
	#Sets position and rotation
	self.position = self.coords*128
	self.rotation_degrees = randi_range(0, 360)
	
	#Gets the position to move toward
	self.target_position = raft.get_used_cells().pick_random()*128
	
	
	
	
	

func _process(delta: float) -> void:
	#Pick Up Logic
	if Input.is_action_just_pressed("pick_up") and interactible:
		self.queue_free()
		game_manager.wood += 1
		
	#Movement Logic
	position = position.move_toward(self.target_position, SPEED*delta)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		interactible = true

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		interactible = false
