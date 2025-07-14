extends Node2D

var log_scene = preload("res://scenes/log.tscn")
@onready var wood_timer: Timer = $WoodTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_wood_timer_timeout() -> void:
	var log1 = log_scene.instantiate()
	add_child(log1)
