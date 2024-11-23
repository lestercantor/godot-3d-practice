extends Interactable

func on_interact(_player: Player) -> void:
	position = lerp(position, position + (Vector3.LEFT * 5), Engine.get_main_loop().root.get_process_delta_time() * 8)
