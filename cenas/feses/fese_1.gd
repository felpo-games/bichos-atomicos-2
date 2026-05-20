extends Node3D

@onready var laboratorio: Control = $UI/telas/Laboratorio_iventario

func _ready() -> void:
	GerenciarMusica.tocar_mundo()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("laboratorio") and not $UI/telas/Laboratorio_iventario.visible:
		$UI/telas/Laboratorio_iventario.atualizar_icones_inventario()
		$UI/telas/Laboratorio_iventario.show()
		get_tree().paused = true

func abrir_codice():
	laboratorio.show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func fechar_codice():
	laboratorio.hide()
	get_tree().paused = false
