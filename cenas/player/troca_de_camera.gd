extends Node3D

var ligado := false

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if ligado:
			print("Desligou")
			$animacao_camera.play("troca_camera")
			
		else:
			print("Ligou")
			$animacao_camera.play_backwards("troca_camera")

		ligado = !ligado
