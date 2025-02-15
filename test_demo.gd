extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node3D/Label2.hide()
	$Node3D/Panel.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Node3D/DOOR.isopen == true:
		$Node3D/Label2.show()
		$Node3D/Panel.show()
