extends Node2D

@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var number_label: Label = $NumberLabel
@onready var item_sprite: Sprite2D = $ItemSprite

var data

var texture

const SLOT_SIZE = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Sets texture
	texture = load(item_database.paths[data[0]])
	item_sprite.texture = texture
	
	#Scales Picture
	var scale_factor = SLOT_SIZE/item_sprite.texture.get_size()[0]
	item_sprite.scale = item_sprite.scale*scale_factor
	
	#Sets Text
	number_label.text = str(data[1]) + "x"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
