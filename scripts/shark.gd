extends RigidBody2D

@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var raft: TileMapLayer = get_node("/root/Main/Raft")
@onready var game_manager: Node = get_node("/root/Main/Managing Nodes/GameManager")
@onready var attack_timer: Timer = $AttackTimer
@onready var shark_collision_shape: CollisionShape2D = $CollisionShape2D
@onready var danger_line: Line2D = $DangerLine
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var self_healthbar: ProgressBar = $Healthbar

const SHARK_DMG = 25
const SPEED = 2
const ATK_SPD = 5
const ATK_TIME = 10
const spawn_rad = 20
var atk_ctr = 0

const ATK_RAD = 250

var direction = Vector2(0, 0)
var colliding_raft = false
var closest_tile = null
var health = 100

const lvl4color = Color("fbf404")
const lvl3color = Color("fb9e04")
const lvl2color = Color("fb4604")
const lvl1color = Color("fb0a04")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_healthbar.max_value = health
	self_healthbar.value = health
	
	#Gets random position
	var coords
	while true:
		var temp_x = randi_range(-spawn_rad, spawn_rad)
		var temp_y = randi_range(-spawn_rad, spawn_rad)
		var dist_from_player = Vector2(game_manager.player_coords).distance_to(Vector2(temp_x, temp_y))
		if Vector2i(temp_x, temp_y) not in raft.get_used_cells() and dist_from_player > 10.0:
			#Sets position
			coords = Vector2(temp_x, temp_y)
			break
	
	#Sets position and rotation
	self.position = coords*128


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	#Updates Healthbar
	self_healthbar.value = health
	if health <= 0:
		self.queue_free()
	
	#Checks the collisions	
	colliding_raft = false
	var approx_pos = raft.local_to_map(position)
	var used_tiles = raft.get_used_cells()
	for x in range(approx_pos[0]-2, approx_pos[0]+2+1):
		for y in range(approx_pos[1]-2, approx_pos[1]+2+1):
			if Vector2i(x, y) in used_tiles:
				if Vector2i(x*128+64, y*128+64).distance_to(position) <= shark_collision_shape.shape.radius+100:
					colliding_raft = true
	
	
	
	#Manages Dashing
	if attack_timer.is_stopped() and not colliding_raft:
		direction = (player.position - global_position).normalized() * SPEED
	elif attack_timer.is_stopped():
		attack_timer.start()
		collision_calc()
	
	
	#Angle of sprite2d
	
	
	if position.x > player.position.x:
		sprite_2d.flip_h = true
		sprite_2d.rotation = direction.angle() + PI
	else:
		sprite_2d.flip_h = false
		sprite_2d.rotation = direction.angle()
	
	if attack_timer.is_stopped():
		move_and_collide(direction)
		
	else:
		#Changes danger line position
		danger_line.global_position = closest_tile*128
		
		#Changes color of box
		if attack_timer.time_left > attack_timer.wait_time*0.75:
			danger_line.default_color = lvl4color
		elif attack_timer.time_left > attack_timer.wait_time*0.5:
			danger_line.default_color = lvl3color
		elif attack_timer.time_left > attack_timer.wait_time*0.25:
			danger_line.default_color = lvl2color
		elif attack_timer.time_left > 0:
			danger_line.default_color = lvl1color



func collision_calc():
		
	#Finds the closest raft tile
	var close_dist = Vector2(raft.get_used_cells()[0][0]+64, raft.get_used_cells()[0][1]+64).distance_to(self.position)
	var close_index = 0
	var index = 0
	for tile in raft.get_used_cells():
		var temp = tile
		temp *= 128
		temp[0] += 64
		temp[1] += 64
		var dist = temp.distance_to(self.position)
		if dist < close_dist:
			close_dist = dist
			close_index = index
		index += 1
	closest_tile = raft.get_used_cells()[close_index]
	
	danger_line.visible = true
	
	

#When the shark is damaged
func damage(dmg):
	move_and_collide((global_position - player.position).normalized() * 50)
	colliding_raft = false
	self.health -= dmg
	danger_line.visible = false
	attack_timer.stop()
	


func _on_attack_timer_timeout() -> void:
	raft.destroy_cell(closest_tile)
	danger_line.visible = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		game_manager.lose_health(SHARK_DMG)



func _on_body_entered(body: Node) -> void:
	if body.name == "Raft":
		pass
		
		
		
		


func _on_body_exited(body: Node) -> void:
	if body.name == "Raft":
		pass
