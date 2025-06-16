extends CharacterBody3D

@onready var camera_head := $Head
@onready var camera := $Head/Camera3D
@onready var anim_tree := $Head/AnimationTree

enum {
	IDLE,
	WALK
}
var currrent_animation = IDLE

var walk_val = 0

## Mouse sensitivity
@export var mouse_sensitivity: float = 0.1
@export var blend_speed = 15

## Rotation variables
var _rotation_x: float = 0.0
var _rotation_y: float = 0.0

const SPEED = 3.0
const JUMP_VELOCITY = 4.5


func _ready():
	# Capture mouse (press ESC to release)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Set initial rotation
	_rotation_y = rotation_degrees.y
	_rotation_x = rotation_degrees.x


func _physics_process(delta):
	movement(delta)
	handle_animation(delta)
	move_and_slide()


func movement(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = -direction.x * SPEED
		velocity.z = -direction.z * SPEED
		currrent_animation = WALK
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		currrent_animation = IDLE


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# camera based on mouse movement
		_rotation_y -= event.relative.x * mouse_sensitivity
		_rotation_x -= -event.relative.y * mouse_sensitivity
		
		# Clamp vertical rotation to prevent flipping
		_rotation_x = clamp(_rotation_x, -90.0, 90.0)
		
		# Apply rotations
		rotation_degrees.y = _rotation_y
		camera_head.rotation_degrees.x = _rotation_x


func handle_animation(delta):
	match  currrent_animation:
		IDLE:
			walk_val = lerpf(walk_val, 0, blend_speed*delta)
		WALK:
			walk_val = lerpf(walk_val, 1, blend_speed*delta)
	update_tree()


func update_tree():
	anim_tree["parameters/walk/blend_amount"] = walk_val
	if Input.is_action_just_pressed("shoot"):
		anim_tree.set("parameters/fire/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		shoot()


func shoot():
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center)*1000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if "target" in result["collider"].name:
		result["collider"].get_parent().take_shoot()
