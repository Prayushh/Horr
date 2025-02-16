extends Node3D

@onready var anim = $AnimationPlayer
var isopen = false
var infront = false
var door = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.hide()


func _input(_event):
	if Input.is_action_just_pressed("e"):
		if infront == true and anim.is_playing()==false:
			door = !door
			if door ==true:
				anim.play("open")
				$doorsong.play()
				isopen = true
			else:
				anim.play("close")
				isopen = false



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		infront = true
		$Label.show()



func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		infront =false
		$Label.hide()
