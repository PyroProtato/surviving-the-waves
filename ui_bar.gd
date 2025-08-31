extends ProgressBar

@onready var value_label: Label = $ValueLabel
@export var varname = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_label.size = self.size
	value_label.position = Vector2(0, 0)
	update()



func update():
	value_label.text = str(int(self.value)) + "/" + str(int(self.max_value))
	

func setMax(num):
	self.max_value = num
	update()
	
func setValue(num):
	self.value = num
	update()

func add(num):
	self.value += num
	update()

func subtract(num):
	self.value -= num
	update()
