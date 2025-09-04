extends Node2D

@onready var game_manager: Node = get_node("/root/Main/Managing Nodes/GameManager")
var item_notification = preload("res://scenes/item_notification.tscn")

@onready var slot_1: Node2D = $Slot1
@onready var slot_2: Node2D = $Slot2
@onready var slot_3: Node2D = $Slot3
@onready var slot_4: Node2D = $Slot4
@onready var slot_5: Node2D = $Slot5
@onready var slot_6: Node2D = $Slot6
@onready var slot_7: Node2D = $Slot7

@onready var item_label: Label = $ItemLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var hotbar_slots

var selected_slot_changed = true
const VERTICAL_OFFSET = -25

var notifications = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hotbar_slots = [slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7]
	refresh_slots()
	
	#Connects Signal
	game_manager.inventory_changed.connect(_inventory_changed)


func _process(_delta: float) -> void:
		
	#Scroll up
	if Input.is_action_just_pressed("hotbar_up") and not game_manager.in_menu:
		selected_slot_changed = true
		if game_manager.selected_index != hotbar_slots.size()-1:
			game_manager.selected_index += 1
		else:
			game_manager.selected_index = 0
	
	#Scroll down
	if Input.is_action_just_pressed("hotbar_down") and not game_manager.in_menu:
		selected_slot_changed = true
		if game_manager.selected_index != 0:
			game_manager.selected_index -= 1
		else:
			game_manager.selected_index = hotbar_slots.size()-1
	
	#Slots
	if Input.is_action_just_pressed("slot1") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 0
		updateItemLabel(game_manager.selected_item())
	elif Input.is_action_just_pressed("slot2") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 1
		updateItemLabel(game_manager.selected_item())
	elif Input.is_action_just_pressed("slot3") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 2
		updateItemLabel(game_manager.selected_item())
	elif Input.is_action_just_pressed("slot4") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 3
		updateItemLabel(game_manager.selected_item())
	elif Input.is_action_just_pressed("slot5") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 4
		updateItemLabel(game_manager.selected_item())
	elif Input.is_action_just_pressed("slot6") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 5
		updateItemLabel(game_manager.selected_item())
	elif Input.is_action_just_pressed("slot7") and not game_manager.in_menu:
		selected_slot_changed = true
		game_manager.selected_index = 6
		updateItemLabel(game_manager.selected_item())
	
	
	#Raises selected slot
	if selected_slot_changed:
		for slot_index in range(hotbar_slots.size()):
			if slot_index == game_manager.selected_index:
				hotbar_slots[slot_index].position.y = VERTICAL_OFFSET
			else:
				hotbar_slots[slot_index].position.y = 0
		selected_slot_changed = false
	
	
	
func updateItemLabel(item):
	if item != null:
		item_label.visible = true
		item_label.text = item.replace("_", " ").capitalize()
		animation_player.stop(true)
		animation_player.play("fade_text")
	
	


func refresh_slots():
	var filled_inv_slots = game_manager.inventory.size()
	for index in range(hotbar_slots.size()):
		if index < filled_inv_slots:
			hotbar_slots[index].update(game_manager.key_order[index], game_manager.inventory[game_manager.key_order[index]])
		else:
			hotbar_slots[index].update(null, null)


func _inventory_changed(_inventory, item, num):
	#var current_labels = self.get_children().filter(func(child): return child.scene_file_path == "res://scenes/item_notification.tscn")
	
	if notifications.size() != 0:
		for notification1 in notifications:
			notification1.move_up()
	
	var notif = item_notification.instantiate()
	notifications.append(notif)
	notif.item = item
	notif.num = num
	add_child(notif)
	refresh_slots()
	
	while notifications.size() > 3:
		notifications[0].delete()
	
