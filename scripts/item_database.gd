extends Node

var paths = {
	"wood":"res://assets/images/object_icons/log.png",
	"raft":"res://assets/images/object_icons/raft_icon.png",
	"fishing_rod":"res://assets/images/object_icons/fishing_rod_icon.png",
	"trash":"res://assets/images/object_icons/trash_icon.png",
	"cod":"res://assets/images/object_icons/cod_icon.png",
	"salmon":"res://assets/images/object_icons/salmon_icon.png",
	"iron":"res://assets/images/object_icons/iron_icon.png",
	"gold":"res://assets/images/object_icons/gold_icon.png",
	"pickaxe":"res://assets/images/object_icons/pickaxe_icon.png",
	"chest":"res://assets/images/object_icons/chest_icon.png",
	"crafting_table":"res://assets/images/object_icons/crafting_table_icon.png",
	"stone":"res://assets/images/object_icons/stone_icon.png",
	"raw_iron":"res://assets/images/object_icons/raw_iron.png",
	"raw_gold":"res://assets/images/object_icons/raw_gold.png",
	"campfire":"res://assets/images/object_icons/canpfire_icon.png",
	"sword":"res://assets/images/object_icons/sword_icon.png",
	"raw_salmon":"res://assets/images/object_icons/raw_salmon_icon.png",
	"raw_cod":"res://assets/images/object_icons/raw_cod_icon.png"
}

var raft = ["raft"]

var blocks = {
	"crafting_table":preload("res://scenes/crafting_table.tscn"),
	"chest":preload("res://scenes/chest.tscn"),
	"campfire":preload("res://scenes/campfire.tscn")
}

var specific_tooltips = {
	"fishing_rod":"to fish",
	"pickaxe":"to break",
	"trash":"to rummage",
	"sword":"to attack"
}

var fuel = {
	"wood":3
}

var smeltable = {
	"raw_iron":"iron",
	"raw_gold":"gold",
	"raw_salmon":"salmon",
	"raw_cod":"cod"
}

var food = {
	"salmon":5,
	"cod":3,
	"raw_salmon":2,
	"raw_cod":1
}

#All items that perform an action when you click
var activ = ["fishing_rod", "pickaxe", "trash", "sword"]

func _ready() -> void:
	for item in food:
		activ.append(item)
		specific_tooltips[item] = "to eat"
