extends CanvasLayer
signal dialogo_encerrado
@export var falas_do_personagem: Array[String]
var linha_atual = 0
var dialogo_ativo = false

func _ready():
	hide()

func iniciar_dialogo(textos: Array[String]):
	falas_do_personagem = textos
	linha_atual = 0
	dialogo_ativo = true
	mostrar_linha()
	show()
	get_tree().paused = true

func mostrar_linha():
	if linha_atual < falas_do_personagem.size():
		$Painel/Texto.text = falas_do_personagem[linha_atual]
	else:
		encerrar_dialogo()

func _input(event):
	if dialogo_ativo and event.is_action_pressed("interacao"):
		linha_atual += 1
		mostrar_linha()

func encerrar_dialogo():
	hide()
	dialogo_ativo = false
	get_tree().paused = false
	dialogo_encerrado.emit()
