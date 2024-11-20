extends CollisionObject3D
class_name Interactable

@export var message: String = "hello"

func on_interact(body) -> void:
	print(body.name + " interacted with " + self.name)
	queue_free()
