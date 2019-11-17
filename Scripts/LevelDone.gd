extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var level_info = load_level()
	$Velocity.text = str(level_info.final_velocity)

func load_level():
	var level_file = File.new()
	level_file.open("user://level_info.save",  File.READ)
	var level_info = parse_json(level_file.get_line())
	level_file.close()
	return level_info
