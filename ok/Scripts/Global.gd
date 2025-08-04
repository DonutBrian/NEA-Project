extends Node

# ALl Constants
const SPEED = 100.0
const JUMP_VELOCITY = -350.0

# Player related varaibles
var hurt = 0
var jump_count = 0
var world_pos := {}
var world_area = 0
var money = 0
var collected_coins = {}
var max_jump = 1
var player_health = 5
var last_scene_path = "res://Scenes/Areas/Area 0 - Debug Area/Test.tscn"
