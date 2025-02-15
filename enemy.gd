extends CharacterBody3D
var hasbody = false
@onready var player = $"../ROOM1/SubViewportContainer/SubViewport/CharacterBody3D"
var speed = 2
var accel = 5
@onready var nav: NavigationAgent3D= $NavigationAgent3D

func _ready():
	$Label.hide()

func _physics_process(delta):
	var direction = Vector3()
	
	nav.target_position = player.position
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


func _on_fov_body_entered(body):
	if body.is_in_group("player"):
		hasbody = true


func _on_cooked_body_entered(body):
	if body.is_in_group("player"):
		$Label.show()
	else:
		$Label.hide()


func _on_fov_body_exited(body):
	if body.is_in_group("player"):
		hasbody = false
