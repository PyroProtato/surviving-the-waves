extends StaticBody2D

@onready var hud: CanvasLayer = %HUD
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

var interactible = false
var in_crafting_table = false

var crafting_table_ui = preload("res://scenes/crafting_table_ui.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	
	#Handles openeing and closing UI
	if interactible and Input.is_action_just_pressed("interact") and not in_crafting_table:
		var ui = crafting_table_ui.instantiate()
		hud.add_child(ui)
		game_manager.in_menu = true
		in_crafting_table = true
	elif in_crafting_table and Input.is_action_just_pressed("interact"):
		in_crafting_table = false
	
	



func _on_area_2d_area_entered(area: Area2D) -> void:
	interactible = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	interactible = false
