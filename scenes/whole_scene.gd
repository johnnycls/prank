extends Node2D

signal castle_changed_scene(scene: String)
signal house1_changed_scene(scene: String)

@export var player_following_cam: Camera2D
@export var ocean_revolution: int = 15
@export var wildnerness_revolution: int = 25
@export var forest_revolution: int = 35
@export var desert_revolution: int = 40

@onready var background = $Background
@onready var castle_scene = $CastleScene
@onready var whole_runway = $WholeRunway
@onready var ocean_runway = $OceanRunway
@onready var wilderness_runway = $WildnernessRunway
@onready var forest_with_houses = $ForestWithHousesScene
@onready var forest_runway = $ForestRunway
@onready var desert_runway = $DesertRunway

func castle_center() -> Vector2:
	return castle_scene.center()
	
func house1_center() -> Vector2:
	return forest_with_houses.center()
	
func _ready() -> void:
	ocean_runway.revolution = ocean_revolution
	wilderness_runway.revolution = wildnerness_revolution
	forest_runway.revolution = forest_revolution
	desert_runway.revolution = desert_revolution
	
func init(_player_following_cam: Camera2D):
	player_following_cam = _player_following_cam
	whole_runway.player_following_cam = player_following_cam
	ocean_runway.player_following_cam = player_following_cam
	wilderness_runway.player_following_cam = player_following_cam
	forest_runway.player_following_cam = player_following_cam
	desert_runway.player_following_cam = player_following_cam
	
	whole_runway.init()
	ocean_runway.init()
	wilderness_runway.init()
	forest_runway.init()
	desert_runway.init()	

func _on_castle_scene_castle_changed_scene(scene: String) -> void:
	if scene!="outside":
		for i in get_children():
			i.hide()
		$CastleScene.show()
	else:
		for i in get_children():
			i.show()
	castle_changed_scene.emit(scene)

func set_castle_scene(scene: String, audio_play: bool = false) -> void:
	castle_scene.set_scene(scene, audio_play)
	
func _on_forest_with_houses_scene_house_1_changed_scene(scene: String) -> void:
	if scene!="outside":
		for i in get_children():
			i.hide()
		$ForestWithHousesScene.show()
	else:
		for i in get_children():
			i.show()
	house1_changed_scene.emit(scene)
	
func set_house1_scene(scene: String, audio_play: bool = false) -> void:
	forest_with_houses.set_scene(scene, audio_play)

func get_cam_distance() -> float:
	return (player_following_cam.global_position.x if Global.is_node_valid(player_following_cam) else 0.0) + ocean_runway.current_revolution*ocean_runway.total_length + wilderness_runway.current_revolution*wilderness_runway.total_length + forest_runway.current_revolution*forest_runway.total_length + desert_runway.current_revolution*desert_runway.total_length

func _physics_process(_delta: float) -> void:
		background.set_offset_by_distance(get_cam_distance())

func _on_whole_runway_exited(is_left: bool) -> void:
	if is_left:
		ocean_runway.current_revolution = ocean_revolution
		wilderness_runway.current_revolution = wildnerness_revolution
		forest_runway.current_revolution = forest_revolution
		desert_runway.current_revolution = desert_revolution
	else:
		ocean_runway.current_revolution = 0
		wilderness_runway.current_revolution = 0
		forest_runway.current_revolution = 0
		desert_runway.current_revolution = 0
