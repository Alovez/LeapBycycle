extends Node2D

var finished = false
var choose = preload("res://Scene/Menu/LevelChoose.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Opening")
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play()
		if finished:
			get_tree().change_scene_to(choose)
	
	if Input.is_action_pressed("boost"):
		$Z/AnimationPlayer.play("skip")
	else:
		$Z/AnimationPlayer.play("stop")

func pause_animation():
	$AnimationPlayer.stop(false)
	
func finish_story():
	finished = true
	
func skip_story():
	get_tree().change_scene_to(choose)