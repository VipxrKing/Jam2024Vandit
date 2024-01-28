extends CharacterBody3D
class_name Player

var gravity: float = 9.8

var idle: bool = true

@onready var mesh = $Mesh
@onready var camera_mount = $CameraMount

var SPEED:float = 7.0
var JUMP_SPEED:float = 10.0
const JUMP_VELOCITY:float = 8.0

var walking_speed:float = 7.0
var running_speed:float = 14.0

var running:bool = false
var on_menu:bool = false
var Grabbing:bool = false

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

	if Input.is_action_just_pressed("GRAB"):
			if Grabbing:
				for i in $Mesh/Hand/GrabArea.get_overlapping_bodies():
					if i is Weapon != null:
						$Mesh/Hand.grab_body(i,i.find_child("Handle"))
						Grabbing = true
			else:
				$Mesh/Hand.release_body()
				Grabbing = false

func _physics_process(delta):
	#Interactive grass
	grass.set_shader_parameter("player_pos", global_position)
	
	if Input.is_action_pressed("RUN"):
		if direction and is_on_floor():
			running = true
			SPEED = running_speed
	else:
		if direction and is_on_floor():
			SPEED = walking_speed
			running = false
		
	if not is_on_floor():
		velocity.y -= gravity * 1.5 * delta
	
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		await get_tree().create_timer(0.1).timeout
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * JUMP_SPEED
		velocity.z = direction.z * JUMP_SPEED
	
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FOWARD", "BACKWARD")
	var visual_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
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
	
