extends Node3D
class_name WeaponManager

var active_weapon: WeaponResource = null
var second_weapon: WeaponResource = null

var active_weapon_model: Node3D = null
var second_weapon_model: Node3D = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_weapon"):
		helper_swap()
	
	if event.is_action_pressed("shoot"):
		if active_weapon:
			print(active_weapon.name)
	# Debug purposes
	if event.is_action_pressed("debug_key"):
		if active_weapon_model:
			print(active_weapon.name)
			print(active_weapon.max_damage)
		if second_weapon_model:
			print(second_weapon.name)
			print(second_weapon.max_damage)
		

# Used in the interaction of the world model weapon to assign the first weapon
# that they pick up as their primary
func equip_to_empty_slot(interacting_weapon: WeaponResource) -> bool:
	if is_active_weapon_empty():
		assign_weapon("active_weapon", interacting_weapon)
		return true
	elif is_second_weapon_empty():
		assign_weapon("second_weapon", interacting_weapon)
		hide_weapon("second_weapon")
		return true
	return false

# Function to assign and show the weapon 
func assign_weapon(weapon_ref: String, weapon: WeaponResource) -> void:
	match weapon_ref:
		"active_weapon":
			active_weapon = weapon
			active_weapon_model = weapon.model.instantiate()
			add_child(active_weapon_model)
		"second_weapon":
			second_weapon = weapon
			second_weapon_model = weapon.model.instantiate()
			add_child(second_weapon_model)
		_:
			# for debug purposes
			print("invalid weapon_ref string")
			return

func swap_weapon() -> void:
	# return out of the function immediately if the player is holding nothing
	if is_active_weapon_empty(): 
		print("holding nothing")
		return
	
	# Checks to make sure the player is holding 2 weapons before they can swap weapon
	if active_weapon and !is_second_weapon_empty():
		helper_swap()

################################################# Helper functions
func is_active_weapon_empty() -> bool: #########
	return active_weapon == null
	
func is_second_weapon_empty() -> bool: ##########
	return second_weapon == null
	
func hide_weapon(weapon_ref: String) -> void: ###
	match weapon_ref:
		"active_weapon":
			active_weapon_model.hide()
		"second_weapon":
			second_weapon_model.hide()

func show_weapon(weapon_ref: String) -> void: ####
	match weapon_ref:
		"active_weapon":
			active_weapon_model.show()
		"second_weapon":
			second_weapon_model.show()
			
func helper_swap() -> void:
	hide_weapon("active_weapon")
	
	var weapon_temp: WeaponResource = active_weapon
	var weapon_model_temp: Node3D = active_weapon_model
	
	active_weapon = second_weapon
	active_weapon_model = second_weapon_model
	
	second_weapon = weapon_temp
	second_weapon_model = weapon_model_temp
	
	show_weapon("active_weapon")
################################################# Helper functions
