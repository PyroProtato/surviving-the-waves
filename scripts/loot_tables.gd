extends Node

var fishing_loot_table = [["fish", 60, [["stone", 50], ["raw_cod", 25], ["raw_salmon", 25]]], ["trash", 30], ["treasure", 10, [["raw_iron", 60], ["raw_gold", 40]]]]

var trash_loot_table = [["stone", 30], ["wood", 40], ["nothing", 25], ["raw_iron", 5]]


func get_loot(loot_table):
	
	var total_val = 0.0
	for entry in loot_table:
		total_val += entry[1]
	
	var value = randf_range(0.0, total_val)
	
	var current_value = 0.0
	var chosen
	for entry in loot_table:
		if entry[1]+current_value < value:
			current_value += entry[1]
		else:
			chosen = entry
			break
	
	if chosen.size() == 2:
		return chosen[0]
	else:
		return get_loot(chosen[2])
