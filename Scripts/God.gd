extends Node2D

var sound_delay = 0
var kd = 2.0
var mess = 10
var energy_recovery = 0.1
var kv = 300

var velocity = 0
var state = 0
var energy = 100
var accelerate = 0
var force = 0
var drag = 0
var break_force = 0
var distance = 0
var crashed = 0

signal gameover

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	sound_delay += delta
	if crashed > 0:
		crashed -= 1
	else:
		update_distance(delta, velocity)
		update_drag(velocity)
		update_force()
		update_animation()
		update_acceleration(force, drag)
		update_velocity(accelerate, delta)
		update_energy(force)
		if Input.is_action_pressed("ui_left"):
			position.x -= 2
		elif Input.is_action_pressed("ui_right"):
			position.x += 2
		position.y -= velocity * delta * kv
		update_bg()
	
		
func update_force():
	if Input.is_action_pressed('boost'):
		force = 10
		sound_delay = 1
		$AnimatedSprite.set_speed_scale(2)
	else:
		force = 5
		$AnimatedSprite.set_speed_scale(1)
		

func update_animation():
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.play('left')
	elif Input.is_action_pressed("ui_right"):
		$AnimatedSprite.play('right')
	else:
		$AnimatedSprite.play('ride')
	
	if not Input.is_action_pressed('ui_up') or energy <= 0:
		force = 0
		$AnimatedSprite.stop()
	
	if $AnimatedSprite.playing and not $ride_sfx.playing and sound_delay > 0.3:
		sound_delay = 0
		$ride_sfx.play()
	
	if not $AnimatedSprite.playing and not $slide.playing and velocity > 0.001 and sound_delay > 0.1 * 1/velocity:
		sound_delay = 0
		$slide.play()
	
	if Input.is_action_pressed("ui_down") and velocity > 0:
		break_force = 8
	else:
		break_force = 0
		
			
func update_distance(dt, v):
	distance += v * kv * dt

func update_drag(v):
	drag = v * v * kd
	
func update_acceleration(f, fd):
	accelerate = (f - break_force - fd) / mess

func update_velocity(a, dt):
	velocity += a * dt
	
func update_energy(f):
	if f == 10:
		energy -= 0.4
	elif f == 5:
		energy -= 0.2
	if not (energy <= 0 and Input.is_action_pressed('ui_up')) and energy < 100:
		energy += energy_recovery

func update_bg():
	if velocity > 0.8 and velocity < 2 and not $low_speed.playing:
		$high_speed.stop()
		$low_speed.play()
	
	if velocity >= 2 and not $high_speed.playing:
		$low_speed.stop()
		$high_speed.play()

func _on_Area2D_body_entered(body):
	if body != $RigidBody2D:
		$crash.play()
		if velocity < 1.5:
			$AnimatedSprite.play('crash')
			velocity = 0
			crashed = 30
		else:
			emit_signal("gameover")
