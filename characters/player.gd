extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visible_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var jump_audio: AudioStreamPlayer = $JumpAudio
@onready var run_audio: AudioStreamPlayer = $RunAudio

@export var move_speed : float = 3500.0
@export var jump_speed : float = 3500.0
@export var acceleration_due_to_gravity : float = 3000.0
@export var acceleration_due_to_air_resistance: float = 2000.0
@export var max_jump_time : float = 0.3
@export var rotational_speed : float = 3.0
@export var can_fly: bool = true

var jump_sound = preload("res://assets/audio/jump.wav")
var land_sound = preload("res://assets/audio/land.wav")

var current_jump_time : float = 0.0
var walking_velocity: Vector2 = Vector2.ZERO
var rotated_jumping_velocity: Vector2 = Vector2.ZERO
var gravitational_velocity: Vector2 = Vector2.ZERO
var is_jumping: bool = false

func _stop_jumping():
	is_jumping = false
	rotated_jumping_velocity.x = 0
	if -rotated_jumping_velocity.y > gravitational_velocity.y:
		rotated_jumping_velocity.y = -gravitational_velocity.y

func _physics_process(delta) -> void:
	var rotation_input = Input.get_axis("rotate_anticlockwise", "rotate_clockwise")
	rotation += rotation_input * rotational_speed * delta
	
	var direction = Input.get_axis("move_left", "move_right")
	walking_velocity.x = direction * move_speed
	var rotated_walking_velocity = walking_velocity.rotated(rotation)
	
	if is_on_floor() and gravitational_velocity.y > 0:
		jump_audio.stream = land_sound
		jump_audio.play()
	if is_on_floor() and abs(walking_velocity.x) > 1000:
		if not run_audio.playing:
			run_audio.play()
	else:
		run_audio.stop()
	
	if is_on_floor():
		rotated_jumping_velocity.y = 0
		gravitational_velocity.y = 0
	else:
		gravitational_velocity.y += acceleration_due_to_gravity * delta
		
	if Input.is_action_just_pressed("move_up") and (can_fly or is_on_floor()):
		jump_audio.stream = jump_sound
		jump_audio.play()
		is_jumping = true
		current_jump_time = 0
		rotated_jumping_velocity += Vector2(0, -jump_speed).rotated(rotation)
	elif Input.is_action_pressed("move_up"):
		current_jump_time += delta
		if current_jump_time > max_jump_time:
			_stop_jumping()
	elif is_jumping:
		_stop_jumping()
	
	if abs(rotated_jumping_velocity.x) > 0:
		var resistance = acceleration_due_to_air_resistance * cos(rotation) * delta
		rotated_jumping_velocity.x = move_toward(rotated_jumping_velocity.x, 0, resistance)
		
	velocity = rotated_jumping_velocity + rotated_walking_velocity + gravitational_velocity
	move_and_slide()
	
	
	
	
	
	
	
signal dead
signal left_screen

var splash_sound = preload("res://assets/audio/splash.wav")
var hit_sound = preload("res://assets/audio/hit.mp3")
var grab_sound = preload("res://assets/audio/grab_catus.mp3")

@export var show_hp: bool = true
@export var invincible_time: float = 0.2
@onready var hp_label = $HPLabel
@onready var hit_audio = $HitAudio

var hp: float = 100.0
var is_invincible: bool = false

func init() -> void:
	current_jump_time = 0.0
	walking_velocity = Vector2.ZERO
	rotated_jumping_velocity = Vector2.ZERO
	gravitational_velocity = Vector2.ZERO
	is_jumping = false
	
	if show_hp:
		hp_label.show()
	else:
		hp_label.hide()
		
	hp = 100.0
	hp_label.text = "%.2f" % hp + "/ 100"
	
func die():
	dead.emit()
	
func hit(damage:float, audio):
	if not is_invincible:
		if audio:
			hit_audio.stream = audio
			hit_audio.play()
		is_invincible = true
		hp -= damage
		hp_label.text = "%.2f" % hp + "/ 100"
		if hp<=0:
			die()
		var timer = get_tree().create_timer(invincible_time)
		await timer.timeout
		is_invincible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		hit(area.damage, splash_sound if area.is_in_group("poop") else hit_sound)
	if area.is_in_group("remove_when_touched_by_player"):
		area.queue_free()
	if area.is_in_group("foods"):
		Global.play_sound(hit_audio, grab_sound)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("killzone"):
		hit(body.damage, splash_sound if body.is_in_group("poop") else hit_sound)
	if body.is_in_group("remove_when_touched_by_player"):
		body.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	left_screen.emit()
