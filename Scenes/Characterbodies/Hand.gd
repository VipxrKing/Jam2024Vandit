extends CharacterBody3D

var Grabbed:bool = false
var GrabbedBody:RigidBody3D = null
var GrabOffset:Vector3 = Vector3.ZERO
var RotationOffset:Vector3 = Vector3.ZERO

func _physics_process(delta):
	if Grabbed:
		GrabbedBody.set_global_position(global_position + GrabOffset)
		GrabbedBody.set_rotation(RotationOffset + get_parent().rotation + get_parent().get_parent().rotation)

func grab_body(body: RigidBody3D, grabable:Marker3D) -> void:
	Grabbed = true
	GrabbedBody = body
	GrabOffset = grabable.position
	RotationOffset = grabable.rotation
	GrabbedBody.set_rotation(RotationOffset)
	
func release_body() -> void:
	Grabbed = false
	GrabbedBody = null
