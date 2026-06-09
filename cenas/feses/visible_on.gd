extends VisibleOnScreenEnabler3D

@export var object:Node3D



func _on_screen_entered() -> void:
	object.show()
	print("estao me vendo")
	pass # Replace with function body.


func _on_screen_exited() -> void:
	object.hide()
	print("agora nao me ve")
	pass # Replace with function body.
