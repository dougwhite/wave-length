extends Node

signal wave_complete

@onready var game_manager = %GameManager
@onready var enemies = $Enemies
@onready var radio_tower = $"../Objects/RadioTower"

# Enemies
var jellyfish = preload("res://scenes/enemies/jellyfish.tscn")
var ghostgull = preload("res://scenes/enemies/grossgull.tscn")
var obelisk = preload("res://scenes/enemies/obelisk.tscn")

var wave_targets = [
	[
		^"../Objects/RadioTower"
	],
	[
		^"../Objects/SolarPanels/SolarPanel1",
		^"../Objects/SolarPanels/SolarPanel2",
		^"../Objects/SolarPanels/SolarPanel3",
		^"../Objects/SolarPanels/SolarPanel4",
		^"../Objects/SolarPanels/SolarPanel5",
		^"../Objects/SolarPanels/SolarPanel6",
		^"../Objects/SolarPanels/SolarPanel7",
	],
	[
		^"../Objects/Player"
	],
	[
		^"../Objects/RadioTower"
	],
	[
		^"../Objects/RadioTower"
	],
	[
		^"../Objects/RadioTower"
	],
	[
		^"../Objects/RadioTower"
	]
]

var waves = [
	# Wave 1 @ the tower
	[
		# 7 slow yellows
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15, "hold": true },
		
		# 7 slow reds
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6, "hold": true },
		
		# 14 mixed pressure
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
	],
	# Wave 2 @ The solar panels
	[
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 15, "hold": true },
		
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 6 },
		
		{ "elapsed": 5, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 6, "hold": true },
		
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 15, "hold": true },
		
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 24 },
		
		{ "elapsed": 10, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 12, "hold": true },
		
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 6 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 12 },
		
		{ "elapsed": 5, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_2", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_3", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_4", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_5", "mob": jellyfish, "goal": ^"random", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_6", "mob": jellyfish, "goal": ^"random", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave2/spawn_location_7", "mob": jellyfish, "goal": ^"random", "band": 24 },
	],
	# Wave 3 @ Sattelite Dish (Seaguls)
	[
		{ "elapsed": 0, "spawn": ^"Wave3/spawn_location_1", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 12 },
		{ "elapsed": 5, "spawn": ^"Wave3/spawn_location_2", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 24 },
		{ "elapsed": 10, "spawn": ^"Wave3/spawn_location_3", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 36 },
		#{ "elapsed": 15, "spawn": ^"Wave3/spawn_location_4", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 12 },
		#{ "elapsed": 20, "spawn": ^"Wave3/spawn_location_5", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 15 },
		#{ "elapsed": 25, "spawn": ^"Wave3/spawn_location_6", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 18 },
		#{ "elapsed": 30, "spawn": ^"Wave3/spawn_location_7", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 21 },
		#{ "elapsed": 35, "spawn": ^"Wave3/spawn_location_1", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 24 },
		#{ "elapsed": 40, "spawn": ^"Wave3/spawn_location_2", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 27 },
		#{ "elapsed": 45, "spawn": ^"Wave3/spawn_location_3", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 30 },
		#{ "elapsed": 50, "spawn": ^"Wave3/spawn_location_4", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 33 },
		#{ "elapsed": 55, "spawn": ^"Wave3/spawn_location_5", "mob": ghostgull, "goal": ^"../Objects/Player", "band": 36 },
	],
	# Wave 4 @ the tower
	[
		# 7 slow yellows
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15, "hold": true },
		
		# 7 slow reds
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6, "hold": true },
		
		# 4 Pairs of colors
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0, "hold": true },
		
		# 7 of 2 different colors, one side each color
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		
		# 7 of 2 different colors, reversed
		{ "elapsed": 10, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		
		# 7 of alternating colors
		{ "elapsed": 5, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24, "hold": true },
		
		# 21 of random colors
		{ "elapsed": 0, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 27 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 18 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 18 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 21 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 3 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 9 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
	],
	# Wave 5 @ South Beach - 1 obelisk
	[
		{ "elapsed": 0, "spawn": ^"Wave5/obelisk_1", "mob": obelisk, "goal": ^"../Objects/Player", "band": 15 },
	],
	# Wave 6 @ Many Obelisks!
	[
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_1", "mob": obelisk, "goal": ^"../Objects/Player", "band": 3 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_2", "mob": obelisk, "goal": ^"../Objects/Player", "band": 12 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_3", "mob": obelisk, "goal": ^"../Objects/Player", "band": 24 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_4", "mob": obelisk, "goal": ^"../Objects/Player", "band": 36 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_5", "mob": obelisk, "goal": ^"../Objects/Player", "band": 9 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_6", "mob": obelisk, "goal": ^"../Objects/Player", "band": 30 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_7", "mob": obelisk, "goal": ^"../Objects/Player", "band": 21 },
		{ "elapsed": 0, "spawn": ^"Wave6/obelisk_8", "mob": obelisk, "goal": ^"../Objects/Player", "band": 6 },
	],
	# Wave 7 @ Radio Tower - FULL ASSAULT
	[
		{ "elapsed": 0, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15, "hold": true},
		{ "elapsed": 0, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15, "hold": true },
		{ "elapsed": 5, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15, "hold": true},
		{ "elapsed": 1, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
	],
]

var wave_in_progress: bool = false
var current_wave: int = -1
var spawn_timer: float = 0.0
var current_spawn: int = -1
var holding: bool = false

func start_wave(wave: int):
	wave_in_progress = true
	current_wave = wave
	spawn_timer = 0.0
	current_spawn = 0

func _process(delta):
	# If we aren't in progress, do nothing
	if !wave_in_progress:
		return
	
	if holding:
		if enemies.get_child_count() == 0:
			holding = false
		else:
			return
	
	# Keep track of time elapsed
	spawn_timer += delta
	
	var s = _pop_spawn()
	while s:
		_spawn_mob(s.mob, s.spawn, s.goal, s.band)
		holding = s.get("hold", false)
		if holding:
			s = null
			continue
		s = _pop_spawn()
	
	if enemies.get_child_count() == 0 and current_spawn >= waves[current_wave].size():
		wave_in_progress = false
		emit_signal("wave_complete")
		
	
func _pop_spawn():
	if current_spawn >= waves[current_wave].size():
		return null
	
	var mob = waves[current_wave][current_spawn]
	var delay: float = float(mob.elapsed) 
	
	if spawn_timer < delay:
		return null
	
	spawn_timer -= delay
	current_spawn += 1
	return mob

func _spawn_mob(asset: PackedScene, spawn_path: NodePath, goal_path: NodePath, band: int = -1):
	# if the asset isn't there we can't spawn it
	if asset == null:
		return 
	
	# If the spawn location isn't valid we can't spawn there
	var location = get_node_or_null(spawn_path)
	if location == null:
		return
	
	# Try and get the specified goal from it's node path
	var goal = get_node_or_null(goal_path)

	# Instantiate the enemy model		
	var mob = asset.instantiate()
	mob.global_position = location.global_position
	mob.game_manager = game_manager	
	mob.goal = goal
	mob.wave_manager = self
	
	# Set a band if one was provided
	if band != -1:
		mob.band = band
		mob.match_band = true

	# Add the child to our collection
	enemies.add_child(mob)
	return mob

# Gets all spawns for a wave
func _get_spawns(wave: String) -> Array[Node]:
	var lvl = self.get_node(wave)
	return lvl.find_children("*", "Node2D")

func new_goal():
	var targets = wave_targets[current_wave]
	if targets.size() == 0:
		return null
	var i = randi() % targets.size()
	var check_target = get_node_or_null(targets[i])
	if check_target == null:
		targets.remove_at(i)
		check_target = new_goal()
	return check_target
	
