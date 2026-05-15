extends Control

signal dialogo_encerrado

const vel_leitura: float = 0.015

@onready var som_voz = $som_voz
@onready var texto = $Texto
var linhas: Array[String]
var indice: int = 0
var tween: Tween

func _ready() -> void:
	hide()


func iniciar_dialogo(novas_linhas: Array[String], arquivo_voz: AudioStream):
	linhas = novas_linhas
	indice = 0
	som_voz.stream = arquivo_voz
	show()
	mostrar_linha_atual()
	pass

func mostrar_linha_atual():
	texto.text = linhas [indice]
	texto.visible_ratio = 0.0
	
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	var tempo_animacao = texto.text.length() * vel_leitura
	tween.tween_property(texto, "visible_ratio", 1.0, tempo_animacao)
	if som_voz.stream != null:
		som_voz.play()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interacao"):
		if tween and tween.is_running():
			tween.kill() 
			texto.visible_ratio = 1.0
			som_voz.stop()
		else:
			indice += 1
			if indice < linhas.size():
				mostrar_linha_atual()
			else:
				_fechar_dialogo()

func _fechar_dialogo() -> void:
	hide()
	emit_signal("dialogo_encerrado")

func cancelar_dialogo() -> void:
	hide()
	if tween and tween.is_valid():
		tween.kill()
	som_voz.stop()
	emit_signal("dialogo_encerrado")
