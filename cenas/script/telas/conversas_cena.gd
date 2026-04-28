extends Control

signal batalhar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_button_batalha_pressed() -> void:
	emit_signal("batalhar")
	pass # Replace with function body.


func _on_button_sair_pressed() -> void:
	sair()
	pass # Replace with function body.

func aparecer():
	eventos_global.numa_tela = true
	show()
	pass

func sair():
	hide()
	eventos_global.numa_tela = false
	pass





func _on_batalhar() -> void:
	sair()
	pass # Replace with function body.
