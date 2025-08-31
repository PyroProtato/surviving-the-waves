extends Node

var raft_recipe = [[["wood", 3]], [["raft", 1]], "Another raft tile to place"]
var fishing_rod_recipe = [[["wood", 5]], [["fishing_rod", 1]], "Used to fish for items"]
var pickaxe_recipe = [[["wood", 2], ["iron", 3]], [["pickaxe", 1]], "Can be used to break blocks and raft tiles"]
var chest_recipe = [[["wood", 8]], [["chest", 1]], "Used to store items"]
var campfire_recipe = [[["wood", 3], ["stone", 3]], [["campfire", 1]], "Used to smelt items"]

var recipes = [fishing_rod_recipe, raft_recipe, campfire_recipe, chest_recipe, pickaxe_recipe]


func add_recipe(recipe):
	recipes.append(recipe)
