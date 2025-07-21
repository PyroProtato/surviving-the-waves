extends CanvasLayer

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Label/Sprite2D

@export var text = ""
@export var key_path = ""
@export var index = 0
@export var side = 2

const Y_OFFSET = -37.5
const TARGET_HEIGHT = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text
	
	var texture = ResourceLoader.load(key_path)
	sprite_2d.texture = texture
	var texture_height = sprite_2d.texture.get_height()
	sprite_2d.scale = sprite_2d.scale * (TARGET_HEIGHT/texture_height)
	
	var texture_width = sprite_2d.texture.get_width()
	texture_height = sprite_2d.texture.get_height()
	sprite_2d.region_enabled = true
	if side == 2:
		sprite_2d.region_rect = Rect2(texture_width/2, 0, texture_width/2, texture_height)
	elif side == 1:
		sprite_2d.region_rect = Rect2(0, 0, texture_width/2, texture_height)
	sprite_2d.position.x = - texture_width/2
	
	label.position.y = 600 + index * Y_OFFSET
	
	
	
