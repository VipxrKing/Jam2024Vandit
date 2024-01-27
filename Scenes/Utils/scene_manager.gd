extends Node3D

var next_scene = null
var overlay_scene = null

enum TransitionType {NEW_SCENE}
var transition_type = TransitionType.NEW_SCENE

func _input(event):
	if Input.is_action_just_pressed("RESTART"):
		get_tree().reload_current_scene()

func transition_to_scene(new_scene: String, spawn_location, spawn_direction):
	next_scene = new_scene
	transition_type = TransitionType.NEW_SCENE
	$ScreenTransitions/AnimationPlayer.play("FadeToBlack")

func transition():
	match transition_type:
		TransitionType.NEW_SCENE:
			$CurrentScene.get_child(0).queue_free()
			$CurrentScene.add_child(load(next_scene).instantiate())
