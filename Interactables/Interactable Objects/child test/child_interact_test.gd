extends Interactable

@export var body: RigidBody3D

func on_interact(player: Player) -> void:
	var direction: Vector3 = player.position.direction_to(position).normalized()
	body.apply_impulse(direction * 6)
