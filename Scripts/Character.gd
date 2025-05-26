extends CharacterBody3D


const SPEED = 1
const MAX_SPEED = 10
const JUMP_VELOCITY = 13.5
const ACCELERATION = .5
const DECELERATION = 20
@onready var springarm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 4

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (springarm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var corrected_dir = Vector3(direction.x, 0, direction.z).normalized()
	if corrected_dir:
		print(corrected_dir)
		velocity.x += corrected_dir.x * SPEED
		velocity.z += corrected_dir.z * SPEED
		if (abs(velocity.x) >= MAX_SPEED):
			velocity.x = MAX_SPEED * corrected_dir.x
		if (abs(velocity.z) >= MAX_SPEED):
			velocity.z = MAX_SPEED * corrected_dir.z
	else:
		velocity.x = velocity.x * delta * DECELERATION
		velocity.z = velocity.z * delta * DECELERATION
	print(velocity.x, " ",  velocity.z)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("ui_focus_next"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	move_and_slide()
