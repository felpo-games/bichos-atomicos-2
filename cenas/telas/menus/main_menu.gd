extends Control

func _ready() -> void:
	GerenciarMusica.tocar_menu()

func _on_opcoes_button_pressed() -> void:
	$Config.visible = true
	pass # Replace with function body.
