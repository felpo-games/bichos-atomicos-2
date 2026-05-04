extends CharacterBody3D

@export var queméessebicho:Array = ["o","h","c"]
enum estado  {conversa, batalhando, morto}
var state = estado.conversa

@export_range(1, 10) var chance_acerto: int = 8
@export var SPEED = 5.0
@export var forca_knockback = 15.0 
@export var tempo_de_espera = 1

# respawn
@export var reaparecer = true
@export var tempo_renascer = 5.0

var posicao_inicial: Vector3

var player: CharacterBody3D = null
var direcao_alvo := Vector3.ZERO
var pode_mover = true

var PontosVida = 3

func _ready():
	posicao_inicial = global_position

func _physics_process(delta: float):
	if state == estado.morto:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player != null and pode_mover:
		decidir_direcao()
	
	if player != null:
		if direcao_alvo != Vector3.ZERO:
			velocity.x = direcao_alvo.x * SPEED
			velocity.z = direcao_alvo.z * SPEED
		
		move_and_slide()

func decidir_direcao():
	pode_mover = false
	
	var sorteio = randi_range(1, 10)
	var direcao_real = (player.global_position - global_position).normalized()
	
	if sorteio <= chance_acerto:
		direcao_alvo = direcao_real
	else:
		var desvio = deg_to_rad(randf_range(60, 120))
		if randi() % 2 == 0:
			desvio *= -1
		direcao_alvo = direcao_real.rotated(Vector3.UP, desvio)
	
	await get_tree().create_timer(tempo_de_espera).timeout
	pode_mover = true

# =========================
# MORTE + RESPAWN
# =========================

func morrer():
	state = estado.morto
	
	laboratorio_global.bichos_desbloqueados.append(queméessebicho[0])
	laboratorio_global.quantidade_h += 1
	
	var icon = load("res://arte/vlad/satanas atomico/satanas atomico/ho2.png")
	var notif = $"../../../ui_dialogos/telas/notificacao"
	
	if notif != null:
		notif.mostrar_notificacao("hidrogenio", icon)
	
	desativar_bicho()
	
	if reaparecer:
		respawn()

func desativar_bicho():
	hide()
	set_physics_process(false)
	
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true
	
	if has_node("area_de_knockpack_e_dano_laranja/CollisionShape3D"):
		$area_de_knockpack_e_dano_laranja/CollisionShape3D.disabled = true
	
	if has_node("area_receber_danovermelha/CollisionShape3D"):
		$area_receber_danovermelha/CollisionShape3D.disabled = true
	
	if has_node("area_h/CollisionShape3D"):
		$area_h/CollisionShape3D.disabled = true
	
	$pivod/hidrogenio/AnimationPlayer.stop()

func reativar_bicho():
	show()
	set_physics_process(true)
	
	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = false
	
	if has_node("area_de_knockpack_e_dano_laranja/CollisionShape3D"):
		$area_de_knockpack_e_dano_laranja/CollisionShape3D.disabled = false
	
	if has_node("area_receber_danovermelha/CollisionShape3D"):
		$area_receber_danovermelha/CollisionShape3D.disabled = false
	
	if has_node("area_h/CollisionShape3D"):
		$area_h/CollisionShape3D.disabled = false
	
	# resetar variáveis
	PontosVida = 3
	state = estado.conversa
	player = null
	direcao_alvo = Vector3.ZERO
	pode_mover = false
	
	global_position = posicao_inicial
	
	$pivod/hidrogenio/AnimationPlayer.play("walk_2")

func respawn():
	await get_tree().create_timer(tempo_renascer).timeout
	reativar_bicho()

# =========================
# COMBATE
# =========================

func _on_area_de_knockpack_e_dano_laranja_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var sorteio = randi_range(-3, 3)
		
		if body.has_method("dano"):
			body.dano()
		
		var direcao_kb = (body.global_position - global_position).normalized()
		direcao_kb.x = sorteio
		
		if "velocity" in body:
			body.velocity = direcao_kb * forca_knockback

func _on_area_receber_danovermelha_area_entered(area: Area3D) -> void:
	if area.is_in_group("ataque_player"):
		PontosVida -= 1
		
		if PontosVida <= 0:
			morrer()

func _on_area_h_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		eventos_global.batalha = true
		pode_mover = true
		$pivod/hidrogenio/AnimationPlayer.play("walk_2")

func _on_area_h_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		pode_mover = false
		eventos_global.batalha = false
		player = null
		direcao_alvo = Vector3.ZERO
