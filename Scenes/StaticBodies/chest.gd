extends StaticBody3D


func _on_area_3d_body_entered(body):
	if body is Player and Utils.keys >= 3:
		$AnimationPlayer.play("Open")
		var tween = create_tween()
		tween.tween_property($Mesh/Key,"position:y",1,1)
		tween.tween_property($Mesh/Key.get_child(0).mesh.surface_get_material(0),"albedo_color:a",0,1)
		
		Utils.bike_key = true
