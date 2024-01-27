extends RigidBody3D

@export var spawns:Array[PackedScene] = [preload("res://Scenes/Areas/key.tscn")]

const COCONUT_SHELL = preload("res://Scenes/RigidBodies/coconut_shell.tscn")

func create_rigid_bodies():
	var a = COCONUT_SHELL.instantiate()
	var b = COCONUT_SHELL.instantiate()
	var c = spawns.pick_random().instantiate()
	
	get_parent().add_child(a)
	get_parent().add_child(b)
	get_parent().add_child(c)
	
	a.global_position = global_position - Vector3(0,-0.01,0)
	b.global_position = global_position - Vector3(0,-0.012,0)
	b.rotation.x = deg_to_rad(-180)
	c.global_position = global_position
	b.apply_force(Vector3(randi_range(-500,500),randi_range(-100,100),randi_range(-100,100)))
	a.apply_force(Vector3(randi_range(-500,500),randi_range(-100,100),randi_range(-100,100)))
	queue_free()
	

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	Utils.coconut_counter += 1
	create_rigid_bodies()
