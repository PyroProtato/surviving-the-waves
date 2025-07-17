extends StaticBody2D

@onready var hud: CanvasLayer = %HUD
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var block_manager: Node = $".."

var interactible = false
var interactible_init = false
var in_crafting_table = false

var crafting_table_ui = preload("res://scenes/crafting_table_ui.tscn")

var e_popup = preload("res://scenes/e_popup.tscn")
var popup


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if self not in block_manager.blocks:
		interactible = false
	
	#Handles openeing and closing UI
	if interactible and Input.is_action_just_pressed("interact") and not in_crafting_table:
		var ui = crafting_table_ui.instantiate()
		hud.add_child(ui)
		game_manager.pause_game()
		in_crafting_table = true
	elif in_crafting_table and Input.is_action_just_pressed("interact"):
		in_crafting_table = false
	
	#popup
	if self.interactible_init == false and self.interactible:
		self.interactible_init = true
		popup = e_popup.instantiate()
		add_child(popup)
	elif self.interactible_init == true and not self.interactible:
		self.interactible_init = false
		popup.queue_free()
	
		
		
		
	



func _on_area_2d_area_entered(_area: Area2D) -> void:
	#interactible = true
	block_manager.blocks.append(self)
	
	


func _on_area_2d_area_exited(_area: Area2D) -> void:
	#interactible = false
	block_manager.blocks.erase(self)
	
