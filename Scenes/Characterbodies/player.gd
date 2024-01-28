extends CharacterBody3D
class_name Player

var gravity: float = 9.8

var idle: bool = true


@onready var mesh = $Mesh
@onready var camera_mount = $CameraMount

@onready var animation_player = $Mesh/RootScene/AnimationPlayer
@onready var animation_tree = $Mesh/RootScene/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

@onready var hand = $Mesh/RootScene/RootNode/Skeleton3D/VisualHand/R/Hand

var SPEED:float = 10.0
var JUMP_SPEED:float = 20.0
const JUMP_VELOCITY:float = 8.0

var walking_speed:float = 10.0
var running_speed:float = 16.0

var running:bool = false
var on_menu:bool = false
var Grabbing:bool = false

@export var is_locked = true

var sens_horizontal:float = 0.2
var sens_vertical:float = 0.2

var Steering:int = 0

var LERP_SPEED:float = 10.0
var ROTATION_SPEED:float = 8.0

var direction:Vector3 = Vector3.ZERO
var visual_dir:Vector3 = Vector3.ZERO
var input_dir:Vector2 = Vector2.ZERO

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
		if !is_locked:
			if !Grabbing:
				for i in $Mesh/GrabArea.get_overlapping_bodies():
					if i is Weapon:
						hand.grab_body(i,i.find_child("Handle"))
						Grabbing = true
			else:
				hand.release_body()
				Grabbing = false

	if Input.is_action_just_pressed("INTERACT"):
		if !is_locked:
			$Mesh/RayCast3D.get_collider()
			
	if Input.is_action_just_pressed("ATTACK"):
		if Grabbing:
			if animation_state.get_current_node() != "Slash":
				direction = Vector3.ZERO
				is_locked = true
				animation_travel("Slash")
			elif animation_state.get_current_node() == "Slash":
				direction = Vector3.ZERO
				is_locked = true
				animation_travel("Slash2")
			elif animation_state.get_current_node() == "Slash2":
				direction = Vector3.ZERO
				is_locked = true
				animation_travel("Slash")
func raycast_test():
	var obj_int = $Mesh/RayCast3D.get_collider()
	if obj_int != null:
		if obj_int.name == "InteractArea":
			obj_int.emit("Interact")

func _physics_process(delta):
	#Interactive grass
	grass.set_shader_parameter("player_pos", global_position)
	
	#if !animation_player.is_playing():
	#	is_locked = false
	
	if direction and is_on_floor()  and !is_locked:
		if Input.is_action_pressed("RUN"):
			running = true
			SPEED = running_speed
		else:
			SPEED = walking_speed
			running = false
	elif direction == Vector3.ZERO and is_on_floor():
			running = false
		
	if not is_on_floor():
		velocity.y -= gravity * 1.5 * delta
		animation_travel("Falling")
	
	if Input.is_action_just_pressed("JUMP") and is_on_floor() and !is_locked:
		animation_travel("Jump")
		is_locked = true
		#await get_tree().create_timer(0.1).timeout
		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x * JUMP_SPEED
		velocity.z = direction.z * JUMP_SPEED
		
	
	if !is_locked:
		input_dir = Input.get_vector("LEFT", "RIGHT", "FOWARD", "BACKWARD")
		visual_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		if !is_locked:
			if running:
				animation_travel("Run")
			else:
				animation_travel("Walk")
			mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-visual_dir.x, -visual_dir.z), delta * ROTATION_SPEED)
		
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		if !is_locked:
			animation_travel("Idle")
			
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

func hitbox_on():
	if Grabbing:
		hand.turn(true)

func hitbox_off():
	if Grabbing:
		hand.turn(false)
