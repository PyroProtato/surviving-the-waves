extends CanvasLayer

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var recipe_node: Node = get_node("/root/Main/Managing Nodes/Recipes")
@onready var box_container: VBoxContainer = $ScrollContainer/VBoxContainer

var recipe_scene = preload("res://scenes/recipe.tscn")

var recipe_button = preload("res://scenes/recipe_button.tscn")

var current_recipe_scene



var recipes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.recipes = recipe_node.recipes
	
	self.new_recipe_shown(recipes[0])
	
	var temp
	for recipe in recipes:
		temp = recipe_button.instantiate()
		temp.data = recipe
		box_container.add_child(temp)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Exiting
	if Input.is_action_just_pressed("interact"):
		game_manager.unpause_game()
		self.queue_free()
		
		
		
#Activates a new recipe
func new_recipe_shown(recipe):
	if current_recipe_scene != null:
		current_recipe_scene.queue_free()
	current_recipe_scene = recipe_scene.instantiate()
	current_recipe_scene.data = recipe
	add_child(current_recipe_scene)
