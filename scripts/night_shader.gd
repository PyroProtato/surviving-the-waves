extends ColorRect

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var morning_timer: Timer = $MorningTimer
@onready var afternoon_timer: Timer = $AfternoonTimer
@onready var evening_timer: Timer = $EveningTimer
@onready var night_timer: Timer = $NightTimer
@onready var early_morning_timer: Timer = $EarlyMorningTimer
@onready var time_label: Label = $"../TimeLabel"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	self.modulate = "#d884190f"


func updateTime(time):
	game_manager.time = time
	time_label.text = "Time: " + time.capitalize()


func _on_morning_timer_timeout() -> void:
	afternoon_timer.start()
	updateTime("afternoon")
	animation_player.play("AfternoonAnimation")


func _on_afternoon_timer_timeout() -> void:
	evening_timer.start()
	updateTime("evening")
	animation_player.play("EveningAnimation")


func _on_evening_timer_timeout() -> void:
	night_timer.start()
	updateTime("night")
	animation_player.play("NightAnimation")


func _on_night_timer_timeout() -> void:
	early_morning_timer.start()
	updateTime("early_morning")
	animation_player.play("EarlyMorningAnimation")


func _on_early_morning_timer_timeout() -> void:
	morning_timer.start()
	updateTime("morning")
	animation_player.play("MorningAnimation")
