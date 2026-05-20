extends Node3D


var em_batalha_anterior := false

func _process(delta: float) -> void:

	if eventos_global.batalha and not em_batalha_anterior:
		$animacao_camera.play("troca_camera")

	elif not eventos_global.batalha and em_batalha_anterior:
		$animacao_camera.play_backwards("troca_camera")

	em_batalha_anterior = eventos_global.batalha
