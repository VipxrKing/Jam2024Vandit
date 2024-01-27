extends Area3D
class_name Hurtbox

@export var active:bool = true
@export var hurtbox_damage_multiplier:float = 1.0
@export var main_script_route:Node = null

func change_hp(ammount):
	main_script_route.change_hp(ammount*hurtbox_damage_multiplier)
