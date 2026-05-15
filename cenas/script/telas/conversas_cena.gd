extends Control

signal batalhar
signal acertou

@export var resposta_correta : String = "Quatro ligações."

@export var respostas := [
	"Duas ligações.",
	"Quatro ligações.",
	"Nenhuma, já sou estável."
]

@onready var texto_dialogo = $texto
@onready var botao1 = $CanvasLayer/GridContainer/Button_respostas
@onready var botao2 = $CanvasLayer/GridContainer/Button_respostas2
@onready var botao3 = $CanvasLayer/GridContainer/Button_respostas3

func _ready():
	sair()
	configurar_respostas()
	esconder_respostas()

func aparecer():
	show()
	$CanvasLayer.visible = true
	if has_node("ButtonContinuar"):
		$ButtonContinuar.hide()
	
	# Deixamos apenas a pergunta final gravada na tela
	texto_dialogo.text = "Quantas ligações químicas eu preciso fazer para alcançar minha estabilidade plena?"
	
	mostrar_respostas()

func sair():
	hide()
	$CanvasLayer.visible = false
	modulate = Color(1, 1, 1)

func configurar_respostas():
	var respostas_embaralhadas = respostas.duplicate()
	respostas_embaralhadas.shuffle()
	botao1.text = respostas_embaralhadas[0]
	botao2.text = respostas_embaralhadas[1]
	botao3.text = respostas_embaralhadas[2]

func esconder_respostas():
	$CanvasLayer/GridContainer.hide()

func mostrar_respostas():
	$CanvasLayer/GridContainer.show()

func verificar_resposta(botao: Button):
	esconder_respostas()

	if botao.text == resposta_correta:
		texto_dialogo.text = "Carbono:\n\n\"Hmph. Pura sorte.\nVocê tem a teoria... vamos ver se tem a prática.\""
		acertou.emit()
	else:
		texto_dialogo.text = "Carbono:\n\n\"IGNORANTE!\""
		modulate = Color(1, 0.3, 0.3)
		await get_tree().create_timer(1.0).timeout
		batalhar.emit()

	await get_tree().create_timer(2.0).timeout
	sair()

func _on_button_respostas_pressed():
	verificar_resposta(botao1)

func _on_button_respostas_2_pressed():
	verificar_resposta(botao2)

func _on_button_respostas_3_pressed():
	verificar_resposta(botao3)
