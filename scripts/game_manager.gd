extends Node

@onready var player: CharacterBody2D = %Player

var wood = 10
@onready var wood_label = get_node("/root/Main/HUD/Wood Label")
@onready var raft: TileMapLayer = %Raft

var player_coords

var in_menu = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Set HUD elements
	wood_label.text = "Wood: " + str(wood)
	
	#Player Coords
	self.player_coords = raft.local_to_map(player.position)
