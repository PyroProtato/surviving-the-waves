extends StaticBody2D

@onready var hud: CanvasLayer = get_node("/root/Main/HUD")
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var block_manager: Node = $".."
@onready var timer: Timer = $Timer
@onready var item_timer: Timer = $ItemTimer

var id = "campfire"

var interactible = false
var interactible_init = false
var in_own_menu = false

var e_popup = preload("res://scenes/e_popup.tscn")
var curr_popup

var block_ui = preload("res://scenes/campfire_ui.tscn")
var campfire_data = [[null,null], [null,null], [null,null], 0, 0, false, 0]

var nothing_smelting = true


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if self not in block_manager.blocks:
		interactible = false
	
	#Handles openeing and closing UI
	if interactible and Input.is_action_just_pressed("interact") and not in_own_menu and not game_manager.in_menu:
		var ui = block_ui.instantiate()
		ui.data = campfire_data
		ui.block_ref = self
		hud.add_child(ui)
		game_manager.pause_game()
		in_own_menu = true
	elif in_own_menu and Input.is_action_just_pressed("interact"):
		in_own_menu = false
	
	#popup
	if self.interactible_init == false and self.interactible:
		self.interactible_init = true
		curr_popup = e_popup.instantiate()
		add_child(curr_popup)
	elif self.interactible_init == true and not self.interactible:
		self.interactible_init = false
		curr_popup.queue_free()
	
	
	#Handles timer
	#Checks whether there is still an item
	if campfire_data[0] == [null, null]:
		campfire_data[5] = false
		campfire_data[3] = 0.0
		campfire_data[4] = 0.0
		timer.stop()
		item_timer.stop()
		nothing_smelting = true
	
	if campfire_data[5] and nothing_smelting:
		timer.start(campfire_data[3])
		item_timer.start()
		nothing_smelting = false
	
	if campfire_data[5]:
		campfire_data[3] = timer.time_left
		campfire_data[4] = item_timer.time_left
		
		#When fuel timer runs out
		if campfire_data[3] == 0.0:
			if campfire_data[0][0] != null and campfire_data[1][1] != null:
				timer.start(campfire_data[3])
				campfire_data[6] = item_database.fuel[campfire_data[1][0]]
				campfire_data[3] = float(item_database.fuel[campfire_data[1][0]])
				campfire_data[1][1] -= 1
			else:
				campfire_data[5] = false
				campfire_data[3] = 0.0
				campfire_data[4] = 0.0
				timer.stop()
				item_timer.stop()
				nothing_smelting = true
			
	if campfire_data[5]:
		#When item timer runs out
		if campfire_data[4] == 0.0:
			if campfire_data[2] == [null, null]:
				campfire_data[2] = [item_database.smeltable[campfire_data[0][0]], 1]
				campfire_data[0][1] -= 1
			else:
				campfire_data[2][1] += 1
				campfire_data[0][1] -= 1
			if campfire_data[0][0] != null and (campfire_data[1][1] != null or campfire_data[3] != 0.0) and campfire_data[0][1] != 0:
				item_timer.start()
			else:
				campfire_data[5] = false
				campfire_data[3] = 0.0
				campfire_data[4] = 0.0
				timer.stop()
				item_timer.stop()
				nothing_smelting = true
				
		


func delete():
	game_manager.add_item(id, 1)
	queue_free()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	#interactible = true
	block_manager.blocks.append(self)
	
	


func _on_area_2d_area_exited(_area: Area2D) -> void:
	#interactible = false
	block_manager.blocks.erase(self)
	
