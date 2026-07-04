extends Area3D

@export var imagem: Texture2D
@export var texto: String

func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	pass

func avisar():
	var icon = imagem
	var notif = $"../../UI/telas/notificacao"
	
	if notif != null:
		notif.mostrar_notificacao(
			texto,
			icon
		)
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		avisar()
