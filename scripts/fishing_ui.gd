extends CanvasLayer

@onready var game_manager: Node2D = get_node("/root/Main/Managing Nodes/GameManager")
@onready var catching_sound: AudioStreamPlayer = get_node("/root/Main/Managing Nodes/SoundManager/FishingCatchingSound")
@onready var loot_tables: Node = get_node("/root/Main/Managing Nodes/LootTables")
@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

var timer_time = randi_range(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.pause_game()
	timer.start(timer_time)
	progress_bar.max_value = timer_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	progress_bar.value = timer_time-timer.time_left


func _on_timer_timeout() -> void:
	game_manager.add_item(loot_tables.get_loot(loot_tables.fishing_loot_table), 1)
	game_manager.unpause_game()
	catching_sound.play()
	self.queue_free()
