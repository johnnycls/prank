extends AudioStreamPlayer

var bgm_list = [
	preload("res://assets/bgm/0Light Ambience 3.wav"),
	preload("res://assets/bgm/1konekonoosanpo.mp3")
]

@export var fade_duration: float = 1.0
var current_bgm: int = -1

func play_bgm(bgm_no: int, from_position: float = 0.0):
	if bgm_no == current_bgm:
		return
		
	if bgm_no!=-1 and bgm_list.size()>bgm_no:
		current_bgm = bgm_no
		stream = bgm_list[bgm_no]
		play(from_position)

func stop_bgm():
	stop()
	current_bgm = -1

func fade_in():
	volume_db = -80
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0, fade_duration)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, fade_duration)
	await tween.finished
	stop()
