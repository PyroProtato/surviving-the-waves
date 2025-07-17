extends Node

@onready var player: CharacterBody2D = %Player

var blocks = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if blocks.size() > 0:
		var closest = blocks[0]
		var closest_dist = blocks[0].position.distance_to(player.position)
		for block in blocks:
			var dist = block.position.distance_to(player.position)
			if dist < closest_dist:
				closest = block
				closest_dist = dist
		
		#print(closest)
		#print(closest_dist)
		
		for block in blocks:
			if block == closest:
				#print("close")
				block.interactible = true
			else:
				#print("not close")
				block.interactible = false
