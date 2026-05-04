extends Node3D

signal aviso_finalizado

@export var tempo = 5.0

func _ready():
	await get_tree().create_timer(tempo).timeout
	emit_signal("aviso_finalizado")
	queue_free()
