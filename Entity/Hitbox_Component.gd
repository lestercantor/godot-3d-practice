extends Area3D
class_name Hitbox

signal hit_hurtbox(hurtbox: Hurtbox)

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(hurtbox: Hurtbox) -> void:
	# Check if we are not colliding with a hurtbox and return out of function if true
	if not hurtbox is Hurtbox: return
	
	var attack = Attack._damage(10)
	
	# Signal we have hit a hurtbox (useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hurtbox)
	
	# Signal out itself and the attack that was made
	hurtbox.hurt.emit(self, attack)
