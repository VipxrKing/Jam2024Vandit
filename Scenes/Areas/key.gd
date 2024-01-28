extends Area3D

func _on_body_entered(body):
	if body is Player:
		set_collision_mask_value(2,false)
		Utils.keys += 1
		Utils.get_scene_manager().find_child("UI").find_child("Control").get_child(0).text = str(Utils.keys) + "/3"
		var tween = create_tween()
		tween.tween_property($Mesh,"position:y",1,1)
		tween.tween_property($Mesh.get_child(0).mesh.surface_get_material(0),"albedo_color:a",0,1)
		await tween.finished
		queue_free()
