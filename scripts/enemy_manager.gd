extends Node

@onready var game_manager: Node = get_node("/root/Main/Managing Nodes/GameManager")
@onready var shark_timer: Timer = $SharkTimer

var shark_instance = preload("res://scenes/shark.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_manager.time == "night":
		if shark_timer.is_stopped():
			shark_timer.start(randi_range(20, 40))




func _on_shark_timer_timeout() -> void:
	var temp = shark_instance.instantiate()
	add_child(temp)
