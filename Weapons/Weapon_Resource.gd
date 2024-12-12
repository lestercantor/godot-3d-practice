extends Resource
class_name WeaponResource

enum WeaponType {
	Melee,
	Hitscan,
	Projectile
}

@export var min_damage: float
@export var max_damage: float
@export var damage_range: float

@export var name: String
@export var weapon_type: WeaponType

#@export var model_for_player: PackedScene
