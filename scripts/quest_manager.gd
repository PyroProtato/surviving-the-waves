extends Node

@onready var game_manager: Node = get_node("/root/Main/Managing Nodes/GameManager")
@onready var current_quest_label: Label = get_node("/root/Main/HUD/CurrentQuestLabel")
@onready var dialogue_manager: Node = $"../DialogueManager"


var quests = []

var data = {}

var quest_active = false

var quest_index = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#All Quest Data
	var move = ["Move using WASD", {"move":4}, ["dialogue", "You", dialogue_manager.wood_text, "quest"]]
	var driftwood = ["Pick up driftwood", {"wood":3}, ["dialogue", "You", dialogue_manager.fishing_rod_text, "quest"]]
	var fishing_rod = ["Craft a fishing rod", {"fishing_rod":1}, ["dialogue", "You", dialogue_manager.fish_text, "quest"]]
	var fish = ["Fish for Items", {"fish":10}, ["dialogue", "You", dialogue_manager.end_text, null]]
	
	quests = [move, driftwood, fishing_rod, fish]
	
	
	start_quest()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	

	if quest_active and game_manager.in_menu == false:
		
		#Checks for moves
		if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_left")  or Input.is_action_just_pressed("move_right"):
			increment_quest("move")
				
		
		check_quest()
		
		updateHUD()


func increment_quest(id, num=1):
	if data.has(id):
		data[id] += num
	else:
		data[id] = num


func check_quest():
	var current_quest = quests[0]
	for objective in current_quest[1].keys():
		if data.has(objective) and data[objective] >= current_quest[1][objective]:
			quest_finished()

func updateHUD():
	if quests.size() > 0:
		var cur = 0
		if data.has(quests[0][1].keys()[0]):
			cur = data[quests[0][1].keys()[0]]
		current_quest_label.text = "Current Quest: " + quests[0][0] + " (" + str(cur) + "/" + str(quests[0][1][quests[0][1].keys()[0]]) + ")"


func quest_finished():
	#Ending Behavior
	if quests[0][2][0] == "dialogue":
		dialogue_manager.narrate(quests[0][2][1], quests[0][2][2], quests[0][2][3])
	elif quests[0][2][0] == null:
		start_quest()
	
	quest_active = false
	quests.remove_at(0)
	quest_index += 1
	current_quest_label.text = ""
	
	
	
func start_quest():
	quest_active = true


func item_picked_up(item, num=1):
	increment_quest(item, num)
