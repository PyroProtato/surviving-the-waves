extends StaticBody2D

@onready var hud: CanvasLayer = get_node("/root/Main/HUD")
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var block_manager: Node = $".."

var id = "campfire"

var interactible = false
var interactible_init = false
var in_own_menu = false

var e_popup = preload("res://scenes/e_popup.tscn")
var curr_popup

var chest_ui = preload("res://scenes/campfire_ui.tscn")


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if self not in block_manager.blocks:
		interactible = false
	
	#Handles openeing and closing UI
	if interactible and Input.is_action_just_pressed("interact") and not in_own_menu:
		var ui = chest_ui.instantiate()
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
		


func delete():
	game_manager.add_item(id, 1)
	queue_free()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	#interactible = true
	block_manager.blocks.append(self)
	
	


func _on_area_2d_area_exited(_area: Area2D) -> void:
	#interactible = false
	block_manager.blocks.erase(self)
	
