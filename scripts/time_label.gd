extends Label

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_manager.in_menu:
		visible = false
	else:
		visible = true
