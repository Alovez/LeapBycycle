extends Node2D

var shit = preload("res://Scene/Elements/Shit.tscn")

var virtual_shit = false
var distance = 10000
var bypass_tutorial = true
var tutorial_step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	save_level(0, 0)
	$God.connect("gameover", self, "_on_God_gameover")
	read_settings()
	init_road()
	init_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not bypass_tutorial:
		update_tutorial(delta)
	else:
		update_shit(delta)
	update_ui()
	if 800 - $God.position.y > distance:
		save_level(0, $God.velocity)
		get_tree().change_scene("res://Scene/Menu/LevelDone.tscn")

func init_road():
	for i in range(int(distance / 256)):
		_new_road(- i * 256 + 800)
	_new_road_end()
	_new_road(-int(distance / 256) * 256 + 812, "res://Pic/Road/end.png")

func _new_road_end():
	var road_end = load("res://Scene/Elements/RoadEnd.tscn")
	var new_end = road_end.instance()
	new_end.rect_position.x = 0
	new_end.rect_position.y = - int(distance / 256) * 256 + 16 + 296
	add_child(new_end)
	var side_end = load("res://Scene/Elements/RoadSideEnd.tscn")
	var new_side_end = side_end.instance()
	new_side_end.position.x = 0
	new_side_end.position.y = - int(distance / 256) * 256 + 144 + 296
	add_child(new_side_end)

func _new_road(y, pic="res://Pic/Road/road.png"):
	var road = Sprite.new()
	road.texture = load(pic)
	road.position.x = 155
	road.position.y = y
	road.scale.x = 0.25
	road.scale.y = 0.25
	add_child(road)

func init_ui():
	$Camera2D.position.y = $God.position.y - 150
	$Camera2D/UILayer/CommonUI/map.target_distance = distance
	$Camera2D/UILayer/CommonUI/Energy.total_energy = $God.energy
	$Camera2D/UILayer/CommonUI/Energy.energy = $God.energy

func update_tutorial(dt):
	if $God.distance <= 0 and tutorial_step < 1:
		_show_toturial("Press      To Ride")
		$Camera2D/UILayer/keyhit/Up.visible = true
		if Input.is_action_pressed("ui_up"):
			$Camera2D/UILayer/keyhit/Up.visible = false
			_next_tutorial()
	
	if $God.distance > 500 and tutorial_step < 2:
		_show_toturial("Press      To Break")
		$Camera2D/UILayer/keyhit/Down.visible = true
		if Input.is_action_pressed("ui_down"):
			$Camera2D/UILayer/keyhit/Down.visible = false
			_next_tutorial()
	
	if $God.distance > 650 and tutorial_step < 3:
		_show_toturial("Press      To Keep You Moving")
		$Camera2D/UILayer/keyhit/Up.position.x = 520
		$Camera2D/UILayer/keyhit/Up.position.y = 1106
		$Camera2D/UILayer/keyhit/Up.visible = true
		if Input.is_action_pressed("ui_up"):
			$Camera2D/UILayer/keyhit/Up.visible = false
			_next_tutorial()
			
	if $God.distance > 1000 and tutorial_step < 4:
		_show_toturial("Release All Button to Slide")
		if not Input.is_action_pressed("ui_up"):
			_next_tutorial()
	
	if $God.distance > 1500 and tutorial_step < 5:
		_show_toturial("Press      TO Left-leaning")
		$Camera2D/UILayer/keyhit/Left.visible = true
		if Input.is_action_pressed("ui_left"):
			$Camera2D/UILayer/keyhit/Left.visible = false
			_next_tutorial()
	
	if $God.distance > 2000 and tutorial_step < 6:
		_show_toturial("Press      TO Right-leaning")
		$Camera2D/UILayer/keyhit/Right.visible = true
		if Input.is_action_pressed("ui_right"):
			$Camera2D/UILayer/keyhit/Right.visible = false
			_next_tutorial()
			
	if $God.distance > 2500 and tutorial_step < 7:
		_show_toturial("Press      TO Boost")
		$Camera2D/UILayer/keyhit/Z.visible = true
		if Input.is_action_pressed("boost"):
			$Camera2D/UILayer/keyhit/Z.visible = false
			_next_tutorial()
	
	if $God.distance > 3500 and tutorial_step < 8:
		_show_toturial("There're some blockers, avoid to hit them")
		if not virtual_shit:
			var new_shit = shit.instance()
			new_shit.x = $God.position.x
			new_shit.y = $God.position.y - 150
			new_shit.scale = Vector2(0.25, 0.25)
			new_shit.velocity = 1
			new_shit.pause_mode = Node.PAUSE_MODE_STOP
			new_shit.name = 'TestShit'
			add_child(new_shit)
			virtual_shit = true
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			_next_tutorial()
			
	if $God.distance > 4000 and tutorial_step < 9:
		_show_toturial("This is your energy bar, when it goes empty, you can only slide")
		$Camera2D/UILayer/EnergyTip.visible = true
		if Input.is_action_pressed("ui_down"):
			$Camera2D/UILayer/EnergyTip.visible = false
			_next_tutorial()
			
	if $God.distance > 4500 and tutorial_step < 10:
		_show_toturial("This is your map")
		$Camera2D/UILayer/MapTip.visible = true
		if Input.is_action_pressed("ui_down"):
			$Camera2D/UILayer/MapTip.visible = false
			_next_tutorial()
			
	if $God.distance > 5000 and tutorial_step < 11:
		_show_toturial("This is your Speedometer, try to get higher speed by the end of the road")
		$Camera2D/UILayer/speedometerTip.visible = true
		if Input.is_action_pressed("ui_down"):
			$Camera2D/UILayer/speedometerTip.visible = false
			_next_tutorial()
	
func update_shit(dt):
	if $God.distance > 3000:
		if not virtual_shit:
			var new_shit = shit.instance()
			new_shit.x = $God.position.x
			new_shit.y = $God.position.y - 200
			new_shit.scale = Vector2(0.25, 0.25)
			new_shit.velocity = 1
			new_shit.pause_mode = Node.PAUSE_MODE_STOP
			new_shit.name = 'TestShit'
			add_child(new_shit)
			virtual_shit = true
		
func _show_toturial(text):
	$Camera2D/UILayer/Tips/TipText.text = text
	get_tree().paused = true

func _next_tutorial():
	get_tree().paused = false
	$Camera2D/UILayer/Tips/TipText.text = ""
	tutorial_step += 1
		
func update_ui():
	$Camera2D.position.y = $God.position.y - 150
	$Camera2D/UILayer/CommonUI/map.distance = 430 - $God.position.y
	$Camera2D/UILayer/CommonUI/Speedometer.velocity = $God.velocity
	$Camera2D/UILayer/CommonUI/Energy.energy = $God.energy

func read_settings():
	var settings_file = File.new()
	settings_file.open("user://settings.ini", File.READ)
	var settings = parse_json(settings_file.get_line())
	if settings:
		bypass_tutorial = settings.get("bypass_tutorial")
		
func save_level(level, final_velocity):
	var level_file = File.new()
	level_file.open("user://level_info.save", File.WRITE)
	var level_info = {
		"level": level,
		"final_velocity": final_velocity
	}
	level_file.store_line(to_json(level_info))
	level_file.close()
	
func _on_God_gameover():
	save_level(0, 0)
	get_tree().change_scene("res://Scene/Menu/GameOver.tscn")