extends Node2D

var log_scene = preload("res://scenes/log.tscn")
var object_scene = preload("res://scenes/object.tscn")
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var wood_timer: Timer = $WoodTimer
@onready var tool_tip: CanvasLayer = $ToolTip
@onready var background: TileMapLayer = %Background

var WOOD_LIMIT = 200000
var num_wood = 0

var objects = []

const PICKUP_DISTANCE = 400

var lastlog = null
var started_next_log = false

var specific_tooltip = null
var tooltip_scene = preload("res://scenes/tool_tip.tscn")
var tooltip_item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Interactible logic
	if objects.size() > 0 and not game_manager.in_menu:
		tool_tip.visible = true
		var top_object = null
		var top_index = -1
		for object in objects:
			var index = self.get_children().find(object)
			if index > top_index:
				top_index = index
				top_object = object
		for object in objects:
			if object == top_object:
				object.interactible = true
			else:
				object.interactible = false
	else:
		tool_tip.visible = false
	
	#Delay
	if lastlog != null:
		if lastlog.moving == false and wood_timer.is_stopped():
			start_next_log_timer()
	if started_next_log:
		if game_manager.in_menu == true:
			wood_timer.paused = true
		else:
			wood_timer.paused = false
	
	
	#Specific Item Tooltips
	if not game_manager.in_menu:
		var selected_item = game_manager.selected_item()
		
		if selected_item == "fishing_rod": #Fishing rod specifically
			if specific_tooltip == null and background.get_cell_tile_data(background.local_to_map(background.get_global_mouse_position())) != null:
				add_mouse_tool_tip(selected_item)
			elif specific_tooltip != null and background.get_cell_tile_data(background.local_to_map(background.get_global_mouse_position())) == null:
				specific_tooltip.queue_free()
				specific_tooltip = null
		
				
		elif specific_tooltip == null and item_database.specific_tooltips.has(selected_item):
			add_mouse_tool_tip(selected_item)
			
		if specific_tooltip != null and tooltip_item != selected_item:
			specific_tooltip.queue_free()
			specific_tooltip = null
		


func add_mouse_tool_tip(item):
	tooltip_item = item
	specific_tooltip = tooltip_scene.instantiate()
	specific_tooltip.text = item_database.specific_tooltips[item]
	specific_tooltip.key_path = "res://assets/images/mouse.png"
	specific_tooltip.index = 2
	specific_tooltip.side = 1
	add_child(specific_tooltip)


func _on_wood_timer_timeout() -> void:
	if not num_wood >= WOOD_LIMIT:
		lastlog = log_scene.instantiate()
		add_child(lastlog)
		num_wood += 1


func summon_generic_object(id, texture_path, pos):
	var temp = object_scene.instantiate()
	temp.id = id
	temp.texture = texture_path
	temp.coords = pos
	add_child(temp)
	

func start_next_log_timer():
	started_next_log = true
	wood_timer.start(randi_range(2, 5))
