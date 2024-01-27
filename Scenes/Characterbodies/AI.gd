extends Node

@export var target:Node = null
var parent

func _ready():
	parent = get_parent()
	if target == null:
		target = Utils.get_player()


func _physics_process(delta):
	if parent.on_radius == false && parent.AI_STATE == "TARGET": 
		parent.navigation_agent_3d.target_position = target.global_position 
