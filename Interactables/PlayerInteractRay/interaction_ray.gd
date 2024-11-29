extends RayCast3D
class_name InteractionRay

@export var interact_range: float = 1

var actor_to_interact_with: Interactable = null

@onready var prompt: Label = $Prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position.z = interact_range
	prompt.text = ""

func _process(delta: float) -> void:
	# Check if the raycast is colliding with something and we're not already colliding 
	if is_colliding():
		if get_collider() != actor_to_interact_with:
			# Check if the object the raycast is colliding with has the "Interactable" class
			var collider = get_collider()
			if collider is Interactable:
				# Set the actor_to_interact_with to the collider so we can check so we can check if the raycast
				# Is colliding with the same actor or not 
				actor_to_interact_with = collider
				# Set the prompt to be visible and set the text
				prompt.set_visible(true)
				prompt.text = collider.get_prompt()
	
	# Check when the player has looked away from the interactable object 
	# Emit the signal that the raycast has stopped 
	
	# Check if the raycast is NOT colliding and the prompt is still visibile so it's not called every frame
	# Because if we are not colliding with anything then the prompt should not be visible.
	elif !is_colliding() and (prompt.visible == true):
		prompt.set_visible(false)
		prompt.text = ""
		actor_to_interact_with = null
