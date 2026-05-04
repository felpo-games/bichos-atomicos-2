extends Control

signal acertou
signal capturou_oxigenio

@export var tela_dialogo: CanvasLayer
@export var falas_oxigenio: Array[String]

func _on_bicho_o_conversar() -> void:
	tela_dialogo.iniciar_dialogo(falas_oxigenio)
	await tela_dialogo.dialogo_encerrado 
	hide()
	emit_signal("capturou_oxigenio")
	print("terminou a conversa")
	#aparecer()
	pass # Replace with function body.
