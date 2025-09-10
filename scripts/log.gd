extends Area2D

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var raft: TileMapLayer = get_node("/root/Main/Raft")
@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var object_manager: Node2D = get_node("/root/Main/Objects/ObjectManager")
@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var quest_manager: Node = get_node("/root/Main/Managing Nodes/QuestManager")
@onready var outline: Line2D = $Outline

var interactible = false

var spawn_rad = 20

var coords
var target_position
var moving = true

var SPEED = 200

var popup
var e_popup = preload("res://scenes/e_popup.tscn")

var PICKUP_DISTANCE

var mouse_hovering = false



func _ready() -> void:
	PICKUP_DISTANCE = object_manager.PICKUP_DISTANCE
	#Gets random position
	while true:
		var temp_x = randi_range(-spawn_rad, spawn_rad)
		var temp_y = randi_range(-spawn_rad, spawn_rad)
		var dist_from_player = Vector2(game_manager.player_coords).distance_to(Vector2(temp_x, temp_y))
		if Vector2i(temp_x, temp_y) not in raft.get_used_cells() and dist_from_player > 10.0:
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
	if Input.is_action_just_pressed("pick_up") and interactible and game_manager.selected_item() not in item_database.activ:
		object_manager.objects.erase(self)
		game_manager.add_item("wood", 1)
		object_manager.num_wood -= 1
		if moving:
			object_manager.start_next_log_timer()
		quest_manager.item_picked_up("wood")
		self.queue_free()
		
	#Movement Logic
	if moving:
		position = position.move_toward(self.target_position, SPEED*delta)
	
	#Interactible logic
	if not interactible and mouse_hovering and self not in object_manager.objects and self.position.distance_to(player.position) <= PICKUP_DISTANCE and game_manager.selected_item() not in item_database.activ:
		object_manager.objects.append(self)
	if interactible and self in object_manager.objects and not mouse_hovering or self.position.distance_to(player.position) > PICKUP_DISTANCE:
		interactible = false
		object_manager.objects.erase(self)
		
	#Outline logic
	if interactible:
		self.outline.visible = true
	elif self.outline.visible == true:
		self.outline.visible = false
	


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		moving = false

func _on_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		moving = true


func _on_mouse_entered() -> void:
	mouse_hovering = true


func _on_mouse_exited() -> void:
	mouse_hovering = false
