extends Sprite2D

@onready var title: Label = $Title
@onready var craft_button: Button = $CraftButton
@onready var description: Label = $Description

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var crafting_sound: AudioStreamPlayer = get_node("/root/Main/Managing Nodes/SoundManager/CraftingSound")

var data
var slot = preload("res://scenes/slot.tscn")

const SLOT_HORIZONTAL_OFFSET = 50
const SLOT_WIDTH = 24

const INGREDIENTS_Y = 150
const PRODUCTS_Y = 275

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#All ingredient slots
	var num_ingredients = data[0].size()
	for ingredient_index in range(num_ingredients):
		var slot_ref = slot.instantiate()
		slot_ref.data = self.data[0][ingredient_index]
		slot_ref.position = Vector2(title.position[0] + title.size[0]/2-(num_ingredients-1)*(SLOT_WIDTH + SLOT_HORIZONTAL_OFFSET)/2 + ingredient_index*(SLOT_WIDTH+SLOT_HORIZONTAL_OFFSET), INGREDIENTS_Y)
		add_child(slot_ref)
	
	#All product slots
	var num_products = data[1].size()
	for product_index in range(num_products):
		var slot_ref = slot.instantiate()
		slot_ref.data = self.data[1][product_index]
		slot_ref.position = Vector2(title.position[0] + title.size[0]/2-(num_products-1)*(SLOT_WIDTH + SLOT_HORIZONTAL_OFFSET)/2 + product_index*(SLOT_WIDTH+SLOT_HORIZONTAL_OFFSET), PRODUCTS_Y)
		add_child(slot_ref)
		
	#Sets title
	var title_text = ""
	for product_i in range(data[1].size()):
		if product_i != 0:
			title_text += " + "
		title_text += data[1][product_i][0].capitalize()
	self.title.text = title_text
	
	#Sets Description
	description.text = data[2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:

	#Checks if player has all of the items
	var has_ingredients = true
	for ingredient_data in data[0]:
		if not game_manager.inventory.has(ingredient_data[0]) or game_manager.inventory[ingredient_data[0]] < ingredient_data[1]:
			has_ingredients = false
	
	#Takes ingredients and gives products
	if has_ingredients:
		crafting_sound.play()
		for ingredient_data in data[0]:
			game_manager.remove_item(ingredient_data[0], ingredient_data[1])
		for product_data in data[1]:
			game_manager.add_item(product_data[0], product_data[1])
		
