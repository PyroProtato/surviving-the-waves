extends TileMapLayer

@onready var background: TileMapLayer = %Background
@onready var game_manager = get_node("/root/Main/Managing Nodes/GameManager")
@onready var item_database = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var object_manager: Node2D = %ObjectManager
@onready var block_manager = get_node("/root/Main/Blocks")

@onready var place_block_sound: AudioStreamPlayer = get_node("/root/Main/Managing Nodes/SoundManager/PlaceBlockSound")

const RAFT_ATLAS = Vector2(1, 0)
const WATER_ATLAS = Vector2(0, 0)

var occupied_tiles = [Vector2i(-2, -1), Vector2i(1, -1)]
var player_occupied_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Placing a raft tile
	var mousePos = get_global_mouse_position()
	var cellPos = self.local_to_map(mousePos)
	if not game_manager.in_menu and Input.is_action_just_pressed("place") and game_manager.selected_item() == "raft" and self.get_cell_tile_data(cellPos) == null:
		if game_manager.remove_item("raft", 1):
			
			self.set_cell(cellPos, 0, RAFT_ATLAS)
			background.set_cell(cellPos, 0)
			place_block_sound.play()
		
	#Deleting a raft tile
	#if Input.is_action_just_pressed("destroy"):
	#	var mousePos = get_global_mouse_position()
	#	var cellPos = self.local_to_map(mousePos)
				
	#	self.set_cell(cellPos, 0)
	#	background.set_cell(cellPos, 0, WATER_ATLAS)


func delete_cell(cellPos):
	self.set_cell(cellPos, -1)
	background.set_cell(cellPos, 0, WATER_ATLAS)
	game_manager.add_item("raft", 1)

func destroy_cell(cellPos):
	self.set_cell(cellPos, -1)
	background.set_cell(cellPos, 0, WATER_ATLAS)
	for block in block_manager.get_children():
		if block is StaticBody2D and block.position == Vector2(cellPos[0]*128+64, cellPos[1]*128+64):
			object_manager.summon_generic_object(block.id, item_database.paths[block.id], cellPos*128)
			block.queue_free()
	#object_manager.summon_generic_object("raft", item_database.paths["raft"], cellPos*128)
