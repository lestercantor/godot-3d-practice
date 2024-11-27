extends Node
class_name HealthComponent

signal health_changed(new_health: float)
signal no_health

# Get the hurtbox node
@export var hurtbox: Hurtbox

@export_group("Health")
@export var max_health: float = 100.0
@export var health: float = max_health:
	set(value):
		# Clamp health so if there is any healing it won't go over max
		# And won't deal negative damage
		# snappedf function rounds the number to the nearest step 
		# 0.01 means it will be rounded to 2 decimal places
		health = snappedf(clampf(value, 0, max_health), 0.01)
		
		# Signal that the health has changed so we can perform other functions
		# Such as UI changes
		health_changed.emit(health)
		
		# Signal that there is no health to play animations then queue_free()
		if health <= 0: no_health.emit()

func _ready() -> void:
	hurtbox.hurt.connect(got_hit)
	
func got_hit(_hitbox: Hitbox, received_attack: Attack) -> void:
	# Subtract health the damage that was dealth
	health -= received_attack.damage
	print("received damage was: %s", received_attack)
