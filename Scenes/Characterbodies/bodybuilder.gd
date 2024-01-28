extends CharacterBody3D
class_name NPCBody

@onready var navigation_agent_3d = $NavigationAgent3D

@onready var animation_player = $Mesh/RootScene/AnimationPlayer
@onready var animation_tree = $Mesh/RootScene/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var hp:int = 9

var posearr:Array[String] = ["Female_crouch","Female_laying","Female_stand","Male_crouch"]

var CURRENT_SPEED:float = 2.0
const WALKING_SPEED:float = 2.0
const SPRINTING_SPEED:float = 4.0
const FALLING_SPEED:float = 9.8
var ACCELERATION:float = 10.0

var direction = Vector3()

var on_radius:bool = false
var mad:bool = false

@export_enum("IDLE","TARGET") var AI_STATE:String = "TARGET"

@export_enum("FOLLOW","POINT") var TARGET_AI:String = "FOLLOW"

func _physics_process(delta):
	if AI_STATE == "TARGET":
		if !on_radius or TARGET_AI != "FOLLOW":
			look_at(Utils.get_player().global_position,Vector3.UP)
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
			
func _on_npc_radius_body_entered(body):
	if body is Player:
		on_radius = true
		animation_travel("Punch")
		if body.TARGET_AI == "FOLLOW":
			body.direction = Vector3.ZERO

func _on_npc_radius_body_exited(body):
	if body is Player:
		on_radius = false

func animation_travel(anim:String):
	if animation_state.get_current_node() != anim:
		animation_state.travel(anim)

func _on_pose_timeout():
	if !mad:
		var a = posearr.pick_random()
		animation_travel(a)


func change_hp(ammount):
	AI_STATE == "TARGET"
	hp += ammount
	animation_travel("Walking")
	if !mad:
		get_tree().call_group("BODYBUILDERS","emputado")

func emputado():
	mad = true
	AI_STATE = "TARGET"
