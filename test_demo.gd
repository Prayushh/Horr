extends Node3D
var lighter
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
	new_node.name = "Play"
	$"Beg cut/SubViewportContainer/SubViewport".add_child(new_node)
	$"Beg cut/SubViewportContainer/SubViewport/Camera3D".current = false
	$"Beg cut/SubViewportContainer/SubViewport/Camera3D".queue_free()
	print(new_node.name)
	$"Lighter".hide()
	print(new_node.position)
	lighter = $"Beg cut/SubViewportContainer/SubViewport/Play/Lighter"
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Node3D/DOOR.isopen == true:
		$Node3D/Label2.show()
		$Node3D/Panel.show()
	if Global.jump:
		if lighter:
			$"Beg cut/SubViewportContainer/SubViewport/Play".queue_free()
			Global.player = null
			$Enemy.queue_free()
			#var new = preload("res://enemy.tscn").instantiate
			#self.add_child(new)
			#new.name = "Enemy"
			$Enemy/jumpscarecamera.current =true
		Global.jump = false
	if Global.change:
		await get_tree().create_timer(2)
		
