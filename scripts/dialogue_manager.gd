extends Node

var narrator_popup = preload("res://scenes/narrator_popup.tscn")
@onready var hud: CanvasLayer = get_node("/root/Main/HUD")


const entry_text = ["Where am I..?", "Last thing I remember my plane was about to crash- why am I stuck in the middle of the ocean?", "Well I guess I'd better learn to survive..."]
const wood_text = ["I think that there's driftwood that floats in occasionally", "I should pick it up!"]
const fishing_rod_text = ["I can use this wood to make things!", "That crafting table over there looks like a good spot."]
const fish_text = ["Maybe I can use this new fishing rod to get some more materials..."]
const end_text = ["I think I know enough to survive now.", "Let's keep building our raft! Many new features await!"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	narrate("You", entry_text, null)


func narrate(person, text, next):
	var scene = narrator_popup.instantiate()
	scene.txt = text.duplicate(true)
	scene.person = person
	scene.next = next
	hud.add_child(scene)
	
