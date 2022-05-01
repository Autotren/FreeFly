extends RigidBody


var dir = Vector3()

const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var input_movement_vector = Vector3()
var thrust = Vector2()
export var thrust_multiplier = 40
export var manoeuver_multiplier = 1

var MOUSE_SENSITIVITY = 0.05

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# gravity_scale = 0
	mode = RigidBody.MODE_STATIC




func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()


	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("movement_up"):
		thrust.x += 1
	if Input.is_action_pressed("movement_down"):
		thrust.x -= 1
	if Input.is_action_pressed("movement_turn_left"):
		input_movement_vector.z -= 1
	if Input.is_action_pressed("movement_turn_right"):
		input_movement_vector.z += 1

	if Input.is_action_just_released("movement_forward"):
		input_movement_vector.y -= 1
	if Input.is_action_just_released("movement_backward"):
		input_movement_vector.y += 1
	if Input.is_action_just_released("movement_left"):
		input_movement_vector.x += 1
	if Input.is_action_just_released("movement_right"):
		input_movement_vector.x -= 1
	if Input.is_action_just_released("movement_up"):
		thrust.x -= 1
	if Input.is_action_just_released("movement_down"):
		thrust.x += 1
	if Input.is_action_just_released("movement_turn_left"):
		input_movement_vector.z += 1
	if Input.is_action_just_released("movement_turn_right"):
		input_movement_vector.z -= 1

	input_movement_vector = input_movement_vector.normalized()
	thrust = thrust.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	dir += Vector3(0, input_movement_vector.z, 0)
	# ----------------------------------

	# # ----------------------------------
	# # Jumping
	# if is_on_floor():
	if Input.is_action_just_pressed("movement_jump"):
		mode = RigidBody.MODE_STATIC
		translate(Vector3.UP * 20)
		rotation = Vector3.ZERO
		# set_angular_velocity(Vector3.ZERO)
		# set_linear_velocity(Vector3.ZERO)
		mode = RigidBody.MODE_RIGID
		
	# # ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
#	dir.y = 0
# 	dir = dir.normalized()

# 	# vel.y += delta * GRAVITY

# 	var hvel = vel
# 	hvel.y = 0

# 	var target = dir
# 	target *= MAX_SPEED

# 	var accel
# 	if dir.dot(hvel) > 0:
# 		accel = ACCEL
# 	else:
# 		accel = DEACCEL

# 	hvel = hvel.linear_interpolate(target, accel * delta)
# 	vel.x = hvel.x
# 	vel.z = hvel.z
# 	vel.y = hvel.y
#	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

	# rotation_helper.rotate_x(-relative_rotation.x)
	# rotation_helper.rotate_y(-relative_rotation.y)
	# rotation_helper.rotate_z(-relative_rotation.z)
	# rotation_helper.rotation.x = -rotation.x
	# rotation_helper.rotation.y = -rotation.y
	# print(rotation_degrees)
	pass

func _integrate_forces(state):
	add_force_local(Vector3(input_movement_vector.x, 0,-input_movement_vector.y) * manoeuver_multiplier, Vector3(0, 1, 0))
	add_force_local(Vector3.UP * thrust.x * thrust_multiplier, Vector3(0, -1, 0))
	add_force_local(Vector3(0, 0, -1) * input_movement_vector.z * 0.5 * manoeuver_multiplier, Vector3(-1, 0, 0))
	add_force_local(Vector3(0, 0, 1) * input_movement_vector.z * 0.5 * manoeuver_multiplier, Vector3(1, 0, 0))


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		rotation_helper.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
	
	# Maybe implemente inputs better?
	# if event is InputEventKey:
	# 	print(event.scancode)

func add_force_local(force: Vector3, pos: Vector3):
	var pos_local = self.transform.basis.xform(pos)
	var force_local = self.transform.basis.xform(force)
	self.add_force(force_local, pos_local)

func on_game_start():
	mode = RigidBody.MODE_RIGID
