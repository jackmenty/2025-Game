extends CharacterBody3D
class_name CPlayer


@export var hp_label : Label
const SPEED = 12
const JUMP_VELOCITY = 15
@export var springarm : SpringArm3D
@export var camera : Camera3D
var max_health = 10
var health = 0
var damaged = true
var heal = true
var time_in_air = 1.0
#var checkpoint = Vector3.ZERO
#var start_pos = Vector3.ZERO
var death_pos = Vector3()
var return_back = false


func _ready():
	await get_tree().process_frame
	health = max_health
	#start_pos = global_position
	#checkpoint = global_position
	add_to_group("Player")
	#hp_label.text = str(health)

func take_damage(damage_amount: int):
	if damaged:
		health = health - damage_amount
		hp_label.text = "Health: " + str(health)
		if health <= 0:
			await get_tree().process_frame
			die()
		if health > 0:
			iframes()

func heal_up(heal_amount: int):
	if heal:
		health = health + heal_amount
		if health > max_health:
			health = max_health
		hp_label.text = "Health: " + str(health)

func die():
	await get_tree().process_frame
	Engine.time_scale = 0
	get_node("Game_over").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func iframes():
	damaged = false
	await get_tree().create_timer(2.0).timeout
	damaged = true

func return_to_checkpoint():
	position = death_pos

#func set_checkpoint(position):
	#checkpoint = position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 4
		time_in_air += delta

	if Input.is_action_just_pressed("jump") and is_on_floor() || Input.is_action_pressed("jump") and time_in_air < .2:
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("jump") and is_on_floor() and Input.is_action_pressed("sprint")|| Input.is_action_pressed("jump") and time_in_air < .2 and Input.is_action_pressed("sprint"):
		velocity.y = JUMP_VELOCITY + 10

	var was_on_floor = is_on_floor()
	
	if is_on_floor():
		time_in_air = 0

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var direction := Vector3.ZERO
	if springarm:
		direction = (springarm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var corrected_dir = Vector3(direction.x, 0, direction.z).normalized()
	if corrected_dir:
		velocity.x = corrected_dir.x * SPEED
		velocity.z = corrected_dir.z * SPEED
		if Input.is_action_pressed("sprint"):
			velocity.x *= 3
			velocity.z *= 3
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
