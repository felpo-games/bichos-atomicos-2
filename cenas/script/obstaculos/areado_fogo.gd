extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node3D) -> void:
	eventos_global.batalha = true
	pass # Replace with function body.


func _on_body_exited(_body: Node3D) -> void:
	eventos_global.batalha = false
	pass # Replace with function body.


func _on_area_3d_body_entered(_body: Node3D) -> void:
	eventos_global.batalha = true
	pass # Replace with function body.


func _on_area_3d_body_exited(_body: Node3D) -> void:
	
	pass # Replace with function body.
