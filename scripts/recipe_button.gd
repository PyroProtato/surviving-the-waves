extends Button

var slot_scene = preload("res://scenes/slot.tscn")
@onready var title: Label = $Title
@onready var crafting_table_ui = get_node("/root/Main/HUD/CraftingTableUI")

var slot

var data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Creates Slot Display
	slot = slot_scene.instantiate()
	slot.data = data[1][0]
	slot.position = Vector2(250, 50)
	add_child(slot)
	
	#Title
	title.text = data[1][0][0].capitalize() + " " + str(data[1][0][1]) + "x"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	crafting_table_ui.new_recipe_shown(data)
