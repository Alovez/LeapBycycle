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
		save_level(2, $God.velocity)
		get_tree().change_scene("res://Scene/Menu/LevelDone.tscn")
		

func init_express():
	express = preload("res://Scene/Elements/Express.tscn")
	for i in range(100, distance, 500):
		var new_ex = express.instance()
		new_ex.x = 155
		new_ex.y =  -i
		new_ex.scale = Vector2(0.25, 0.25)
		new_ex.velocity = rand_range(0, 1)
		add_child(new_ex)
		expresses.append(new_ex)

func init_shit():
	shit = preload("res://Scene/Elements/Shit.tscn")
	for i in range(50, distance, 200):
		var new_shit = shit.instance()
		new_shit.x = rand_range(100, 200)
		new_shit.y =  - i
		new_shit.scale = Vector2(0.25, 0.25)
		new_shit.velocity = rand_range(0, 1)
		add_child(new_shit)
		shits.append(new_shit)

func init_road():
	for i in range(int(distance / 256)):
		_new_road(- i * 256 + 500)
	_new_road_end()
	_new_road(-int(distance / 256) * 256 + 512, "res://Pic/Road/end.png")
	

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