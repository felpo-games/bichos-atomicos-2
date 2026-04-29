extends Node3D


var conversando = false
var player 
signal conversar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = false
	show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == true and conversando == false and Input.is_action_just_pressed("interacao"):
		emit_signal("conversar")
		conversando = true
		
		pass
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = false
		conversando = false
	pass # Replace with function body.


func _on_conversa_o_acertou() -> void:
	if player == true:
		laboratorio_global.bichos_desbloqueados.append("o")
		laboratorio_global.quantidade_o += 1
		
		var icon = load("res://arte/miguel/WhatsApp Image 2026-04-13 at 10.56.26.jpeg")
		$"../../personagem/telas/notificacao".mostrar_notificacao("oxigenio", icon )
		
		hide()
		$Area3D/CollisionShape3D.disabled = true
	pass # Replace with function body.


func _on_conversa_o_capturou_oxigenio() -> void:
	get_parent().queue_free()
	pass # Replace with function body.
