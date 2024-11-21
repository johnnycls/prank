extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var camera: Camera2D = $Camera2D

@export var cam_lim_top: int = -10000000
@export var cam_lim_bottom: int = 10000000
@export var cam_lim_left: int = -100000000
@export var cam_lim_right: int = 100000000
@export var show_cam: bool = true

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





@export var move_speed : float = 400.0
@export var jump_velocity : float = -500.0
@export var gravity : float = 1500.0
@export var jump_cut_height : float = 0.0
@export var max_jump_time : float = 0.3

var current_jump_time : float = 0.0
var is_jumping : bool = false

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
		if is_jumping:
			if Input.is_action_pressed("ui_up"):
				current_jump_time += delta
				if current_jump_time > max_jump_time:
					is_jumping = false
			else:
				if velocity.y < 0:
					velocity.y *= jump_cut_height
				is_jumping = false

	if Input.is_action_just_pressed("ui_up"):
		jump()

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()

	if is_on_floor():
		is_jumping = false
		current_jump_time = 0.0

func jump() -> void:
	velocity.y = jump_velocity
	is_jumping = true
	current_jump_time = 0.0
	
	
	
	
	
	
	
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
