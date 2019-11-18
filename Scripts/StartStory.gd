extends Node2D

var finished = false
var level1 = preload("res://Scene/Levels/Level1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Opening")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play()
		if finished:
			get_tree().change_scene_to(level1)

func pause_animation():
	$AnimationPlayer.stop(false)
	
func finish_story():
	finished = true