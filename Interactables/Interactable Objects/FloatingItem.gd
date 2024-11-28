extends Interactable
class_name WorldModelInteractable

@export var spin_speed: float = 130 # Spin speed
@export var weapon_to_hold: WeaponResource

var is_on_ground: bool = false

@export var rigid_body: RigidBody3D # Assign it to itself to access the variables 
@onready var world_object: Node3D = $World_Object

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interact_name = weapon_to_hold.name
	
func _process(delta: float) -> void:
	# Checks if the object is not on the ground yet. Mainly a check for uneven surfaces
	# Once the object is on the ground, it doesn't need to carry on checking so we set is_on_ground to true
	# Play the floating up and down animation and set the linear damp to act as "friction"
	if !is_on_ground and (rigid_body.linear_velocity.y == 0):
		is_on_ground = true
		animation_player.play("floating", -1 ,1.5)
		rigid_body.set_linear_damp(1.5)
		
	spin(delta)

func on_interact(player: Player) -> void: 
	if not weapon_to_hold: return
	
	player.weapon_manager.weapon1 = weapon_to_hold
	var weapon_model: = weapon_to_hold.model.instantiate()
	player.weapon_manager.add_child(weapon_model)
	self.queue_free()

# Function to make the mesh spin
func spin(delta: float) -> void:
	world_object.rotate_y(deg_to_rad(spin_speed * delta))
