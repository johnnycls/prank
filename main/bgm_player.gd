extends AudioStreamPlayer

var bgm_list = [
	preload("res://assets/bgm/29 A Daydream.ogg"),
	preload("res://assets/bgm/19 Lammas Festival alternate loop.ogg"),
	preload("res://assets/bgm/7 Memory Box.ogg"),
]

var current_bgm: int = -1
var base_volume_db: float = 0.0
@onready var next_player = AudioStreamPlayer.new()

func _ready():
	add_child(next_player)
	next_player.bus = bus 

func play_bgm(bgm_no: int, fade_duration: float, from_position: float):
	if bgm_no == current_bgm:
		return
		
	if bgm_no != -1 and bgm_list.size() > bgm_no:
		if fade_duration > 0:
			next_player.stream = bgm_list[bgm_no]
			next_player.volume_db = -80
			next_player.play(from_position)
			
			var fade_out = create_tween()
			var fade_in = create_tween()
			fade_out.tween_property(self, "volume_db", -80, fade_duration)
			fade_in.tween_property(next_player, "volume_db", base_volume_db, fade_duration)
			
			await fade_out.finished
			
			stream = next_player.stream
			play(next_player.get_playback_position())
			next_player.stop()
			volume_db = base_volume_db
		else:
			stop()
			stream = bgm_list[bgm_no]
			volume_db = base_volume_db
			play(from_position)
		current_bgm = bgm_no

func stop_bgm(fade_duration: float = 1.0):
	current_bgm = -1
	if playing:
		if fade_duration > 0:
			var fade_out = create_tween()
			fade_out.tween_property(self, "volume_db", -80, fade_duration)
			await fade_out.finished
		stop()

func fade_volume(target_volume_db: float, duration: float = 0.0):
	base_volume_db = target_volume_db
	if duration > 0:
		var tween = create_tween()
		tween.tween_property(self, "volume_db", target_volume_db, duration)
	else:
		volume_db = target_volume_db
