extends CanvasLayer

@onready var title: Label = $Title
@onready var rich_text_label: RichTextLabel = $Title/RichTextLabel
@onready var delay_timer: Timer = $DelayTimer
@onready var continue_shape: Polygon2D = $Style/ContinueShape
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")

@onready var quest_manager: Node = get_node("/root/Main/Managing Nodes/QuestManager")


var text = "Default text lol idk what to write here if you're seeing this I messed up :p"
var text_index = 1
var text_length = text.length()

var txt = ""
var person = "PyroProtato (the developer)"
var next = null

var skippable = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.pause_game()
	if typeof(txt) == TYPE_STRING:
		text = txt
		title.text = person
		text_length = len(text)
	elif typeof(txt) == TYPE_ARRAY:
		text = txt[0]
		txt.remove_at(0)
		title.text = person
		text_length = text.length()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
			
	#Causes text to gradually appear
	if text_index <= text_length:
		rich_text_label.text = text.substr(0, text_index)
		text_index += 1
	elif delay_timer.is_stopped() and not skippable:
		delay_timer.start()
	
	if skippable and Input.is_anything_pressed():
		if typeof(txt) == TYPE_STRING:
			delete()
		elif typeof(txt) == TYPE_ARRAY:
			if len(txt) != 0:
				text = txt[0]
				txt.remove_at(0)
				title.text = person
				text_length = text.length()
				text_index = 0
				skippable = false
				animation_player.stop()
				continue_shape.visible = false
			else:
				delete()
			


func delete():
	if next == null:
		game_manager.unpause_game()
		self.queue_free()
	elif typeof(next) == TYPE_STRING:
		if next == "quest":
			quest_manager.start_quest()
			game_manager.unpause_game()
			self.queue_free()


func _on_delay_timer_timeout() -> void:
	skippable = true
	animation_player.play("skippable")
