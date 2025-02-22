extends CharacterBody3D
var hasbody = false
var speed = 3
var accel = 6
@onready var nav: NavigationAgent3D= $NavigationAgent3D
var player
func _ready():
	$Label.hide()
	await get_tree().create_timer(12.0).timeout
	player = Global.player
	


func _physics_process(delta):
	if player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0
		direction = direction.normalized()
		nav.target_position = player.global_transform.origin
		look_at(player.global_transform.origin+direction, Vector3.UP)
		player_follow(delta)
		



func _on_fov_body_entered(body):
	if body.is_in_group("player"):
		hasbody = true


func _on_cooked_body_entered(body):
	if body.is_in_group("player"):
		print ("cooked")
		$Label.modulate.a = 1.0
		$Label.visible= true
	else:
		$Label.hide()


func _on_fov_body_exited(body):
	if body.is_in_group("player"):
		hasbody = false

func player_follow(delta):
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction*speed, accel*delta)
	move_and_slide()
	if hasbody:
		speed = 5
		accel = 10
	else:
		speed = 2
		accel = 5
