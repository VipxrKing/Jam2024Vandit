extends CharacterBody3D
class_name Player

var gravity: float = 9.8

var idle: bool = true


@onready var mesh = $Mesh
@onready var camera_mount = $CameraMount

@onready var animation_player = $Mesh/RootScene/AnimationPlayer
@onready var animation_tree = $Mesh/RootScene/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")


var SPEED:float = 10.0
var JUMP_SPEED:float = 20.0
const JUMP_VELOCITY:float = 8.0

var walking_speed:float = 10.0
var running_speed:float = 16.0

var running:bool = false
var on_menu:bool = false
var Grabbing:bool = false
@export var input:bool = true
@export var in_combat:bool = false

var sens_horizontal:float = 0.2
var sens_vertical:float = 0.2

var Steering:int = 0

var LERP_SPEED:float = 10.0
var ROTATION_SPEED:float = 8.0

var direction:Vector3 = Vector3.ZERO

var grass = preload("res://Shaders/GrassMove.tres")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and !on_menu:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		mesh.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x,deg_to_rad(-89),deg_to_rad(89))
	if input:
		if Input.is_action_just_pressed("GRAB"):
				if !Grabbing:
					for i in $Mesh/GrabArea.get_overlapping_bodies():
						if i is Weapon:
							$Mesh/RootScene/RootNode/Skeleton3D/VisualHand/R/Hand.grab_body(i,i.find_child("Handle"))
							Grabbing = true
				else:
					$Mesh/RootScene/RootNode/Skeleton3D/VisualHand/R/Hand.release_body()
					Grabbing = false

		if Input.is_action_just_pressed("INTERACT"):
			$Mesh/RayCast3D.get_collider()
			
	if Input.is_action_just_pressed("ATTACK"):
		if animation_state.get_current_node() == "Slash":
			direction = Vector3.ZERO
			animation_travel("Slash2")
		if animation_state.get_current_node() == "Slash2":
			direction = Vector3.ZERO
			animation_travel("Slash")
		else:
			direction = Vector3.ZERO
			animation_travel("Slash")
			
func raycast_test():
	var obj_int = $Mesh/RayCast3D.get_collider()
	if obj_int != null:
		if obj_int.name == "InteractArea":
			obj_int.emit("Interact")

func _physics_process(delta):
	#Interactive grass
	grass.set_shader_parameter("player_pos", global_position)
	
	if direction and is_on_floor()  and !in_combat:
		if Input.is_action_pressed("RUN"):
			animation_travel("Run")
			running = true
			SPEED = running_speed
		else:
			animation_travel("Walk")
			SPEED = walking_speed
			running = false
	elif direction == Vector3.ZERO and is_on_floor():
		if !in_combat:
			animation_travel("Idle")
			running = false
		
	if not is_on_floor():
		velocity.y -= gravity * 1.5 * delta
		animation_travel("Falling")
	
	if Input.is_action_just_pressed("JUMP") and is_on_floor() and input:
		animation_travel("Jump")
		await get_tree().create_timer(0.1).timeout
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * JUMP_SPEED
		velocity.z = direction.z * JUMP_SPEED
	
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FOWARD", "BACKWARD")
	var visual_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if input:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-visual_dir.x, -visual_dir.z), delta * ROTATION_SPEED)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func menu_switch():
	on_menu = !on_menu
	if on_menu:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func change_hp(ammount):
	animation_travel("Hurt")
	
func animation_travel(anim:String):
	if animation_state.get_current_node() != anim:
		animation_state.travel(anim)
