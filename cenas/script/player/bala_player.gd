extends Area3D

@export var velocidade = 10.0
@export var dano = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector3(0, 0, -velocidade * delta))
	pass


func _on_body_entered(body: Node3D) -> void:
	
	if !body.is_in_group("player"):
		queue_free()
		pass
	pass # Replace with function body.


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("bicho"):
		queue_free()
	pass # Replace with function body.
