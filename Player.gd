extends RigidBody

var input_movement_vector = Vector3()
var thrust = Vector2()
export var thrust_multiplier = 40
export var manoeuver_multiplier = 1

var MOUSE_SENSITIVITY = 0.05

func _ready():
	mode = RigidBody.MODE_STATIC


func _physics_process(delta):

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
	if thrust.x != 0:
		$Flame/Flame.emitting = true
	else:
		$Flame/Flame.emitting = false

	if Input.is_action_just_pressed("movement_jump"):
		mode = RigidBody.MODE_STATIC
		translate(Vector3.UP * 20)
		rotation = Vector3.ZERO
		# set_angular_velocity(Vector3.ZERO)
		# set_linear_velocity(Vector3.ZERO)
		mode = RigidBody.MODE_RIGID

func _integrate_forces(state):
	add_force_local(Vector3(input_movement_vector.x, 0,-input_movement_vector.y) * manoeuver_multiplier, Vector3(0, 1, 0))
	add_force_local(Vector3.UP * thrust.x * thrust_multiplier, Vector3(0, -1, 0))
	add_force_local(Vector3(0, 0, -1) * input_movement_vector.z * 0.5 * manoeuver_multiplier, Vector3(-1, 0, 0))
	add_force_local(Vector3(0, 0, 1) * input_movement_vector.z * 0.5 * manoeuver_multiplier, Vector3(1, 0, 0))
	# add_force_local(Vector3(0, 0, -1) * pow(rotation.x,3)* 0.1 * manoeuver_multiplier, Vector3(-1, 0, 0))
	# add_force_local(Vector3(0, 0, 1) * pow(rotation.x,3) * 0.1 * manoeuver_multiplier, Vector3(1, 0, 0))
	# angular_damp = 0.5

func _input(event):
	pass
	# Maybe implemente inputs better?
	# if event is InputEventKey:
	# 	print(event.scancode)

func add_force_local(force: Vector3, pos: Vector3):
	var pos_local = self.transform.basis.xform(pos)
	var force_local = self.transform.basis.xform(force)
	self.add_force(force_local, pos_local)

func on_game_start():
	mode = RigidBody.MODE_RIGID
