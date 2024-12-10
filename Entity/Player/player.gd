extends CharacterBody3D
class_name Player

@export var sensitivity: float = 0.3

@onready var head: Node3D = $head
@onready var player_camera: Camera3D = $head/MainCam
@onready var collision_shape: CapsuleShape3D = $PlayerCapsule.get_shape()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cmc: CustomMovementComponent = $CustomMovementComponent
@onready var weapon_camera: Camera3D = $head/WeaponManager/SubViewportContainer/SubViewport/WeaponCamera
@onready var weapon_manager: WeaponManager = $head/WeaponManager
@onready var interaction_ray: InteractionRay = $head/InteractionRay


# Changing FOV variables
var base_fov: float = 90
var target_fov: float = 0.0
var bFov_lerp: bool = false
var was_moving: bool = false

func _ready() -> void:
	player_camera.set_fov(base_fov)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	weapon_camera.global_transform = player_camera.global_transform
	
func _physics_process(delta: float) -> void:
	# Check if the player starts or stops moving
	if cmc.is_moving() != was_moving:
		update_fov()
	was_moving = cmc.is_moving()
	
	# Smoothly update FOV if BFov_lerp is active
	if bFov_lerp:
		player_camera.fov = lerp(player_camera.fov, target_fov, delta * 8) 
		# Stop lerp if FOV is close to the target value
		if abs(player_camera.fov - target_fov) < 0.1:
			player_camera.fov = target_fov
			bFov_lerp = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("exit"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sensitivity))
			head.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
			head.rotation.x = clampf(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and interaction_ray.actor_to_interact_with:
		interaction_ray.actor_to_interact_with.call_deferred("on_interact",self)

func update_fov() -> void:
	# Set target FOV based on the movement state
	if cmc.is_sprinting and cmc.is_moving() and !cmc.is_crouching:
		target_fov = base_fov + (cmc.sprint_speed * 2)
	else:
		target_fov = base_fov
	
	bFov_lerp = true # Enable lerping for the smooth transition
