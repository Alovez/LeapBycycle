extends Node2D


var tree
var shit
var trees = []
var shits = []
var distance = 10000

# Called when the node enters the scene tree for the first time.
func _ready():
	$God.connect("gameover", self, "_on_God_gameover")
	init_road()
	init_tree()
	init_shit()
	init_UI()


func _process(delta):
	update_shit()
	update_ui(delta)
	if 430 - $God.position.y > distance:
		save_level(1, $God.velocity)
		get_tree().change_scene("res://Scene/LevelDone.tscn")
		

func init_shit():
	shit = preload("res://Scene/Shit.tscn")
	for i in range(int(distance / 200)):
		var new_shit = shit.instance()
		new_shit.x = rand_range(35, 250)
		new_shit.y =  - i * 80 + 400
		new_shit.scale = Vector2(0.25, 0.25)
		new_shit.velocity = rand_range(0, 1)
		add_child(new_shit)
		shits.append(new_shit)

func init_road():
	for i in range(int(distance / 256)):
		_new_road(- i * 256 + 500)
	_new_road(-int(distance / 256) * 256 + 512, "res://Pic/Road/end.png")

func _new_road(y, pic="res://Pic/Road/road.png"):
	var road = Sprite.new()
	road.texture = load(pic)
	road.position.x = 155
	road.position.y = y
	road.scale.x = 0.25
	road.scale.y = 0.25
	add_child(road)

func init_tree():
	tree = preload("res://Scene/Tree.tscn")
	for i in range(int(distance / 80)):
		var new_tree = tree.instance()
		new_tree.position.x = 30
		new_tree.position.y =  - i * 80 + 500
		new_tree.scale.x = 0.5
		new_tree.scale.y = 0.5
		add_child(new_tree)
		trees.append(new_tree)

func init_UI():
	$Camera2D/UILayer/CommonUI/map.target_distance = distance
	$Camera2D/UILayer/CommonUI/Energy.total_energy = $God.energy
	$Camera2D/UILayer/CommonUI/Energy.energy = $God.energy

func update_shit():
	for i in range(int(distance / 500)):
		if shits[i].y < - distance:
			shits[i].y = 520

func update_ui(dt):
	$Camera2D.position.y = $God.position.y
	$Camera2D/UILayer/CommonUI/map.distance = 430 - $God.position.y
	$Camera2D/UILayer/CommonUI/Speedometer.velocity = $God.velocity
	$Camera2D/UILayer/CommonUI/Energy.energy = $God.energy

func _on_God_gameover():
	get_tree().change_scene("res://Scene/GameOver.tscn")

func save_level(level, final_velocity):
	var level_file = File.new()
	level_file.open("user://level_info.save", File.WRITE)
	var level_info = {
		"level": level,
		"final_velocity": final_velocity
	}
	level_file.store_line(to_json(level_info))
	level_file.close()