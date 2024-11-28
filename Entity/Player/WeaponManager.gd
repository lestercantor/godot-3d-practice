extends Node3D
class_name WeaponManager

var weapon1: WeaponResource = null

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#weapon1 = FireStaff.new()
	#var weapon_node = weapon1.model.instantiate()
	#add_child(weapon_node)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		print(weapon1.max_damage)
