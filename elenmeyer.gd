extends Control
@export var tela_elementos: Node
@export var tela_sintese: Node
@export var tela_compostos: Node
@export var sprit_1:Texture2D
@export var sprit_2:Texture2D
@export var sprit_3:Texture2D
@export var teste:float

func ativar_tela_sintese():
	tela_sintese.show()
	tela_elementos.hide()
	tela_compostos.hide()
	$Panel/PanelContainer/ElenmeyerOpt1.texture=sprit_2
func ativar_tela_elementos():
	tela_sintese.hide()
	tela_elementos.show()
	tela_compostos.hide()
	$Panel/PanelContainer/ElenmeyerOpt1.texture=sprit_1
func ativar_tela_compostos():
	tela_sintese.hide()
	tela_elementos.hide()
	tela_compostos.show()
	$Panel/PanelContainer/ElenmeyerOpt1.texture=sprit_3
	

# Called when the node enters the scene tree for the first time.
