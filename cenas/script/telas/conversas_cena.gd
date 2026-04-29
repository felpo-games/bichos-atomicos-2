extends Control

signal batalhar
signal acertou
signal capturou_oxigenio

@export var tela_dialogo: CanvasLayer
@export var respostas: Array[String]
@export var resposta_correta: String

func _ready() -> void:
	hide()
	
	var respostas_embaralhadas = respostas.duplicate()
	respostas_embaralhadas.shuffle()
	$GridContainer/Button_respostas.text = respostas_embaralhadas[0]
	$GridContainer/Button_respostas2.text = respostas_embaralhadas[1]
	$GridContainer/Button_respostas3.text = respostas_embaralhadas[2]
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	pass

func _on_button_sair_pressed() -> void:
	sair()
	pass 

func aparecer():
	eventos_global.numa_tela = true
	show()
	pass

func sair():
	hide()
	eventos_global.numa_tela = false
	pass




func _on_button_sair_mouse_entered() -> void:
	sair()
	pass # Replace with function body.


func verificar_resposta(botao: Button):
	if botao.text.strip_edges().to_lower() == resposta_correta.strip_edges().to_lower():
		acertou.emit()
	else:
		batalhar.emit()
	
	sair()

func _on_button_respostas_pressed() -> void:
	verificar_resposta($GridContainer/Button_respostas)

	pass # Replace with function body.


func _on_button_respostas_2_pressed() -> void:
	verificar_resposta($GridContainer/Button_respostas2)

	pass # Replace with function body.


func _on_button_respostas_3_pressed() -> void:
	verificar_resposta($GridContainer/Button_respostas3)

	pass # Replace with function body.



func _on_bicho_c_2_conversa() -> void:
	aparecer()
	pass # Replace with function body.
