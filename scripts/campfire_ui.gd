extends CanvasLayer

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var item_database: Node = get_node("/root/Main/Managing Nodes/ItemDatabase")

@onready var hotbar1: Node2D = get_node("/root/Main/HUD/Hotbar/Slot1")
@onready var hotbar2: Node2D = get_node("/root/Main/HUD/Hotbar/Slot2")
@onready var hotbar3: Node2D = get_node("/root/Main/HUD/Hotbar/Slot3")
@onready var hotbar4: Node2D = get_node("/root/Main/HUD/Hotbar/Slot4")
@onready var hotbar5: Node2D = get_node("/root/Main/HUD/Hotbar/Slot5")
@onready var hotbar6: Node2D = get_node("/root/Main/HUD/Hotbar/Slot6")
@onready var hotbar7: Node2D = get_node("/root/Main/HUD/Hotbar/Slot7")

@onready var slot_1: Node2D = $Slot
@onready var slot_2: Node2D = $Slot2
@onready var slot_3: Node2D = $Slot3

@onready var chest_slot_tool_tip: CanvasLayer = $ChestSlotToolTip
@onready var chest_slot_tool_tip_2: CanvasLayer = $ChestSlotToolTip2
@onready var hotbar_tool_tip: CanvasLayer = $HotbarToolTip
@onready var hotbar_tool_tip_2: CanvasLayer = $HotbarToolTip2

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var fuel_bar: TextureProgressBar = $FuelBar

var block_ref
var data

var slots
var hotbar_slots


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Initializes Slots
	slots = [slot_1, slot_2, slot_3]
	hotbar_slots = [hotbar1, hotbar2, hotbar3, hotbar4, hotbar5, hotbar6, hotbar7]
		
	#Connects Signals
	hotbar1.clicked.connect(hotbar_slot_1_clicked)
	hotbar2.clicked.connect(hotbar_slot_2_clicked)
	hotbar3.clicked.connect(hotbar_slot_3_clicked)
	hotbar4.clicked.connect(hotbar_slot_4_clicked)
	hotbar5.clicked.connect(hotbar_slot_5_clicked)
	hotbar6.clicked.connect(hotbar_slot_6_clicked)
	hotbar7.clicked.connect(hotbar_slot_7_clicked)
	
	update_chest_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Exiting
	if Input.is_action_just_pressed("interact"):
		game_manager.unpause_game()
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
	
	
	#Starts fuel
	if data[0][0] != null and data[1][0] != null and data[5] == false:
		data[6] = item_database.fuel[data[1][0]]
		data[5] = true
		data[3] = float(item_database.fuel[data[1][0]])
		data[1][1] -= 1
	
	

	
	if data[6] != 0:
		fuel_bar.value = data[3]/data[6]*100
	else:
		fuel_bar.value = 0
	if data[5]:
		progress_bar.value = (5-data[4])/5*100
	else:
		progress_bar.value = 0
	update_chest_slots()
			
			

func hotbar_slot_clicked(slot, side):
	if side == "left":
		if slot.id != null:
			if item_database.fuel.has(slot.id) and data[1] == [null, null]:
				data[1] = [slot.id, slot.number]
				game_manager.remove_item(slot.id, slot.number)
			elif item_database.smeltable.has(slot.id) and data[0] == [null, null] and data[2][0] == null or data[2][0] == item_database.smeltable[slot.id]:
				data[0] = [slot.id, slot.number]
				game_manager.remove_item(slot.id, slot.number)
			else:
				if data[1][0] == slot.id:
					data[1][1] += slot.number
					game_manager.remove_item(slot.id, slot.number)
				elif data[0][0] == slot.id:
					data[0][1] += slot.number
					game_manager.remove_item(slot.id, slot.number)
	elif side == "right":
		if slot.id != null:
			if item_database.fuel.has(slot.id) and data[1] == [null, null]:
				data[1] = [slot.id, 1]
				game_manager.remove_item(slot.id, 1)
			elif item_database.smeltable.has(slot.id) and data[0] == [null, null] and data[2][0] == null or data[2][0] == item_database.smeltable[slot.id]:
				data[0] = [slot.id, 1]
				game_manager.remove_item(slot.id, 1)
			else:
				if data[1][0] == slot.id:
					data[1][1] += 1
					game_manager.remove_item(slot.id, 1)
				elif data[0][0] == slot.id:
					data[0][1] += 1
					game_manager.remove_item(slot.id, 1)
	update_chest_slots()
	
	
func chest_slot_clicked(slot, index, side):
	if side == "left":
		game_manager.add_item(slot.id, slot.number)
		data[index] = [null, null]
	elif side == "right":
		game_manager.add_item(slot.id, 1)
		if data[index][1] != 1:
			data[index][1] -= 1
		else:
			data[index] = [null, null]
	update_chest_slots()
	

func update_chest_slots():
	for index in range(slots.size()):
		if data[index][1] == 0:
			data[index] = [null, null]
		slots[index].update(data[index][0], data[index][1])



func _on_slot_clicked(slot, side) -> void: 
	chest_slot_clicked(slot, 0, side)
func _on_slot_2_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 1, side)
func _on_slot_3_clicked(slot, side) -> void:
	chest_slot_clicked(slot, 2, side)


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
