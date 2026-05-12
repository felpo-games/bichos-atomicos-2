extends Node
@export var tela_imagem: Node
@export var tela_audio: Node
@export var tela_compartilhe:Node
@export var sprit_1:Texture2D
@export var sprit_2:Texture2D
@export var sprit_3:Texture2D
@export var link:String
@export var teste:float

func ativar_tela_imagem():
	tela_imagem.show()
	tela_audio.hide()
	tela_compartilhe.hide()
	$Panel/PanelContainer/ElenmeyerOpt1.texture=sprit_2
func ativar_tela_audio():
	tela_imagem.hide()
	tela_audio.show()
	tela_compartilhe.hide()
	$Panel/PanelContainer/ElenmeyerOpt1.texture=sprit_1
func ativar_tela_compartilhe():
	tela_imagem.hide()
	tela_audio.hide()
	tela_compartilhe.show()
	$Panel/PanelContainer/ElenmeyerOpt1.texture=sprit_3
	
func acesar_link():
	OS.shell_open(link)
	
func mudanca_de_valor_slider(novo_valor:float):
	teste=novo_valor
	print(teste)
