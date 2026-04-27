extends Control


@onready var imagem = $TextureRect
@onready var texto = $Label

func mostrar_notificacao(nome: String, textura: Texture2D):
	$AnimationPlayer.play("new_animation")
	imagem.texture = textura
	texto.text = "Você conseguiu um %s!" % nome
	
	visible = true
	
	# animação simples (opcional)
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.3)
	
	# espera 2 segundos e some
	await get_tree().create_timer(2).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(self, "modulate:a", 0, 0.3)
	await tween_out.finished
	
	visible = false
