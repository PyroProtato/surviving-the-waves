extends Node2D

var log_scene = preload("res://scenes/log.tscn")
@onready var wood_timer: Timer = $WoodTimer
var WOOD_LIMIT = 20
var num_wood = 0

var objects = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Interactible logic
	if objects.size() > 0:
		var top_object = null
		var top_index = -1
		for object in objects:
			var index = self.get_children().find(object)
			if index > top_index:
				top_index = index
				top_object = object
		for object in objects:
			if object == top_object:
				object.interactible = true
			else:
				object.interactible = false


func _on_wood_timer_timeout() -> void:
	if not num_wood >= WOOD_LIMIT:
		var log1 = log_scene.instantiate()
		add_child(log1)
		num_wood += 1
