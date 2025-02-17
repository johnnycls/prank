extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var jump_audio: AudioStreamPlayer = $JumpAudio
@onready var run_audio: AudioStreamPlayer = $RunAudio
@onready var wing: TextureRect = $Wing
@onready var no_wing: TextureRect = $NoWing

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

var is_jump_just_pressed: bool = false
var is_jump_pressed: bool = false
var rotation_input: float = 0.0 
var direction: float = 0.0

func _ready() -> void:
	if can_fly:
		wing.show()
		no_wing.hide()
	else:
		wing.hide()
		no_wing.show()
		
func _stop_jumping():
	is_jumping = false
	rotated_jumping_velocity.x = 0
	if -rotated_jumping_velocity.y > gravitational_velocity.y:
		rotated_jumping_velocity.y = -gravitational_velocity.y
	
func _physics_process(delta) -> void:
	rotation += rotation_input * rotational_speed * delta
	
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
		
	if is_jump_just_pressed and (can_fly or is_on_floor()):
		jump_audio.stream = jump_sound
		jump_audio.play()
		is_jumping = true
		current_jump_time = 0
		rotated_jumping_velocity += Vector2(0, -jump_speed).rotated(rotation)
	elif is_jump_pressed:
		current_jump_time += delta
		if current_jump_time > max_jump_time:
			_stop_jumping()
	elif is_jumping:
		_stop_jumping()
	is_jump_just_pressed = false
	
	if abs(rotated_jumping_velocity.x) > 0:
		var resistance = acceleration_due_to_air_resistance * cos(rotation) * delta
		rotated_jumping_velocity.x = move_toward(rotated_jumping_velocity.x, 0, resistance)
		
	velocity = rotated_jumping_velocity + rotated_walking_velocity + gravitational_velocity
	move_and_slide()
