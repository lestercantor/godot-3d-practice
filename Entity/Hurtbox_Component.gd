extends Area3D
class_name Hurtbox

# Area3D where entities can get hurt and take damage
signal hurt(hitbox: Hitbox, attack: Attack)
