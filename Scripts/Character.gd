extends CharacterBody3D


const SPEED = 20
const JUMP_VELOCITY = 13.5
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
	var direction: Vector3 = (springarm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var corrected_dir = Vector3(direction.x, 0, direction.z).normalized()
	if corrected_dir:
		velocity.x = corrected_dir.x * SPEED
		velocity.z = corrected_dir.z * SPEED
		if Input.is_action_pressed("sprint"):
			velocity.x = corrected_dir.x * SPEED * 2
			velocity.z = corrected_dir.z * SPEED * 2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("ui_focus_next"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	move_and_slide()
