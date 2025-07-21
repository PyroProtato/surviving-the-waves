extends Label

@onready var lifespan: Timer = $Lifespan

var item
var num

const FADE_OUT_TIME = .5
const Y_OFFSET = -30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item == null:
		self.text = "Inventory Full!"
		self.add_theme_color_override("font_color", Color(244, 0, 0))
	elif num > 0:
		self.text = "+" + str(num) + " " + item.capitalize()
		self.add_theme_color_override("font_color", Color(0, 244, 0))
	else:
		self.text = str(num) + " " + item.capitalize()
		self.add_theme_color_override("font_color", Color(244, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if lifespan.time_left < FADE_OUT_TIME:
		var current_color = self.get_theme_color("font_color")
		self.add_theme_color_override("font_color", Color(current_color.r, current_color.g, current_color.b, lifespan.time_left/FADE_OUT_TIME))
	
	#When it dies
	if lifespan.time_left == 0:
		delete()

#Moves notification up a slot
func move_up():
	self.position.y += Y_OFFSET
	

#When it dies
func delete():
	self.get_parent().notifications.erase(self)
	queue_free()
