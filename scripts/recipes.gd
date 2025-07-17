extends Node

var raft_recipe = [[["wood", 3]], [["raft", 1]]]
var wood_recipe2 = [[["wood", 1], ["wood",3]], [["wood", 5]]]

var recipes = [raft_recipe, wood_recipe2]


func add_recipe(recipe):
	recipes.append(recipe)
