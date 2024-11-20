extends RayCast3D

signal start_colliding(object: Interactable)
signal end_colliding()

@export var interact_range: float = 1

var already_colliding: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position.z = interact_range

func _physics_process(delta: float) -> void:
	# Check if the raycast is colliding with something and we're not already colliding 
	if is_colliding() and !already_colliding:
		# Check if the object the raycast is colliding with has the "Interactable" class
		var collider = get_collider()
		if collider is Interactable:
			print(collider.message + " is interactable")
			
			# Set already_colliding to true so that it doesn't get called every frame
			already_colliding = true
			# Emit the signal that the raycast has collided with something and pass the interactable object
			start_colliding.emit(collider)
	
	# Check when the player has looked away from the interactable object 
	# Emit the signal that the raycast has stopped and set already_colliding to false so it's not called every frame
	elif !is_colliding() and already_colliding:
		end_colliding.emit()
		already_colliding = false
