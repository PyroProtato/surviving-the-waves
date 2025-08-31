extends CanvasLayer

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.pause_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		game_manager.unpause_game()
		queue_free()
