extends StaticBody3D

var hp:int = 12

const COCONUT = preload("res://Scenes/RigidBodies/coconut.tscn")

func change_hp(ammount):
	hp += ammount
	if hp == 9 or hp == 6 or hp == 3:
		var b
		if hp == 9:
			b = $Coco
		elif hp == 6:
			b = $Coco2
		elif hp == 3:
			b = $Coco3
		
		var a = COCONUT.instantiate()
		get_parent().add_child(a)
		a.global_position = b.global_position
		b.queue_free()
		
	if hp <= 0:
		$Mesh/Trunk.freeze = false
		$Mesh/Trunk.apply_force(Vector3(randi_range(-500,500),randi_range(-100,100),randi_range(-100,100)))

func drop_coconut():
	pass
