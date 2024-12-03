extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var camera: Camera2D = $Camera2D

@export var cam_lim_top: int = -10000000
@export var cam_lim_bottom: int = 10000000
@export var cam_lim_left: int = -100000000
@export var cam_lim_right: int = 100000000
@export var show_cam: bool = true
@export var show_hp: bool = true

func set_cam_lim(_cam_lim_top: int, _cam_lim_bottom: int, _cam_lim_left: int, _cam_lim_right: int) -> void:
	camera.limit_top = _cam_lim_top
	camera.limit_bottom = _cam_lim_bottom
	camera.limit_left = _cam_lim_left
	camera.limit_right = _cam_lim_right
	cam_lim_top = _cam_lim_top
	cam_lim_bottom = _cam_lim_bottom
	cam_lim_left = _cam_lim_left
	cam_lim_right = _cam_lim_right

func _ready() -> void:
	if not show_cam:
		disable_camera()
	if not show_hp:
		hp_label.hide()
	camera.limit_top = cam_lim_top
	camera.limit_bottom = cam_lim_bottom
	camera.limit_left = cam_lim_left
	camera.limit_right = cam_lim_right
	
	var zoom_factor = Global.get_zoom_factor()
	camera.zoom = zoom_factor
	camera.offset = Vector2(collision_shape.shape.size.x, -200.0) / zoom_factor

func disable_camera() -> void:
	camera.enabled = false 
	
func enable_camera() -> void:
	camera.enabled = true
	
func teleport(new_pos: Vector2) -> void:
	camera.position_smoothing_enabled = false
	global_position = new_pos
	camera.reset_smoothing()
	camera.position_smoothing_enabled = true









@export var move_speed : float = 1250.0
@export var jump_speed : float = 1250.0
@export var acceleration_due_to_gravity : float = 1250.0
@export var acceleration_due_to_air_resistance: float = 1000.0
@export var max_jump_time : float = 0.3
@export var rotational_speed : float = 3.0
@export var can_fly: bool = true

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
	
	if is_on_floor():
		rotated_jumping_velocity.y = 0
		gravitational_velocity.y = 0
	else:
		gravitational_velocity.y += acceleration_due_to_gravity * delta
		
	if Input.is_action_just_pressed("move_up") and (can_fly or is_on_floor()):
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
	
	
	
	
	
	
	
signal die
signal area_or_body_entered(area_or_body: Node2D)

@export var invincible_time: float = 2.0
@onready var hp_label = $HPLabel

var hp: float = 100.0
var is_invincible: bool = false

func init() -> void:
	hp = 100.0
	hp_label.text = "%.2f" % hp + "/ 100"
	
func hit(damage:float):
	if not is_invincible:
		is_invincible = true
		hp -= damage
		hp_label.text = "%.2f" % hp + "/ 100"
		if hp<=0:
			die.emit()
		var timer = get_tree().create_timer(invincible_time)
		await timer.timeout
		is_invincible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	area_or_body_entered.emit(area)

func _on_area_2d_body_entered(body: Node2D) -> void:
	area_or_body_entered.emit(body)
