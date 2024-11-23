extends Interactable

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var door_open: bool = false
@export var open_speed: float = 2

func on_interact(_body) -> void:
	if !door_open:
		animation_player.play("open_door", -1, open_speed)
		door_open = true
	else:
		animation_player.play("open_door", -1, -open_speed, true)
		door_open = false
