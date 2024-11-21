extends CollisionObject3D
class_name Interactable

@export var interact_name: String = ""

# Get the key on the keyboard that is assigned to the interact input event
var interact_key: String = InputMap.action_get_events("Interact")[0].as_text_physical_keycode()

func on_interact(body) -> void:
	print(body.name + " interacted with " + self.name)
	queue_free()

# STRING INTERPOLATION - where %s is a placeholder, and the variables inside the square brackets
# are used in place of the %s in that order
func get_prompt() -> String:
	return "[%s]\n%s" % [interact_key, interact_name]
