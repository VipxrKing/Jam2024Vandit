extends RigidBody3D
class_name Weapon

var active:bool = false

func turn(pbool:bool):
	$Hitbox.active = pbool
