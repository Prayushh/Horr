extends CharacterBody3D

var hasbody = false
var speed = 10
var accel = 20
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player
var last_pos
# Reference to the jumpscare camera
@onready var jumpscare_camera = $jumpscarecamera  # Ensure this path matches your scene structure

func _ready():
	$Label.hide()
	$Jump.hide()
	await get_tree().create_timer(12.0).timeout
	player = Global.player

func _physics_process(delta):
	if player and Global.player != null:
		
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0
		direction = direction.normalized()
		nav.target_position = player.global_transform.origin
		look_at(player.global_transform.origin + direction, Vector3.UP)
		player_follow(delta)
		last_pos = player.position
	else:
		print("no player")
		

func _on_fov_body_entered(body):
	if body.is_in_group("player"):
		hasbody = true

func _on_cooked_body_entered(body):  # Ensure the signal is connected to the Cooked Area3D
	if body.is_in_group("player"):
		print("Player entered Cooked area")
		$"678609Usar2Trtf2-jumpscare-sound-remake-1".play()
		$Jump.show()
	else:
		$Label.hide()

func _on_fov_body_exited(body):
	if body.is_in_group("player"):
		hasbody = false

func player_follow(delta):
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * 7.5, 7 * delta)
	move_and_slide()
	if hasbody:
		speed = 15
		accel = 10
	else:
		speed = 2
		accel = 5

func trigger_jumpscare():
	# Disable the current camera (assuming it's named Camera3D and is a child of the player)
	
	print("jump true")
	jumpscare_camera.current = true
	
	# Enable the jumpscare camera
	#if jumpscare_camera:
		#jumpscare_camera.current = true
