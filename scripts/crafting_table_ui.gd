extends CanvasLayer

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		game_manager.in_menu = false
		self.queue_free()
