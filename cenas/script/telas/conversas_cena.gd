extends Control

signal batalhar
signal acertou

@export var resposta_correta : String = "Quatro ligações."

@export var respostas := [
	"Duas ligações.",
	"Quatro ligações.",
	"Nenhuma, já sou estável."
]

@export_multiline var falas_acerto : Array[String] = []
@export_multiline var fala_erro : String = ""

@onready var texto_dialogo = $texto
@onready var botao1 = $CanvasLayer/GridContainer/Button_respostas
@onready var botao2 = $CanvasLayer/GridContainer/Button_respostas2
@onready var botao3 = $CanvasLayer/GridContainer/Button_respostas3

var botao_correto: TextureButton

# --- VARIÁVEIS DE CONTROLE DO NOVO DIÁLOGO ---
var lendo_dialogo_final: bool = false
var falas_atuais: Array[String] = []
var indice_fala: int = 0
var tween_texto: Tween
var jogador_acertou: bool = false

func _ready():
	sair()
	esconder_respostas()

func aparecer():
	eventos_global.batalha = false
	
	show()
	$CanvasLayer.visible = true
	if has_node("ButtonContinuar"):
		$ButtonContinuar.hide()
	
	texto_dialogo.text = "Quantas ligações químicas eu preciso fazer para alcançar minha estabilidade plena?"
	texto_dialogo.visible_ratio = 1.0 # Garante que a pergunta apareça inteira
	
	configurar_respostas()
	mostrar_respostas()

func sair():
	eventos_global.batalha = false
	hide()
	$CanvasLayer.visible = false
	modulate = Color(1, 1, 1)

func configurar_respostas():
	var respostas_embaralhadas = respostas.duplicate()
	respostas_embaralhadas.shuffle()
	
	var texto_certo = resposta_correta.strip_edges()
	
	botao1.get_node("Label").text = respostas_embaralhadas[0]
	if respostas_embaralhadas[0].strip_edges() == texto_certo:
		botao_correto = botao1

	botao2.get_node("Label").text = respostas_embaralhadas[1]
	if respostas_embaralhadas[1].strip_edges() == texto_certo:
		botao_correto = botao2

	botao3.get_node("Label").text = respostas_embaralhadas[2]
	if respostas_embaralhadas[2].strip_edges() == texto_certo:
		botao_correto = botao3

func esconder_respostas():
	$CanvasLayer/GridContainer.hide()

func mostrar_respostas():
	$CanvasLayer/GridContainer.show()

func verificar_resposta(botao_clicado: TextureButton):
	esconder_respostas()

	if botao_clicado == botao_correto:
		# Se acertou: entra no sistema de diálogo normal, aguardando o "E"
		jogador_acertou = true
		iniciar_dialogo(falas_acerto)
	else:
		# Se errou: bypass total. O Carbono grita e a batalha começa sozinha.
		jogador_acertou = false
		texto_dialogo.text = fala_erro
		
		# Força o texto a aparecer todo de uma vez (sem efeito máquina de escrever)
		texto_dialogo.visible_ratio = 1.0 
		
		# Pinta a tela de vermelho
		modulate = Color(1, 0.3, 0.3)
		
		# Congela a tela por 1.5 segundos dramáticos para o jogador ler o grito...
		await get_tree().create_timer(1.5).timeout
		
		# ...e solta o bicho para a batalha!
		batalhar.emit()
		sair()

# --- SISTEMA DE ANIMAÇÃO DE TEXTO ---

func iniciar_dialogo(lista_falas: Array[String]):
	falas_atuais = lista_falas
	indice_fala = 0
	lendo_dialogo_final = true
	tocar_fala()

func tocar_fala():
	# Se acabaram as frases da lista, o diálogo finaliza o quiz
	if indice_fala >= falas_atuais.size():
		lendo_dialogo_final = false
		if jogador_acertou:
			acertou.emit()
		else:
			await get_tree().create_timer(1.0).timeout
			batalhar.emit()
		sair()
		return

	# Prepara a tela para a próxima fala
	texto_dialogo.text = falas_atuais[indice_fala]
	texto_dialogo.visible_characters = 0

	# Reinicia o Tween (Animação)
	if tween_texto:
		tween_texto.kill()
	tween_texto = create_tween()

	# A matemática profissional da leitura: 0.03 segundos para cada letra existir
	var tempo_de_leitura = texto_dialogo.text.length() * 0.03
	tween_texto.tween_property(texto_dialogo, "visible_ratio", 1.0, tempo_de_leitura)

func _input(event: InputEvent):
	if lendo_dialogo_final:
		# Checa se o jogador apertou a tecla E fisicamente
		if event is InputEventKey and event.pressed and event.keycode == KEY_E:
			
			# === A MÁGICA ACONTECE AQUI ===
			# Avisa ao motor: "Este clique já foi processado pela interface."
			# Isso bloqueia o vazamento e impede o Player de tentar interagir de novo.
			get_viewport().set_input_as_handled()
			
			# O texto ainda está sendo desenhado? Se sim, auto-completar!
			if tween_texto and tween_texto.is_running():
				tween_texto.kill()
				texto_dialogo.visible_ratio = 1.0
			else:
				# O texto já estava 100% visível? Passa pra próxima página!
				indice_fala += 1
				tocar_fala()

func _on_button_respostas_pressed():
	verificar_resposta(botao1)

func _on_button_respostas_2_pressed():
	verificar_resposta(botao2)

func _on_button_respostas_3_pressed():
	verificar_resposta(botao3)
