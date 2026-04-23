extends Control

signal acertou
@export var fala :String

@export var opcao1 :String
@export var opcao2 :String
@export var opcao3 :String
@export var opcao_Certa :int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sair()
	$RichTextLabel.text = str(fala)
	$Button.text = str(opcao1)
	$Button2.text = str(opcao2)
	$Button3.text = str(opcao3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func dialogo_um():
	
	#fala = str("")
	
	#opcao1 = str("")
	#opcao2 = str("")
	#opcao3 = str("")
	
	#opcao_errada = opcao3
	pass

func sair():
	hide()
	eventos_global.numa_tela = false
	pass

func aparecer():
	show()
	eventos_global.numa_tela = true
	
	pass


func _on_button_pressed() -> void:
	emit_signal("acertou")
	sair()
	
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	$RichTextLabel.text = str("vc errou tende novemnete...")
	await get_tree().create_timer(2.0).timeout
	$RichTextLabel.text = str(fala)
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	$RichTextLabel.text = str("vc errou tende novemnete...")
	await get_tree().create_timer(2.0).timeout
	$RichTextLabel.text = str(fala)
	pass # Replace with function body.


func _on_bicho_o_conversar() -> void:
	aparecer()
	pass # Replace with function body.


func _on_sair_pressed() -> void:
	sair()
	pass # Replace with function body.
