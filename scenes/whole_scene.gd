extends Node2D

signal castle_changed_scene(scene: String)

@export var player_following_cam: Camera2D

@onready var castle_scene = $CastleScene
@onready var whole_runway = $WholeRunway
@onready var ocean_runway = $OceanRunway
@onready var wilderness_runway = $WildnernessRunway
@onready var forest_runway = $ForestRunway
@onready var desert_runway = $DesertRunway

func castle_center() -> Vector2:
	return castle_scene.center()

func _ready() -> void:
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

func init_castle(scene: String) -> void:
	castle_scene.init(scene)
