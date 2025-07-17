extends Node

@onready var player: CharacterBody2D = %Player

var wood = 10
@onready var wood_label = get_node("/root/Main/HUD/Wood Label")
@onready var raft: TileMapLayer = %Raft
@onready var timer_manager: Node = $"../TimerManager"

var inventory = {"wood":10}

var player_coords

var in_menu = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Set HUD elements
	wood_label.text = "Wood: " + str(inventory["wood"])
	
	#Player Coords
	self.player_coords = raft.local_to_map(player.position)
	
	

func add_item(item, num):
	if inventory.has(item):
		inventory[item] += num
	else:
		inventory[item] = num

func remove_item(item, num):
	if inventory.has(item) and num <= inventory[item] :
		inventory[item] -= num
		return true
	else:
		return false


func pause_game():
	in_menu = true
	timer_manager.pause_timers()
	
	

func unpause_game():
	in_menu = false
	timer_manager.unpause_timers()
