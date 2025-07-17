extends Timer

@onready var timer_manager = get_node("/root/Main/Managing Nodes/TimerManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_manager.register(self)
