extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node3D/Label2.hide()
	$Node3D/Panel.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"Beg cut/SubViewportContainer/SubViewport/Camera3D".current = true
	$"Beg cut/cutscene".play("beg")
	await get_tree().create_timer(10.0).timeout
	var new_node = preload("res://character_body_3d.tscn").instantiate()
	Global.player = new_node
	$"Beg cut/SubViewportContainer/SubViewport".add_child(new_node)
	$"Beg cut/SubViewportContainer/SubViewport/Camera3D".current = false
	$"Beg cut/SubViewportContainer/SubViewport/Camera3D".queue_free()
	$"Lighter".hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Node3D/DOOR.isopen == true:
		$Node3D/Label2.show()
		$Node3D/Panel.show()
