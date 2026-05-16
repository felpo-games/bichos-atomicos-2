extends Node
@export var tela_imagem:Node
@export var tela_audio: Node
@export var tela_compartilhe:Node
@export var sprit_1:Texture2D
@export var sprit_2:Texture2D
@export var sprit_3:Texture2D
@export var link:String
@export var teste:float
var bus_musica_id = AudioServer.get_bus_index("musica")

#PROGRAMAÇÃO DO FILTRO
@onready var marcador_de_filtro = $ColorRect/imagem/MARCADO_DE_FILTRO
@onready var ativado_desativado = $ColorRect/imagem/ATIVADO_DESATIVADO



func _ready() -> void:
	var volume_atual = AudioServer.get_bus_volume_db(bus_musica_id)
	$ColorRect/audio/HSlider.value = db_to_linear(volume_atual)
	var estado_atual = FiltroAzul.get_node("filtro").visible #INICIO PROGRAMAÇÃO FILTRO
	marcador_de_filtro.button_pressed = estado_atual
	atualizar_texto_label(estado_atual)

func ativar_tela_imagem():
	tela_imagem.show()
	tela_audio.hide()
	tela_compartilhe.hide()
	$ColorRect/ElenmeyerOpt1.texture=sprit_1
func ativar_tela_audio():
	tela_imagem.hide()
	tela_audio.show()
	tela_compartilhe.hide()
	$ColorRect/ElenmeyerOpt1.texture=sprit_2
func ativar_tela_compartilhe():
	tela_imagem.hide()
	tela_audio.hide()
	tela_compartilhe.show()
	$ColorRect/ElenmeyerOpt1.texture=sprit_3
	
func acesar_link():
	OS.shell_open(link)
	
func _on_h_slider_value_changed(value: float) -> void:
	var volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_musica_id, volume)
	pass 


func _on_botao_sair_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://cenas/telas/menus/main_menu.tscn")
	pass # Replace with function body.


func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return
	var jogador = get_tree().get_nodes_in_group("player")
	if self.visible == true:
		if jogador.size() > 0 and jogador[0].ui_atomo != null:
			jogador[0].ui_atomo.visible = false
		if get_tree().paused == true:
			$ColorRect/BotaoVoltar.visible = true
			$ColorRect/BotaoSair.visible = true
		else:
			$ColorRect/BotaoVoltar.visible = true
			$ColorRect/BotaoSair.visible = false
	else:
		if jogador.size() > 0 and jogador[0].ui_atomo != null:
			jogador[0].ui_atomo.visible = true


func _on_botao_voltar_pressed() -> void:
	self.visible = false
	if get_tree().paused == true:
		get_tree().paused = false
	pass # Replace with function body.

func _on_marcado_de_filtro_toggled(ligado: bool) -> void: #PROGRAMAÇÃO FILTRO
	if FiltroAzul.has_node("filtro"):
		FiltroAzul.get_node("filtro").visible = ligado
	atualizar_texto_label(ligado)
	print("o filtro está: ", ligado)

func atualizar_texto_label(esta_ligado): #PROGRAMAÇÃO FILTO
	if esta_ligado:
		ativado_desativado.text = "ATIVADO"
		ativado_desativado.add_theme_color_override("font_color", Color.GREEN)
	else:
		ativado_desativado.text = "DESATIVADO"
		ativado_desativado.add_theme_color_override("font_color", Color.GRAY)
	pass
