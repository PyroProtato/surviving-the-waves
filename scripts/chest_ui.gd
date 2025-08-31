extends CanvasLayer

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

@onready var hotbar1: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot1")
@onready var hotbar2: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot2")
@onready var hotbar3: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot3")
@onready var hotbar4: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot4")
@onready var hotbar5: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot5")
@onready var hotbar6: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot6")
@onready var hotbar7: Node2D = get_node("/root/Main/HUD/CanvasLayer/Hotbar/Slot7")

@onready var slot_1: Node2D = $Slot
@onready var slot_2: Node2D = $Slot2
@onready var slot_3: Node2D = $Slot3
@onready var slot_4: Node2D = $Slot4
@onready var slot_5: Node2D = $Slot5
@onready var slot_6: Node2D = $Slot6
@onready var slot_7: Node2D = $Slot7

@onready var chest_slot_tool_tip: CanvasLayer = $ChestSlotToolTip
@onready var chest_slot_tool_tip_2: CanvasLayer = $ChestSlotToolTip2
@onready var hotbar_tool_tip: CanvasLayer = $HotbarToolTip
@onready var hotbar_tool_tip_2: CanvasLayer = $HotbarToolTip2

@onready var chest_close_sound: AudioStreamPlayer = get_node("/root/Main/Managing Nodes/SoundManager/ChestCloseSound")

var chest
var data

var slots
var hotbar_slots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Initializes Slots
	slots = [slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7]
	hotbar_slots = [hotbar1, hotbar2, hotbar3, hotbar4, hotbar5, hotbar6, hotbar7]
	update_chest_slots()
		
	#Connects Signals
	hotbar1.clicked.connect(hotbar_slot_1_clicked)
	hotbar2.clicked.connect(hotbar_slot_2_clicked)
	hotbar3.clicked.connect(hotbar_slot_3_clicked)
	hotbar4.clicked.connect(hotbar_slot_4_clicked)
	hotbar5.clicked.connect(hotbar_slot_5_clicked)
	hotbar6.clicked.connect(hotbar_slot_6_clicked)
	hotbar7.clicked.connect(hotbar_slot_7_clicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Exiting
	if Input.is_action_just_pressed("interact"):
		game_manager.unpause_game()
		chest_close_sound.play()
		self.queue_free()
	
	
	#Tooltips
	var hovering_over_chest_slot = false
	for slot in slots:
		if slot.mouse_hovering and slot.id != null:
			hovering_over_chest_slot = true
			break
	if hovering_over_chest_slot:
		chest_slot_tool_tip.visible = true
		chest_slot_tool_tip_2.visible = true
	else:
		chest_slot_tool_tip.visible = false
		chest_slot_tool_tip_2.visible = false
	
	var hovering_over_hotbar_slot = false
	for slot in hotbar_slots:
		if slot.mouse_hovering and slot.id != null:
			hovering_over_hotbar_slot = true
			break
	if hovering_over_hotbar_slot:
		hotbar_tool_tip.visible = true
		hotbar_tool_tip_2.visible = true
	else:
		hotbar_tool_tip.visible = false
		hotbar_tool_tip_2.visible = false
	


#When a hotbar slot is clicked
func hotbar_slot_clicked(slot, side):
	if slot.id != null or slot.number != null:
		var found_match = false
		var first_null = -1
		for index in range(data.size()):
			if data[index][0] == slot.id:
				found_match = true
				if side == "left":
					data[index][1] += slot.number
					game_manager.remove_item(slot.id, slot.number)
				elif side == "right":
					data[index][1] += 1
					game_manager.remove_item(slot.id, 1)
				break
			elif first_null == -1 and data[index][0] == null:
				first_null = index
		if not found_match:
			if first_null != -1:
				data[first_null][0] = slot.id
				if side == "left":
					data[first_null][1] = slot.number
					game_manager.remove_item(slot.id, slot.number)
				elif side == "right":
					data[first_null][1] = 1
					game_manager.remove_item(slot.id, 1)
			else:
				#When you can't add it
				pass
		update_chest_slots()


#When a chest slot is clicked
func chest_slot_clicked(slot, slot_index, side):
	if slot.id != null or slot.number != null:
		if side == "left":
			game_manager.add_item(slot.id, slot.number)
			slot.update(null, null)
			data[slot_index] = [null, null]
		elif side == "right":
			game_manager.add_item(slot.id, 1)
			slot.update(slot.id, slot.number-1)
			data[slot_index] = [slot.id, slot.number]


func update_chest_slots():
	for index in range(slots.size()):
		slots[index].update(data[index][0], data[index][1])
		


func _on_slot_clicked(slot, side) -> void: 
	chest_slot_clicked(slot, 0, side)
func _on_slot_2_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 1, side)
func _on_slot_3_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 2, side)
func _on_slot_4_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 3, side)
func _on_slot_5_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 4, side)
func _on_slot_6_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 5, side)
func _on_slot_7_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 6, side)


func hotbar_slot_1_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
func hotbar_slot_2_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
func hotbar_slot_3_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
func hotbar_slot_4_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
func hotbar_slot_5_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
func hotbar_slot_6_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
func hotbar_slot_7_clicked(slot, side):
	hotbar_slot_clicked(slot, side)
