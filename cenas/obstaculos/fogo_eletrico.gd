extends Node3D

var proximo_obstaculo: PackedScene = preload("res://cenas/obstaculos/fogo_normal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("ataque_dc"):
		
		# cria o novo obstáculo
		if proximo_obstaculo:
			var novo = proximo_obstaculo.instantiate()
			get_parent().add_child(novo)
			
			# coloca na mesma posição
			novo.global_transform = global_transform
		
		# remove o atual
		queue_free()
	pass # Replace with function body.
