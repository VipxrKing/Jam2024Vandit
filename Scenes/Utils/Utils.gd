extends Node

func get_scene_manager():
	return get_node("/root/SceneManager")

func get_player():
	return get_current_scene().find_child("Player")

func get_current_scene():
	return get_node("/root/SceneManager/CurrentScene").get_child(0)
	
func _input(event):
	if event.is_action_pressed("SCREENSHOT"):
		var id:String = Time.get_date_string_from_system() + Time.get_datetime_string_from_system()
		id = id.replace(":","")
		get_tree().root.get_viewport().get_texture().get_image().save_png("res://Screenshots/Screenshot" + id + ".png")
