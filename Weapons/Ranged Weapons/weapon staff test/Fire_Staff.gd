extends WeaponResource
class_name FireStaff

func _init() -> void:
	min_damage = 1
	max_damage = 2
	damage_range = 100
	
	name = "Fire Staff"
	weapon_type = WeaponType.Projectile
	
	model = load("res://Weapons/Ranged Weapons/weapon staff test/Weapon_Magic_Staff.tscn")
