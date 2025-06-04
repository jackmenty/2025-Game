extends CharacterBody3D
class_name CPlayer

const SPEED = 20
const JUMP_VELOCITY = 13.5
@export var springarm : SpringArm3D
@export var camera : Camera3D
var max_health = 10
var health = 0
var damaged = true


func _ready():
	await get_tree().process_frame
	health = max_health
	

func take_damage(damage_amount: int):
	if damaged:
		health = health - damage_amount
		print(health)
		if health <= 0:
			await get_tree().process_frame
			die()
		if health > 0:
			iframes()

func die():
	get_tree().change_scene_to_file("res://Scenes/Game_over.tscn")

func iframes():
	damaged = false
	await get_tree().create_timer(5.0).timeout
	damaged = true



func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 4

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var direction := Vector3.ZERO
	if springarm:
		direction = (springarm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var corrected_dir = Vector3(direction.x, 0, direction.z).normalized()
	if corrected_dir:
		velocity.x = corrected_dir.x * SPEED
		velocity.z = corrected_dir.z * SPEED
		if Input.is_action_pressed("sprint"):
			velocity.x *= 2
			velocity.z *= 2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_just_pressed("ui_focus_next"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	move_and_slide()
