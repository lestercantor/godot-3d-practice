class_name Attack

# Strictly a data class, used for passing attack information
# Between hurtboxes and hitboxes.

static var damage: float = 1

static func _damage(d: float = 1) -> Attack:
	var new_attack = Attack.new
	new_attack.damage = d
	return new_attack
