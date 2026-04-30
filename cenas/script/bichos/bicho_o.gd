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
		print("oi")
		
		await get_tree().create_timer(3).timeout
		queue_free()
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

@export var icon: Texture2D
func _on_conversa_o_acertou() -> void:
	
	if player == true:
		laboratorio_global.bichos_desbloqueados.append("o")
		laboratorio_global.quantidade_o += 1
		
		#icon = load("res://arte/vlad/satanas atomico/satanas atomico/ho2.png")
		var notif = $"../../ui_dialogos/telas/notificacao"
		if notif != null:
			print("Icon: ")
			notif.mostrar_notificacao("Oxigenio", icon)
		else:
			print("NOTIFICAÇÃO NÃO ENCONTRADA")
		
		hide()
		$Area3D/CollisionShape3D.disabled = true
	pass # Replace with function body.


func _on_conversa_o_capturou_oxigenio() -> void:
	_on_conversa_o_acertou()
	queue_free()
	print("quero sumir")
	pass # Replace with function body.
