extends Node3D

#minha buceta é rosa
var conversando = false
var player 
signal conversar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == true and conversando == false and Input.is_action_just_pressed("interacao"):
		emit_signal("conversar")
		
		pass
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	player = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	player = false
	pass # Replace with function body.
