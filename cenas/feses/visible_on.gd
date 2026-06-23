extends VisibleOnScreenEnabler3D

@export var object:Node3D



func _on_screen_entered() -> void:
	object.show()
	
	pass # Replace with function body.


func _on_screen_exited() -> void:
	object.hide()
	
	pass # Replace with function body.
