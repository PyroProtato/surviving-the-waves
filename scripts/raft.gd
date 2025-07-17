extends TileMapLayer

@onready var background: TileMapLayer = %Background
@onready var game_manager = get_node("/root/Main/Managing Nodes/GameManager")

const RAFT_ATLAS = Vector2(2, 3)
const WATER_ATLAS = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Placing a raft tile
	if Input.is_action_just_pressed("place"):
		if game_manager.remove_item("raft", 1):
			var mousePos = get_global_mouse_position()
			var cellPos = self.local_to_map(mousePos)
					
			self.set_cell(cellPos, 0, RAFT_ATLAS)
			background.set_cell(cellPos, 0)
		
	#Deleting a raft tile
	if Input.is_action_just_pressed("destroy"):
		var mousePos = get_global_mouse_position()
		var cellPos = self.local_to_map(mousePos)
				
		self.set_cell(cellPos, 0)
		background.set_cell(cellPos, 0, WATER_ATLAS)
