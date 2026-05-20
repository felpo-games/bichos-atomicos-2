extends Control

enum index_animation {expandir_1, expandir_2, expandir_3, encolher_1, encolher_2, encolher_3}
var pending_exit: bool

@export var cena_elenmeyer: PackedScene

@onready var timer = $Timer
@onready var anim_play = $AnimationPlayer

func abrir_elenmeyer():
	get_tree().change_scene_to_packed(cena_elenmeyer)
	
func expan_enco(index: index_animation):
	# Convertemos o nome do enum para minúsculo (ou mantemos igual) 
	# para bater com o nome da animação no nó
	var anim_nomes = index_animation.keys()[index].to_lower()
	anim_play.play(anim_nomes)
	pending_exit = true
	timer.start(0.5)
	
func incluir_bicho_img():
	if laboratorio_global.pet_agua == true:
		$CanvasLayer/Seletor1/Bicho1.show()
	if laboratorio_global.pet_dc == true:
		$CanvasLayer/Seletor2/Bicho2.show()
	pass
func _on_seletor_1_mouse_entered() -> void:
	expan_enco(index_animation.expandir_1)

func _on_seletor_1_mouse_exited() -> void:
	expan_enco(index_animation.encolher_1)
	
func _on_seletor_2_mouse_entered() -> void:
	expan_enco(index_animation.expandir_2)

func _on_seletor_2_mouse_exited() -> void:
	expan_enco(index_animation.encolher_2)

func _on_seletor_3_mouse_entered() -> void:
	expan_enco(index_animation.expandir_3)

func _on_seletor_3_mouse_exited() -> void:
	expan_enco(index_animation.encolher_3)
	
func _on_timer_timeout() -> void:
	pending_exit = false
	timer.stop()
	print("timeout ok")
	pass # Replace with function body.

func _on_button_pressed() -> void:
	abrir_elenmeyer()
	pass # Replace with function body.
