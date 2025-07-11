extends Area2D

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

var interactible = false

func _ready() -> void:
	pass
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pick_up") and interactible:
		self.queue_free()
		game_manager.wood += 1


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		interactible = true

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		interactible = false
