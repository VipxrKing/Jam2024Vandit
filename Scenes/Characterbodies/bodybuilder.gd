extends CharacterBody3D
class_name NPCBody

@onready var navigation_agent_3d = $NavigationAgent3D

var CURRENT_SPEED:float = 2.0
const WALKING_SPEED:float = 2.0
const SPRINTING_SPEED:float = 4.0
const FALLING_SPEED:float = 9.8
var ACCELERATION:float = 10.0

var direction = Vector3()

var on_radius:bool = false

@export_enum("IDLE","TARGET","DIALOGUE","BUYING") var AI_STATE:String = "TARGET"

@export_enum("FOLLOW","POINT") var TARGET_AI:String = "FOLLOW"

func _physics_process(delta):
	if AI_STATE == "TARGET":
		if !on_radius or TARGET_AI != "FOLLOW":
			direction = navigation_agent_3d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction*WALKING_SPEED,ACCELERATION * delta)
	
	if !is_on_floor():
		velocity.y -= FALLING_SPEED
	
	move_and_slide()

func manage_state():
	match AI_STATE:
		"IDLE":
			direction = Vector3.ZERO
		"TARGET":
			pass
		"DIALOGUE":
			direction = Vector3.ZERO

func _on_npc_radius_body_entered(body):
	if body is Player:
		on_radius = true
		if body.TARGET_AI == "FOLLOW":
			body.direction = Vector3.ZERO

func _on_npc_radius_body_exited(body):
	if body is Player:
		on_radius = false
