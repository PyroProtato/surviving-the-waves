extends Node

@onready var player: CharacterBody2D = %Player
@onready var item_database: Node = %ItemDatabase

var wood = 10
@onready var raft: TileMapLayer = %Raft
@onready var timer_manager: Node = $"../TimerManager"
@onready var game_end_timer: Timer = $"../TimerManager/Game End Timer"

@onready var healthbar: ProgressBar = get_node("/root/Main/HUD/Healthbar")
@onready var hungerbar: ProgressBar = get_node("/root/Main/HUD/Hungerbar")
@onready var deathmsg: CanvasLayer = get_node("/root/Main/HUD/Death Message")


var inventory = {"wood":5}
var key_order = ["wood"]

var selected_index = 0

signal inventory_changed(Inventory:Dictionary, Item:String, Num:int)

var player_coords

var in_menu = false
var time = "morning"

const MAX_INV_SIZE = 7

var hunger = 20
var health = 100


@onready var object_manager: Node2D = %ObjectManager
@onready var store_sound: AudioStreamPlayer = $StoreSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	
	#Player Coords
	self.player_coords = raft.local_to_map(player.position)
	
	#Determines if the inventory was changed
	
	
	#Paused behavior
	if get_tree().paused == true:
		if game_end_timer.is_stopped() and Input.is_anything_pressed():
			get_tree().paused = false
			get_tree().reload_current_scene()
	
	

func add_item(item, num=1):
	if item == "nothing":
		pass
	else:
		if inventory.has(item):
			inventory[item] += num
			inventory_was_changed(item, num)
			store_sound.play()
		elif inventory.size() >= MAX_INV_SIZE:
			object_manager.summon_generic_object(item, item_database.paths[item], player.position)
			inventory_was_changed(null, num)
		else:
			inventory[item] = num
			key_order.append(item)
			inventory_was_changed(item, num)
			store_sound.play()
		

func remove_item(item, num):
	if inventory.has(item) and num <= inventory[item] :
		inventory[item] -= num
		if inventory[item] == 0:
			key_order.erase(item)
			self.inventory.erase(item)
		inventory_was_changed(item, -num)
		return true
	else:
		return false


func inventory_was_changed(item, num):
	emit_signal("inventory_changed", inventory, item, num)


func pause_game():
	in_menu = true
	timer_manager.pause_timers()
	
	

func unpause_game():
	in_menu = false
	timer_manager.unpause_timers()
	

func selected_item():
	if selected_index < key_order.size():
		return key_order[selected_index]
	else:
		return null


func update_ui_bar(bar, operation, num):
	if operation == "setMax":
		bar.setMax(num)
	elif operation == "setValue":
		bar.setValue(num)
	elif operation == "add":
		bar.add(num)
	elif operation == "subtract":
		bar.subtract(num)
	
	health = healthbar.value
	hunger = hungerbar.value
	
	if health <= 0:
		self.process_mode = Node.PROCESS_MODE_ALWAYS
		game_end_timer.process_mode = Node.PROCESS_MODE_ALWAYS
		game_end_timer.start()
		get_tree().paused = true
		deathmsg.visible = true

func lose_health(num):
	update_ui_bar(healthbar, "subtract", num)


func _on_hunger_timer_timeout() -> void:
	if hunger > 0:
		update_ui_bar(hungerbar, "subtract", 1)
	else:
		update_ui_bar(healthbar, "subtract", 10)

	
