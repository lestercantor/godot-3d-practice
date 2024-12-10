extends Node3D
class_name WeaponManager

var primary_weapon: WeaponResource = null
var second_weapon: WeaponResource = null

var primary_weapon_model: Node3D = null
var second_weapon_model: Node3D = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_weapon"):
		swap_weapon()
		
	# Debug purposes
	if event.is_action_pressed("debug_key"):
		if primary_weapon_model.visible == true:
			print(primary_weapon.name)
			print(primary_weapon.max_damage)
		if second_weapon_model.visible == true:
			print(second_weapon.name)
			print(second_weapon.max_damage)
		

# Used in the interaction of the world model weapon to assign the first weapon
# that they pick up as their primary
func equip_to_empty_slot(interacting_weapon: WeaponResource) -> bool:
	if is_primary_weapon_empty():
		assign_weapon("primary_weapon", interacting_weapon)
		return true
	elif is_second_weapon_empty():
		assign_weapon("second_weapon", interacting_weapon)
		hide_weapon("second_weapon")
		return true
	return false

# Function to assign and show the weapon 
func assign_weapon(weapon_ref: String, weapon: WeaponResource) -> void:
	match weapon_ref:
		"primary_weapon":
			primary_weapon = weapon
			primary_weapon_model = weapon.model.instantiate()
			add_child(primary_weapon_model)
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
	if is_primary_weapon_empty(): 
		print("holding nothing")
		return
	
	# Checks to make sure the player is holding 2 weapons before they can swap weapon
	if (primary_weapon_model.visible == true) and !is_second_weapon_empty():
		hide_weapon("primary_weapon")
		show_weapon("second_weapon")
		
	elif !is_second_weapon_empty():
		if second_weapon_model.visible == true:
			hide_weapon("second_weapon")
			show_weapon("primary_weapon")
			
################################################# Helper functions
func is_primary_weapon_empty() -> bool: #########
	return primary_weapon == null
	
func is_second_weapon_empty() -> bool: ##########
	return second_weapon == null
	
func hide_weapon(weapon_ref: String) -> void: ###
	match weapon_ref:
		"primary_weapon":
			primary_weapon_model.hide()
		"second_weapon":
			second_weapon_model.hide()

func show_weapon(weapon_ref: String) -> void: ####
	match weapon_ref:
		"primary_weapon":
			primary_weapon_model.show()
		"second_weapon":
			second_weapon_model.show()
################################################# Helper functions
