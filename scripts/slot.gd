extends Node2D

@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")
@onready var number_label: Label = $NumberLabel
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var cursor_label: Label = $CursorLabel

var data

var texture

var number
var id

signal clicked(slot, side)

var mouse_hovering = false

const SLOT_SIZE = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if data != null:
		update(data[0], data[1])
	else:
		update(null, null)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if mouse_hovering:
		#checks if its clicked
		if Input.is_action_just_pressed("ui_click"):
			emit_signal("clicked", self, "left")
		elif Input.is_action_just_pressed("ui_right_click"):
			emit_signal("clicked", self, "right")
		
		#displays item
		if id != null:
			cursor_label.text = id.replace("_", " ").capitalize()
			cursor_label.global_position = get_viewport().get_mouse_position()
	
		


func update(new_id, new_num):
	#Changes number
	number = new_num
	if number == 0:
		number = null
	if number != null:
		number_label.text = str(new_num) + "x"
	else:
		number_label.text = ""
	
	#Changes texture
	id = new_id
	if number == null:
		id = null
	if id != null:
		item_sprite.scale = Vector2(1, 1)
		texture = load(item_database.paths[id])
		item_sprite.texture = texture
		
		var scale_factor = SLOT_SIZE/item_sprite.texture.get_size()[0]
		item_sprite.scale = item_sprite.scale*scale_factor
	else:
		item_sprite.texture = null




func _on_hitbox_mouse_entered() -> void:
	mouse_hovering = true
	if id != null:
		cursor_label.visible = true


func _on_hitbox_mouse_exited() -> void:
	mouse_hovering = false
	cursor_label.visible = false
