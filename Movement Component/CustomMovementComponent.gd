extends Node
class_name CustomMovementComponent

@export var actor: Player

const JUMP_VELOCITY = 4.5

# Different speeds for different movement states
var walking_speed: float = 5.0
var sprint_speed: float = walking_speed * 1.75
var crouching_speed: float = walking_speed * 0.65
var current_speed = walking_speed

# Sprinting variables
var is_sprinting: bool = false
func _physics_process(delta: float) -> void:
	
	handle_sprint()
	
	# Add the gravity.
	if not actor.is_on_floor():
		actor.velocity += actor.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and actor.is_on_floor():
		actor.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		actor.velocity.x = direction.x * current_speed
		actor.velocity.z = direction.z * current_speed
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, current_speed)
		actor.velocity.z = move_toward(actor.velocity.z, 0, current_speed)
	
	actor.move_and_slide()
	print(current_speed)

func handle_sprint() -> void:
	# Check if the player has released the sprint button 
	if Input.is_action_just_released("sprint"):
		current_speed = walking_speed
		is_sprinting = false
	# If the player is already sprinting, there's no need to constantly set current_speed
	# With walking speed. is_sprinting flag is used to stop this.
	elif is_sprinting:
		return
	
	# Check if the player has pressed the sprint button and set the current_speed to sprinting_speed
	if Input.is_action_just_pressed("sprint"):
		current_speed = sprint_speed
		is_sprinting = true
