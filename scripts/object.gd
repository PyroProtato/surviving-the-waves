extends Area2D

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var raft: TileMapLayer = get_node("/root/Main/Raft")
@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var object_manager: Node2D = get_node("/root/Main/Objects/ObjectManager")
@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var outline: Line2D = $Outline
@onready var sprite_2d: Sprite2D = $Sprite2D

var interactible = false

var spawn_rad = 20

var coords
var id
var texture

var popup
var e_popup = preload("res://scenes/e_popup.tscn")

var PICKUP_DISTANCE

var mouse_hovering = false

const optimal_width = 128
const optimal_height = 128

func _ready() -> void:
	PICKUP_DISTANCE = object_manager.PICKUP_DISTANCE
	
	#Sets position and rotation
	self.position = coords
	self.rotation_degrees = randi_range(0, 360)
	
	#Sets texture
	sprite_2d.texture = load(texture)
	var nwidth = sprite_2d.texture.get_width()
	var mult = optimal_width/float(nwidth)
	sprite_2d.scale = sprite_2d.scale*mult
	
	
	
	
	
	

func _process(_delta: float) -> void:
	#Pick Up Logic
	if Input.is_action_just_pressed("pick_up") and interactible and game_manager.selected_item() not in item_database.activ:
		object_manager.objects.erase(self)
		game_manager.add_item(id, 1)
		self.queue_free()
		
	
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
	



func _on_mouse_entered() -> void:
	mouse_hovering = true


func _on_mouse_exited() -> void:
	mouse_hovering = false
