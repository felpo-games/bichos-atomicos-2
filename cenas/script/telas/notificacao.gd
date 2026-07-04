extends Control


@onready var imagem = $TextureRect
@onready var texto = $Label

func mostrar_notificacao(mensagem: String, textura: Texture2D):
	print(textura)

	$AnimationPlayer.play("new_animation")
	AudioManager.get_node("SFXpop_up").play()

	imagem.texture = textura
	texto.text = mensagem

	visible = true

	modulate.a = 0

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.3)

	await get_tree().create_timer(2).timeout

	var tween_out = create_tween()
	tween_out.tween_property(self, "modulate:a", 0, 0.3)

	await tween_out.finished

	visible = false
