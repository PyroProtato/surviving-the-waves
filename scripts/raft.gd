extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Placing a raft tile
	if Input.is_action_just_pressed("place"):
		var mousePos = get_global_mouse_position()
		var cellPos = self.local_to_map(mousePos)
		
		var newAtlasCoords = Vector2(2, 3)
		
		self.set_cell(cellPos, 0, newAtlasCoords)
