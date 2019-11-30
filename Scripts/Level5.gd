extends Node2D


var tree
var shit
var express
var trees = []
var shits = []
var expresses = []
var distance = 10000

# Called when the node enters the scene tree for the first time.
func _ready():
	save_level(5, 0)
	$God.connect("gameover", self, "_on_God_gameover")
	init_road()
	init_tree()
	init_shit()
	init_express()
	init_ui()

func _process(delta):
	update_shit()
	update_express()
	update_ui(delta)
	if 430 - $God.position.y > distance:
		save_level(5, $God.velocity)
		get_tree().change_scene("res://Scene/Menu/Congratulation.tscn")

func init_express():
	express = preload("res://Scene/Elements/Express.tscn")
	for i in range(100, distance, 500):
		var new_ex = express.instance()
		new_ex.x = 180
		new_ex.y =  -i
		new_ex.scale = Vector2(0.25, 0.25)
		new_ex.velocity = rand_range(0.3, 1)
		add_child(new_ex)
		expresses.append(new_ex)

func init_shit():
	shit = preload("res://Scene/Elements/Shit.tscn")
	for i in range(50, distance, 200):
		var new_shit = shit.instance()
		new_shit.x = rand_range(150, 200)
		new_shit.y =  - i
		new_shit.scale = Vector2(0.25, 0.25)
		new_shit.velocity = rand_range(0.1, 1)
		add_child(new_shit)
		shits.append(new_shit)

func init_road():
	for i in range(int(distance / 256)):
		_new_road(- i * 256 + 500)
	_new_road_end()
	_new_road(-int(distance / 256) * 256 + 512, "res://Pic/Road/end.png")
	_new_half_road(-800)
	_new_half_road(-5000)

func _new_road_end():
	var road_end = load("res://Scene/Elements/RoadEnd.tscn")
	var new_end = road_end.instance()
	new_end.rect_position.x = 0
	new_end.rect_position.y = - int(distance / 256) * 256 + 16
	add_child(new_end)
	var side_end = load("res://Scene/Elements/RoadSideEnd.tscn")
	var new_side_end = side_end.instance()
	new_side_end.position.x = 0
	new_side_end.position.y = - int(distance / 256) * 256 + 144
	add_child(new_side_end)

func _new_road(y, pic="res://Pic/Road/road.png"):
	var road = Sprite.new()
	road.texture = load(pic)
	road.position.x = 155
	road.position.y = y
	road.scale.x = 0.25
	road.scale.y = 0.25
	road.light_mask = 1
	add_child(road)

func _new_half_road(y):
	var road_half_start = load("res://Scene/Elements/road_half_start.tscn")
	var road_half = load("res://Scene/Elements/road_half.tscn")
	var road_half_end = load("res://Scene/Elements/road_half_end.tscn")
	
	var new_road_half_start = road_half_start.instance()
	new_road_half_start.position.x = 155
	new_road_half_start.position.y = y
	new_road_half_start.scale = Vector2(0.25, 0.25)
	new_road_half_start.light_mask = 1
	add_child(new_road_half_start)
	
	for i in range(8):
		var new_half = road_half.instance()
		new_half.position = Vector2(155, y - 256 * (i + 1))
		new_half.scale = Vector2(0.25, 0.25)
		new_half.light_mask = 1
		add_child(new_half)
	
	var new_road_half_end = road_half_end.instance()
	new_road_half_end.position.x = 155
	new_road_half_end.position.y = y - 256 * 9
	new_road_half_end.scale = Vector2(0.25, 0.25)
	new_road_half_end.light_mask = 1
	add_child(new_road_half_end)

func init_tree():
	tree = preload("res://Scene/Elements/Tree.tscn")
	for i in range(int(distance / 80)):
		var new_tree = tree.instance()
		new_tree.position.x = 30
		new_tree.position.y =  - i * 80 + 500
		new_tree.scale.x = 0.5
		new_tree.scale.y = 0.5
		add_child(new_tree)
		trees.append(new_tree)

func init_ui():
	$Camera2D.position.y = $God.position.y - 150
	$Camera2D/UILayer/CommonUI/map.target_distance = distance
	$Camera2D/UILayer/CommonUI/Energy.total_energy = $God.energy
	$Camera2D/UILayer/CommonUI/Energy.energy = $God.energy

func update_shit():
	for i in range(len(shits)):
		if shits[i].y < - distance:
			shits[i].y = 520

func update_express():
	for i in range(len(expresses)):
		if expresses[i].y < - distance:
			expresses[i].y = 520

func update_ui(dt):
	$Camera2D.position.y = $God.position.y - 150
	$Camera2D/UILayer/CommonUI/map.distance = $God.distance
	$Camera2D/UILayer/CommonUI/Speedometer.velocity = $God.velocity
	$Camera2D/UILayer/CommonUI/Energy.energy = $God.energy

func _on_God_gameover():
	save_level(5, 0)
	get_tree().change_scene("res://Scene/Menu/GameOver.tscn")

func save_level(level, final_velocity):
	var level_file = File.new()
	level_file.open("user://level_info.save", File.WRITE)
	var level_info = {
		"level": level,
		"final_velocity": final_velocity
	}
	level_file.store_line(to_json(level_info))
	level_file.close()