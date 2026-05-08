extends Control

signal batalhar
signal acertou

@export var resposta_correta : String = "Quatro ligações."

@export var respostas := [
	"Duas ligações.",
	"Quatro ligações.",
	"Nenhuma, já sou estável."
]

var etapa = 0

@onready var texto_dialogo = $texto
@onready var botao_continuar = $ButtonContinuar

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

	etapa = 0

	proxima_fala()


func sair():

	hide()
	$CanvasLayer.visible = false


func proxima_fala():

	# PRIMEIRA FALA DO CARBONO
	if etapa == 0:

		texto_dialogo.text = """
Carbono:

" Ora, ora. Um pequeno invasor com ferramentas velhas.

Você acha que só porque carrega esse Erlenmeyer pode ditar as regras da química?

O velho tentou me prender com essa exata mesma teoria antes de tudo ir pelos ares."
"""

		botao_continuar.text = '"Por favor, me deixe passar."'

	# SEGUNDA FALA
	elif etapa == 1:

		texto_dialogo.text = """
Carbono:

" Não sem antes responder minha pergunta!

Responda:

OLHANDO PARA MIM e sabendo que eu sou a base da vida nesta floresta...

quantas ligações químicas eu preciso fazer para alcançar minha estabilidade plena?"
"""

		botao_continuar.hide()

		mostrar_respostas()


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

		texto_dialogo.text = """
Carbono:

"Hmph. Pura sorte.

Você tem a teoria...
vamos ver se tem a prática."
"""

		acertou.emit()

	else:

		texto_dialogo.text = """
Carbono:

"IGNORANTE!"
"""

		modulate = Color(1, 0.3, 0.3)

		await get_tree().create_timer(1.0).timeout

		batalhar.emit()

	await get_tree().create_timer(2.0).timeout

	sair()


func _on_button_continuar_pressed():

	etapa += 1

	proxima_fala()


func _on_button_respostas_pressed():

	verificar_resposta(botao1)


func _on_button_respostas_2_pressed():

	verificar_resposta(botao2)


func _on_button_respostas_3_pressed():

	verificar_resposta(botao3)

func _on_bicho_c_2_conversa() -> void: 
	aparecer()
