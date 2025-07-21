extends Node2D

@onready var loot_tables: Node = %LootTables
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var hud: CanvasLayer = %HUD

var fishing_ui = preload("res://scenes/fishing_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Specific Item actions
	if Input.is_action_just_pressed("fishing") and game_manager.selected_item() == "fishing_rod" and not game_manager.in_menu:
		var temp = fishing_ui.instantiate()
		hud.add_child(temp)
	
	if Input.is_action_just_pressed("reg_click") and game_manager.selected_item() == "trash" and not game_manager.in_menu:
		game_manager.add_item(loot_tables.get_loot(loot_tables.trash_loot_table), 1)
		game_manager.remove_item("trash", 1)
