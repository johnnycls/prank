extends Node2D

@export var player_following_cam: Camera2D

@onready var whole_runway = $WholeRunway
@onready var ocean_runway = $OceanRunway
@onready var wilderness_runway = $WildnernessRunway
@onready var forest_runway = $ForestRunway
@onready var desert_runway = $DesertRunway

func _ready() -> void:
	whole_runway.player_following_cam = player_following_cam
	ocean_runway.player_following_cam = player_following_cam
	wilderness_runway.player_following_cam = player_following_cam
	forest_runway.player_following_cam = player_following_cam
	desert_runway.player_following_cam = player_following_cam
