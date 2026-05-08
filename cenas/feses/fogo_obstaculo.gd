extends Node3D

var vida = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fogo_normal_apagado() -> void:
	vida -= 1 
	if vida <= 0:
		queue_free()
		print("dano")
		pass
	pass # Replace with function body.
