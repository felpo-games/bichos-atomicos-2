extends Area3D

@export var velocidade = 10.0
@export var dano = 1

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	translate(Vector3(0, 0, -velocidade * delta))

func _on_body_entered(body: Node3D) -> void:
	if !body.is_in_group("player"):
		destruir_com_som()

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("bicho"):
		destruir_com_som()

func destruir_com_som() -> void:
	velocidade = 0 
	$frasco.hide()
	$CollisionShape3D.set_deferred("disabled", true)
	$SfxImpacto.play()
	await $SfxImpacto.finished
	queue_free()
