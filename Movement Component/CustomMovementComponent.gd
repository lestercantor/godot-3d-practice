extends Node
class_name CustomMovementComponent

@export var actor: Player

const JUMP_VELOCITY = 4.5
const FRICTION: float = 55

# Different speeds for different movement states
var walking_speed: float = 5.0
var sprint_speed: float = walking_speed * 1.75
var crouching_speed: float = walking_speed * 0.65
var current_speed = walking_speed
var midair_speed = 5

# Sprinting variables
var is_sprinting: bool = false

# Crouching variables
@export_range(5, 10, 0.1) var CROUCH_SPEED: float = 8.5
var is_crouching: bool = false
var can_crouch: bool = true
@export var uncrouch_space: ShapeCast3D

# Check if actor is falling
var is_falling: bool = false

# Movement states for walking, sprinting and crouching
# Mainly to be used for maintaining speed in the air. 
enum MovementState { WALKING, SPRINTING, CROUCHING }
var move_state: MovementState = MovementState.WALKING

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not actor.is_on_floor():
		actor.velocity += actor.get_gravity() * delta
		is_falling = true
	else:
		is_falling = false
		
		# Change speeds according to movement states
		# Done in the process function to check if the actor is on the ground.
		
		# SUGGESTION: Could make a signal for when the actor has landed on the ground 
		# to apply the appropriate speed
		match move_state:
			MovementState.WALKING: 
				current_speed = walking_speed
				
			MovementState.SPRINTING:
				current_speed = sprint_speed
				
			MovementState.CROUCHING:
				current_speed = crouching_speed
		
	# Handle jump. Check if the actor is crouching and prevent them from jumping
	if Input.is_action_just_pressed("jump"):
		handle_jump()
			
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if actor.is_on_floor():
		if direction:
			actor.velocity.x = direction.x * current_speed
			actor.velocity.z = direction.z * current_speed
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, FRICTION * delta)
			actor.velocity.z = move_toward(actor.velocity.z, 0, FRICTION * delta)
	else:
		# Movement for when the player is mid air. Prevents the player from suddenly moving in a different direction
		# So the player carries on moving towards the direction they were moving towards
		# midair_speed variable is how much control the player has in the air
		actor.velocity.x = move_toward(actor.velocity.x, direction.x * current_speed, delta * midair_speed)
		actor.velocity.z = move_toward(actor.velocity.z, direction.z * current_speed, delta * midair_speed)
	actor.move_and_slide()

func _input(event: InputEvent) -> void:
	# Input events to handle crouching
	#if event.is_action_pressed("crouch") and !is_crouching:
		#handle_crouch(true)
	#if event.is_action_released("crouch") and is_crouching:
		#handle_crouch(false)
	if event.is_action_pressed("crouch"):
		toggle_crouch()
	
	# Input events to handle sprinting
	if event.is_action_pressed("sprint") and !is_crouching and actor.is_on_floor():
		handle_sprint(true)
	if event.is_action_released("sprint"):
		handle_sprint(false)

func handle_crouch(state: bool) -> void:
	match state:
		true:
			start_crouch()
		false:
			end_crouch()

func handle_sprint(state: bool) -> void:
	match state:
		true:
			is_sprinting = true
			# Change to sprinting state
			move_state = MovementState.SPRINTING
			actor.update_fov()
		false:
			is_sprinting = false
			# When the player lets go of the sprint key and they are crouching
			# Return out of the function so it doesn't move to walking state speed while crouching
			if is_crouching:
				return
			# If not crouching then move to walking state
			move_state = MovementState.WALKING
			actor.update_fov()

func toggle_crouch() -> void:
	if !is_crouching:
		start_crouch()
		
	else:
		end_crouch()

func start_crouch() -> void:
	# Play crouch animation and change movement state to crouching 
	actor.animation_player.play("crouch", -1, CROUCH_SPEED)
	move_state = MovementState.CROUCHING

	# Enable the uncrouch space only when the player is crouching
	uncrouch_space.set_enabled(true)

	print("crouching")
	# Swap the is_crouching boolean 
	is_crouching = !is_crouching
	actor.update_fov()
	
func end_crouch() -> void:
	# Check if there is collision above the player so return out of the function
	# to prevent the player from standing up
	if uncrouch_space.is_colliding(): 
		print("wants to uncrouch")
		return
	
	# Stop crouching and play animation and switch back to walking 
	actor.animation_player.play("crouch", -1, -CROUCH_SPEED, true)
	# Stop the uncrouch space from checking for collision
	uncrouch_space.set_enabled(false)
	if is_sprinting:
		move_state = MovementState.SPRINTING
	else:
		move_state = MovementState.WALKING
	print("not crouching")
	
	# Swap the is_crouching boolean 
	is_crouching = !is_crouching
	actor.update_fov()

func handle_jump() -> void:
	if actor.is_on_floor():
		# If the player is on the floor and not crouching then jump
		if !is_crouching:
			actor.velocity.y = JUMP_VELOCITY
		# End crouching if jump key is pressed and player is crouching
		else:
			end_crouch()
	else:
		# Allows the player to uncrouch mid air by pressing the jump key again 
		# If they are crouching in the air
		if is_crouching:
			end_crouch()
			
# Helper function to check if the player is moving 
func is_moving() -> bool:
	return (abs(actor.velocity.x) != 0) or (abs(actor.velocity.z) != 0)
