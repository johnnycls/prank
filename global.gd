extends Node

func is_node_valid(node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
	
func get_valid_nodes_in_group(group_name: String) -> Array:
	return get_tree().get_nodes_in_group(group_name).filter(func(node):
		return is_node_valid(node)
	)

func move_with_tween(object: Node2D, target_pos: Vector2, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(object, "global_position", target_pos, duration)
	# tween.set_trans(Tween.TRANS_CUBIC)
	# tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
func play_sound(audio_player: AudioStreamPlayer, sound: AudioStream = null, should_wait: bool = false):
	if not is_instance_valid(audio_player):
		return
	if sound:
		audio_player.stream = sound
	elif not audio_player.stream:
		return
	audio_player.play()
	if should_wait:
		await audio_player.finished

func wait(duration: float):
	var timer = get_tree().create_timer(duration)
	await timer.timeout

func load_lang() -> void:	
	if FileAccess.file_exists(Config.PREFERENCE_PATH):
		var file: FileAccess = FileAccess.open(Config.PREFERENCE_PATH, FileAccess.READ)
		var settings: Dictionary = file.get_var()
		file.close()
		var lang_id: int = settings.get("language", 0)
		
		var lang_id_to_code: Dictionary = {}
		var _id: int = 0
		for code in Config.LANGS.keys():
			lang_id_to_code[_id] = code
			_id += 1
		TranslationServer.set_locale(lang_id_to_code[lang_id])
	else:
		TranslationServer.set_locale(Config.DEFAULT_LANG)
