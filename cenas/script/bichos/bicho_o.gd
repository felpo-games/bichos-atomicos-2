extends Node3D

var conversando = false
var player 
signal conversar

@export var icon: Texture2D

# respawn
@export var reaparecer = true
@export var tempo_renascer = 5.0

var posicao_inicial: Vector3

func _ready() -> void:
	player = null
	posicao_inicial = global_position
	show()

func _process(delta: float) -> void:
	if player != null and conversando == false and Input.is_action_just_pressed("interacao"):
		emit_signal("conversar")
		conversando = true
		print("oi")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
		conversando = false

# =========================
# COLETA / MORTE
# =========================

func coletado():
	if player != null:
		laboratorio_global.bichos_desbloqueados.append("o")
		laboratorio_global.quantidade_o += 1
		
		var notif = $"../../ui_dialogos/telas/notificacao"
		if notif != null:
			notif.mostrar_notificacao("Oxigenio", icon)
		else:
			print("NOTIFICAÇÃO NÃO ENCONTRADA")
	
	if player != null:
		desativar()
	
	if reaparecer:
		respawn()

func desativar():
	hide()
	
	if has_node("Area3D/CollisionShape3D"):
		$Area3D/CollisionShape3D.disabled = true
	
	set_process(false)

func reativar():
	show()
	
	if has_node("Area3D/CollisionShape3D"):
		$Area3D/CollisionShape3D.disabled = false
	
	player = null
	conversando = false
	
	global_position = posicao_inicial
	
	set_process(true)

func respawn():
	await get_tree().create_timer(tempo_renascer).timeout
	reativar()

# =========================
# SINAIS
# =========================

func _on_conversa_o_acertou() -> void:
	coletado()

func _on_conversa_o_capturou_oxigenio() -> void:
	coletado()
