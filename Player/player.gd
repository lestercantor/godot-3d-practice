extends CharacterBody3D
class_name Player

@export var sensitivity: float = 0.3

@onready var head: Node3D = $head
@onready var collision_shape: CapsuleShape3D = $PlayerCapsule.get_shape()


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
