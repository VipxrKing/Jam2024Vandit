extends Area3D

func _on_body_entered(body):
	if body is Player:
		Utils.keys += 1
		queue_free()
