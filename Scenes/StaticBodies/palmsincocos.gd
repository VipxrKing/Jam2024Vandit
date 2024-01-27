extends StaticBody3D

var hp:int = 12

func change_hp(ammount):
	hp += ammount
		
	if hp <= 0:
		$Mesh/Trunk.freeze = false
		$Mesh/Trunk.apply_force(Vector3(randi_range(-1000,1000),randi_range(-100,100),randi_range(-1000,1000)))
