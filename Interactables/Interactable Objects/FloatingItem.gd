extends Interactable

@export var spin_speed: float = 130 # Spin speed

@onready var staff_whole: Node3D = $Staff_Whole

var is_on_ground: bool = false

@export var rigid_body: RigidBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	# Checks if the object is not on the ground yet. Mainly a check for uneven surfaces
	# Once the object is on the ground, it doesn't need to carry on checking so we set is_on_ground to true
	# Play the floating up and down animation and set the linear damp to act as "friction"
	if !is_on_ground and (rigid_body.linear_velocity.y == 0):
		is_on_ground = true
		animation_player.play("floating", -1 ,1.5)
		rigid_body.set_linear_damp(1.5)
		
	spin(delta)

# Placeholder interact function. Adds impulse to the object - gets the horizontal direction
# From the player so it will always seem like the object is being pushed away from the player.
func on_interact(player: Player) -> void:
	var direction = player.position.direction_to(self.position).normalized()
	var horizontal_direction = Vector3(direction.x, 0, direction.z)
	rigid_body.apply_central_impulse(horizontal_direction * 20)

# Function to make the mesh spin
func spin(delta: float) -> void:
	staff_whole.rotate_y(deg_to_rad(spin_speed * delta))
