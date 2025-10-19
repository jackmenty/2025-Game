extends CharacterBody3D
class_name CPlayer

@export var hp_label : Label
const SPEED = 12
const JUMP_VELOCITY = 15
@export var springarm : SpringArm3D
@export var camera : Camera3D
@export var rotation_speed : float = 10.0 # how fast the model turns (higher = snappier)
@export var face_camera_when_idle : bool = false # optional: when not moving, face camera forward

# The visual/model node under the Player. Change the path if your mesh node has a different name.
@onready var model : Node3D = $TEST
@onready var animation_player : AnimationPlayer = $TEST/AnimationPlayer

var max_health = 10
var health = 0
var damaged = true
var heal = true
var time_in_air = 1.0
var death_pos = Vector3()
var return_back = false


func _ready():
	await get_tree().process_frame
	health = max_health
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


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		animation_player.play("FALLING")
		velocity += get_gravity() * delta * 4
		time_in_air += delta
	if velocity.x == 0 and velocity.z == 0 and is_on_floor():
		animation_player.play("IDLE")
	
	if Input.is_action_just_pressed("jump") and is_on_floor() || Input.is_action_pressed("jump") and time_in_air < .2:
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("jump") and is_on_floor() and Input.is_action_pressed("sprint")|| Input.is_action_pressed("jump") and time_in_air < .2 and Input.is_action_pressed("sprint"):
		velocity.y = JUMP_VELOCITY + 10

	#if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_back"):
		#print(animation_player)
		#animation_player.play("WALKING")
		
	var was_on_floor = is_on_floor()
	
	if is_on_floor():
		time_in_air = 0
		animation_player.play("IDLE")

	if Input.is_action_pressed("move_forward") and is_on_floor():
		animation_player.play("RUNNING")

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var direction := Vector3.ZERO
	if springarm:
		# convert camera-aligned input into world-space direction
		direction = (springarm.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var corrected_dir = Vector3(direction.x, 0, direction.z).normalized()
	
	#movement
	if corrected_dir:
		velocity.x = corrected_dir.x * SPEED
		velocity.z = corrected_dir.z * SPEED
		#animation_player.play("WALKING")
		if Input.is_action_pressed("sprint"):
			velocity.x *= 3
			velocity.z *= 3
			#animation_player.play("RUNNING")
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# --- MODEL ROTATION (yaw only) ---
	# Rotate the visual/model to face the movement direction (in camera-relative space).
	# This keeps rotation only on the Y axis and smoothly interpolates using lerp_angle.
	if model:
		if corrected_dir.length_squared() > 0.0001:
			# desired yaw (radians). Using atan2(-x, -z) matches Godot's forward (-Z) convention.
			var target_yaw = atan2(-corrected_dir.x, -corrected_dir.z)
			var current_yaw = model.rotation.y
			model.rotation.y = lerp_angle(current_yaw, target_yaw, rotation_speed * delta)
		elif face_camera_when_idle and camera:
			# Optional: when idle, face same direction as camera (comment out if not wanted)
			# Get camera forward in world XZ plane
			var cam_forward = -camera.global_transform.basis.z
			cam_forward.y = 0
			if cam_forward.length_squared() > 0.0001:
				cam_forward = cam_forward.normalized()
				var target_yaw = atan2(-cam_forward.x, -cam_forward.z)
				var current_yaw = model.rotation.y
				model.rotation.y = lerp_angle(current_yaw, target_yaw, rotation_speed * delta)
	# ----------------------------------

	move_and_slide()
