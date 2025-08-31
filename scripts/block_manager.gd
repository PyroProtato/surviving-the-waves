extends Node


@onready var game_manager: Node2D = %GameManager
@onready var item_database: Node = %ItemDatabase
@onready var raft: TileMapLayer = %Raft
@onready var tool_tip: CanvasLayer = $ToolTip
@onready var placing_tool_tip: CanvasLayer = $"../Objects/ObjectManager/PlacingToolTip"

@onready var player: CharacterBody2D = %Player

@onready var place_block_sound: AudioStreamPlayer = get_node("/root/Main/Managing Nodes/SoundManager/PlaceBlockSound")
@onready var break_block_sound: AudioStreamPlayer = get_node("/root/Main/Managing Nodes/SoundManager/BreakBlockSound")

var blocks = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Determines which block is interactible
	if blocks.size() > 0 and not game_manager.in_menu:
		tool_tip.visible = true
		var closest = blocks[0]
		var closest_dist = blocks[0].position.distance_to(player.position)
		for block in blocks:
			var dist = block.position.distance_to(player.position)
			if dist < closest_dist:
				closest = block
				closest_dist = dist
		
		for block in blocks:
			if block == closest:
				block.interactible = true
			else:
				block.interactible = false
	else:
		tool_tip.visible = false
				
	#Destroying blocks/tiles
	var cell_pos = raft.local_to_map(raft.get_global_mouse_position())
	if not game_manager.in_menu and Input.is_action_just_pressed("destroy") and game_manager.selected_item() == "pickaxe":
		if raft.get_cell_tile_data(cell_pos) != null:
			if cell_pos in raft.occupied_tiles:
				#if raft cell has an object
				for child in get_children():
					if child is StaticBody2D and child.position == Vector2(cell_pos.x*128+64, cell_pos.y*128+64):
						child.delete()
						raft.occupied_tiles.erase(cell_pos)
						break_block_sound.play()
			elif cell_pos in raft.player_occupied_tiles:
				pass
			else:
				#If raft pos doesn't have an object
				raft.delete_cell(cell_pos)
				break_block_sound.play()
	
	
	#Placing blocks
	if not game_manager.in_menu and Input.is_action_just_pressed("place") and item_database.blocks.has(game_manager.selected_item()):
		if raft.get_cell_tile_data(cell_pos) != null and cell_pos not in raft.occupied_tiles:
			var current_selected_item = game_manager.selected_item()
			if game_manager.remove_item(current_selected_item, 1):
				var block_b = item_database.blocks[current_selected_item].instantiate()
				block_b.position = cell_pos*128
				block_b.position.x += 64
				block_b.position.y += 64
				place_block_sound.play()
				add_child(block_b)
				raft.occupied_tiles.append(cell_pos)
	
	#tooltip
	if item_database.blocks.has(game_manager.selected_item()) and raft.get_cell_tile_data(cell_pos) != null and cell_pos not in raft.occupied_tiles and not game_manager.in_menu:
		placing_tool_tip.visible = true
	else:
		placing_tool_tip.visible = false
	
	
		
		
		
