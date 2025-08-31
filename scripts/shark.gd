extends RigidBody2D

@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var raft: TileMapLayer = get_node("/root/Main/Raft")
@onready var game_manager: Node = get_node("/root/Main/Managing Nodes/GameManager")
@onready var attack_timer: Timer = $AttackTimer
@onready var healthbar: ProgressBar = get_node("/root/Main/HUD/Healthbar")

const SHARK_DMG = 25
const SPEED = 2
const ATK_SPD = 5
const ATK_TIME = 10
var atk_ctr = 0

const ATK_RAD = 250

var attack_anim = false

var direction
var colliding_raft = false
var closest_tile = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Manages Dashing
	direction = Vector2(0, 0)
	if attack_timer.is_stopped() and not colliding_raft:
		direction = (player.position - global_position).normalized() * SPEED
	elif attack_timer.is_stopped():
		attack_timer.start()
	

	
	#Directional flipping
	if player.position.x > self.position.x:
		#self.scale.x = -1
		pass
	else:
		#self.scale.x = 1
		pass
	
	
	
	move_and_collide(direction)
	



func _on_attack_timer_timeout() -> void:
	raft.destroy_cell(closest_tile)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_manager.update_ui_bar(healthbar, "subtract", SHARK_DMG)



func _on_body_entered(body: Node) -> void:
	if body.name == "Raft":
		colliding_raft = true
		
		print(raft.get_used_cells())
		
		#Finds the closest raft tile
		var close_dist = raft.get_used_cells()[0].distance_to(self.position)
		var close_index = 0
		var index = 0
		for tile in raft.get_used_cells():
			var temp = tile
			temp *= 128
			var dist = temp.distance_to(self.position)
			print(str(temp) + " " + str(dist))
			if dist < close_dist:
				close_dist = dist
				close_index = index
			index += 1
		closest_tile = raft.get_used_cells()[close_index]
		
		print(closest_tile)
		
		


func _on_body_exited(body: Node) -> void:
	if body.name == "Raft":
		colliding_raft = false
