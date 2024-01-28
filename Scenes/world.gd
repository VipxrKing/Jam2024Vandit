extends Node3D

const KEY = preload("res://Scenes/Areas/key.tscn")

var snail:bool = false

func _on_area_3d_body_entered(body):
	if body is Player and !snail:
		$Snails/AnimationPlayer.play("race")

func spawn_key():
	var a  = KEY.instantiate()
	add_child(a)
	a.global_position = $Snails/Babosa4.global_position + Vector3(0,3,0)
	snail = true
