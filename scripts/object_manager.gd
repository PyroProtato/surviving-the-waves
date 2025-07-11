extends Node2D

var log_scene = preload("res://scenes/log.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var log1 = log_scene.instantiate()
	add_child(log1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
