extends Node3D


signal apagado 
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	
	if area.is_in_group("ataque_agua"):
		emit_signal("apagado")
		queue_free()
	if area.is_in_group("player"):
		pass
		#player.dano()
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body = player
		player = body
	pass # Replace with function body.
