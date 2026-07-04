extends Sprite3D

var tween_indicador: Tween

func _ready() -> void:
	scale = Vector3.ZERO 
	modulate.a = 0.0
	hide()

func animar(mostrar: bool) -> void:
	if tween_indicador:
		tween_indicador.kill()
		
	tween_indicador = create_tween().set_parallel(true)
	
	if mostrar:
		show()
		tween_indicador.tween_property(self, "scale", Vector3(2.5, 2.5, 2.5), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween_indicador.tween_property(self, "modulate:a", 1.0, 0.2)
	else:
		tween_indicador.tween_property(self, "scale", Vector3.ZERO, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween_indicador.tween_property(self, "modulate:a", 0.0, 0.15)
		tween_indicador.chain().tween_callback(hide)
