extends CharacterBody3D

var movable = false
var SPEED = 4.0
const JUMP_VELOCITY = 4.5
var cap_mouse =true
var look_dir : Vector2
@onready var camera = $Camera3D
var horizontal_sensitivity = 0.1  
var vertical_sensitivity = 0.009
var bob_freq = 2
var bob_amp = 0.05
var t_bob = 0
const MAX_STEP_HEIGHT = 0.9
var _snapped_to_stairs_last_frame:= false
var _last_Frame_was_on_floor = -INF

func _ready():
	add_to_group("player")
	movable = true
	$Camera3D.current = true

func _snap_down_to_stairs_check()-> void:
	var did_snap:= false
	var floor_below: bool = %Below.is_colliding() and not is_surface_too_steep(%Below.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_Frame_was_on_floor <= 2
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0,-MAX_STEP_HEIGHT/2,0),body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta)-> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity *Vector3(1,0,1)*delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0,MAX_STEP_HEIGHT*2,0))
	var down_check_result = PhysicsTestMotionResult3D.new()
	if (_run_body_test_motion(step_pos_with_clearance,Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CollisionShape3D"))):
		var step_height = ((step_pos_with_clearance.origin+down_check_result.get_travel())- self.global_position).y
		if step_height >MAX_STEP_HEIGHT or step_height<=0.01 or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT:return false
		%Ahead.global_position = down_check_result.get_collision_point()+Vector3(0,MAX_STEP_HEIGHT,0)+ expected_move_motion.normalized() *0.1
		%Ahead.force_raycast_update()
		if %Ahead.is_colliding() and not is_surface_too_steep(%Ahead.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin +down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if movable == true:
		if is_on_floor(): _last_Frame_was_on_floor = Engine.get_physics_frames()
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.

		var input_dir = Input.get_vector("left", "right", "forward", "back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_pressed("Sprint"):
			SPEED =5.5
		else:
			SPEED = 4
		_rotate_cam(delta)
		if not _snap_up_stairs_check(delta):
			_snap_down_to_stairs_check()
			move_and_slide()
		t_bob += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _bob(t_bob)
	
	


func _input(event:InputEvent):
	if event is InputEventMouseMotion:
		look_dir+=event.relative 
		
func _rotate_cam(delta:float , sense_mod:float =1.0):
	var input = Input.get_vector("look_left", "look_right","look_down","look_up")
	look_dir+=input
	rotation.y -=look_dir.x  *delta *horizontal_sensitivity
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y *vertical_sensitivity*sense_mod,-1.5,1.5)
	look_dir = Vector2.ZERO
	
func _bob(time):
	var pos= Vector3.ZERO
	pos.y = sin(bob_freq*time)*bob_amp+0.37
	pos.x = cos(bob_freq*time/2)*bob_amp
	return pos

func is_surface_too_steep(normal:Vector3)-> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from:Transform3D,motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionParameters3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(),params,result)
