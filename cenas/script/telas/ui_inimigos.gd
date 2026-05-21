extends Control

@export var img_fogo: Texture2D
@export var img_raio: Texture2D
@export var img_normal: Texture2D

@onready var icone_fraqueza : TextureRect = $fraqueza
@onready var barra_vida : ProgressBar =  $TextureProgressBar


func _process(_delta: float) -> void:
	
	if eventos_global.batalha == false:
		$".".visible = false
	if DadosInimigos.inimigo_atual == null:
		visible = false
		return

	visible = true

	# VIDA
	barra_vida.max_value = 10.0
	barra_vida.value = DadosInimigos.inimigo_atual.vida

	# FRAQUEZA
	if not "receber_dano" in DadosInimigos.inimigo_atual:
		icone_fraqueza.texture = img_normal
		return

	match DadosInimigos.inimigo_atual.receber_dano:

		DadosInimigos.inimigo_atual.ataque.fogo:
			icone_fraqueza.texture = img_fogo

		DadosInimigos.inimigo_atual.ataque.eletrizidade:
			icone_fraqueza.texture = img_raio

		DadosInimigos.inimigo_atual.ataque.pocao:
			icone_fraqueza.texture = img_normal

		_:
			icone_fraqueza.texture = img_normal
