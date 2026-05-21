extends Control

func _ready() -> void:
	var raiz_do_jogo = get_tree().root
	calar_tudo(raiz_do_jogo)

func calar_tudo(no_atual: Node) -> void:
	if no_atual is AudioStreamPlayer or no_atual is AudioStreamPlayer2D or no_atual is AudioStreamPlayer3D:
		no_atual.stop()
		
	for filho in no_atual.get_children():
		calar_tudo(filho)
