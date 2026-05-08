extends Node3D

signal peguei_pagina

var player
var pega = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

		
	pass

func pegar():
	pega = true
	eventos_global.paginas_coletadas += 1
	queue_free()
	var icon = load("res://arte/felp/pagina.png")
	$"../../ui_dialogos/telas/notificacao".mostrar_notificacao(
	"pagina",
	icon
	)
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		pegar()
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	
	pass # Replace with function body.
