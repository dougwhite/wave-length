extends Node

signal wave_complete

@onready var game_manager = %GameManager
@onready var enemies = $Enemies
@onready var radio_tower = $"../Objects/RadioTower"

# Enemies
var jellyfish = preload("res://scenes/enemies/jellyfish.tscn")
var ghostgull = preload("res://scenes/enemies/grossgull.tscn")

var waves = [
	# Wave 1 @ the tower
	[
		# 7 slow yellows
		{ "elapsed": 1, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 3, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 4, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 5, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 6, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 7, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		
		# 7 slow reds
		{ "elapsed": 10, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 11, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 12, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 13, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 14, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 15, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 16, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		
		# 14 mixed pressure
		{ "elapsed": 18, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 19, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 20, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 21, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 22, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 23, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 24, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 25, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 26, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 27, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 28, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 29, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 31, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
	],
	# Wave 2 @ The solar panels
	[
		{ "elapsed": 1, "spawn": ^"Wave2/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
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
		{ "elapsed": 2, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 3, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 4, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 5, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 6, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 7, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		
		# 7 slow reds
		{ "elapsed": 10, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 11, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 12, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 13, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 14, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 15, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 16, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		
		# 4 Pairs of colors
		{ "elapsed": 20, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 20, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 22, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 22, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 24, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 24, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 26, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		{ "elapsed": 26, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		
		# 7 of 2 different colors, one side each color
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 30, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		
		# 7 of 2 different colors, reversed
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 40, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		
		# 7 of alternating colors
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 45, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		
		# 21 of random colors
		{ "elapsed": 50, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 12 },
		{ "elapsed": 52, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		{ "elapsed": 54, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 36 },
		{ "elapsed": 56, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 27 },
		{ "elapsed": 58, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
		{ "elapsed": 60, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 6 },
		{ "elapsed": 62, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 18 },
		{ "elapsed": 64, "spawn": ^"Wave1/spawn_location_4", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 0 },
		{ "elapsed": 66, "spawn": ^"Wave1/spawn_location_7", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 24 },
		{ "elapsed": 68, "spawn": ^"Wave1/spawn_location_2", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 18 },
		{ "elapsed": 70, "spawn": ^"Wave1/spawn_location_5", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 21 },
		{ "elapsed": 72, "spawn": ^"Wave1/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 3 },
		{ "elapsed": 74, "spawn": ^"Wave1/spawn_location_6", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 9 },
		{ "elapsed": 76, "spawn": ^"Wave1/spawn_location_3", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
	],
	# Wave 5 @ South Beach - 1 obelisk
	[
		{ "elapsed": 1, "spawn": ^"Wave5/obelisk_1", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
	],
	# Wave 6 @ Many Obelisks!
	[
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_1", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_2", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_3", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_4", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_5", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_6", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_7", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
		{ "elapsed": 1, "spawn": ^"Wave6/obelisk_8", "mob": jellyfish, "goal": ^"../Objects/Player", "band": 15 },
	],
	# Wave 7 @ Radio Tower - FULL ASSAULT
	[
		{ "elapsed": 1, "spawn": ^"Wave7/spawn_location_1", "mob": jellyfish, "goal": ^"../Objects/RadioTower", "band": 15 },
	],
]

var wave_in_progress: bool = false
var current_wave: int = -1
var elapsed: float = 0.0
var current_spawn: int = -1

func start_wave(wave: int):
	wave_in_progress = true
	current_wave = wave
	elapsed = 0.0
	current_spawn = 0

func _process(delta):
	# If we aren't in progress, do nothing
	if !wave_in_progress:
		return
	
	# Keep track of time elapsed
	elapsed += delta
	
	var s = _pop_spawn()
	while s:
		_spawn_mob(s.mob, s.spawn, s.goal, s.band)
		s = _pop_spawn()
	
	if enemies.get_child_count() == 0 and current_spawn >= waves[current_wave].size():
		wave_in_progress = false
		emit_signal("wave_complete")
		
	
func _pop_spawn():
	if current_spawn >= waves[current_wave].size():
		return null
	
	if waves[current_wave][current_spawn].elapsed > elapsed:
		return null
	
	current_spawn += 1
	return waves[current_wave][current_spawn - 1]

func _spawn_mob(asset: PackedScene, spawn_path: NodePath, goal_path: NodePath, band: int = -1):
	# if the asset isn't there we can't spawn it
	if asset == null:
		return 
	
	# If the spawn location isn't valid we can't spawn there
	var location = get_node_or_null(spawn_path)
	if location == null:
		return
	
	# Without a goal we can't spawn in
	var goal = get_node_or_null(goal_path)
	if goal == null:
		return

	# Instantiate the enemy model		
	var mob = asset.instantiate()
	mob.global_position = location.global_position
	mob.game_manager = game_manager	
	mob.goal = goal
	
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
