extends Area3D
class_name Hitbox

@export var active:bool = false
@export var damage:float = 0.0

func _on_area_entered(area):
	if area is Hurtbox and active:
		if area.active and active:
			area.change_hp(-damage)

