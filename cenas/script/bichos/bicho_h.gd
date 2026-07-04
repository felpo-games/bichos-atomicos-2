extends CharacterBody3D

@export var queméessebicho:Array = ["o","h","c"]

enum estado {conversa, batalhando, morto}
var state = estado.conversa

@export_range(1, 10) var chance_acerto: int = 8

# MOVIMENTO
@export var SPEED = 7.0
@export var rotation_speed := 6.0

# DASH
@export var usar_dash := true
@export var velocidade_dash := 30.0
@export var tempo_dash := 0.5
@export var cooldown_dash := 2.0

var pode_dash = true
var em_dash = false

# KNOCKBACK
@export var forca_knockback = 15.0
@export var tempo_de_espera = 1.0

# RESPAWN
@export var reaparecer = true
@export var tempo_renascer = 5.0

# FRAQUEZA
@export var fraqueza = "agua"

var posicao_inicial: Vector3

var player: CharacterBody3D = null

var direcao_alvo := Vector3.ZERO
var pode_mover = true

var vida = 3

var voltando_para_casa := false

func _ready():

	posicao_inicial = global_position


func _physics_process(delta: float):

	if state == estado.morto:
		return

	# gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# IA movimento
	if player != null and pode_mover and not em_dash:
		decidir_direcao()

	# combate
	if player != null:

		# movimentação
		if direcao_alvo != Vector3.ZERO and not em_dash:

			velocity.x = direcao_alvo.x * SPEED
			velocity.z = direcao_alvo.z * SPEED

		# olhar suavemente pro player
		var alvo = player.global_position
		alvo.y = global_position.y

		var direcao = (alvo - global_position).normalized()

		var angulo = atan2(direcao.x, direcao.z)

		rotation.y = lerp_angle(
			rotation.y,
			angulo,
			rotation_speed * delta
		)
# IA movimento
	if player != null and pode_mover and not em_dash:
		decidir_direcao()
	elif voltando_para_casa and pode_mover:
		# Se não tem player mas está voltando, calcula a direção até a base
		direcao_alvo = (posicao_inicial - global_position).normalized()
		
		# Se ele já chegou muito perto do centro, ele para de andar
		if global_position.distance_to(posicao_inicial) < 0.5:
			direcao_alvo = Vector3.ZERO
			voltando_para_casa = false
			$pivod/hidrogenio/AnimationPlayer.stop() # Ou bota a animação de "idle" aqui

	# combate e retorno
	# Mudamos a condição abaixo para rodar se houver player OU se estiver voltando
	if player != null or voltando_para_casa:

		# movimentação
		if direcao_alvo != Vector3.ZERO and not em_dash:
			velocity.x = direcao_alvo.x * SPEED
			velocity.z = direcao_alvo.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0

		# olhar suavemente pro alvo (player ou posição inicial)
		var alvo = player.global_position if player != null else posicao_inicial
		alvo.y = global_position.y

		var direcao = (alvo - global_position).normalized()
		var angulo = atan2(direcao.x, direcao.z)

		rotation.y = lerp_angle(
			rotation.y,
			angulo,
			rotation_speed * delta
		)

		move_and_slide()


func decidir_direcao():

	pode_mover = false

	var sorteio = randi_range(1, 10)

	var direcao_real = (
		player.global_position - global_position
	).normalized()

	# segue player
	if sorteio <= chance_acerto:

		direcao_alvo = direcao_real

	# circula player
	else:

		var desvio = deg_to_rad(randf_range(70, 120))

		if randi() % 2 == 0:
			desvio *= -1

		direcao_alvo = direcao_real.rotated(
			Vector3.UP,
			desvio
		)

	# dash aleatório
	if usar_dash and pode_dash:

		if randi_range(1, 100) <= 30:
			dash_no_player()

	await get_tree().create_timer(
		tempo_de_espera
	).timeout

	pode_mover = true


func dash_no_player():

	if player == null:
		return

	pode_dash = false
	em_dash = true

	var dir = (
		player.global_position - global_position
	).normalized()

	velocity.x = dir.x * velocidade_dash
	velocity.z = dir.z * velocidade_dash

	await get_tree().create_timer(
		tempo_dash
	).timeout

	em_dash = false

	await get_tree().create_timer(
		cooldown_dash
	).timeout

	pode_dash = true


# =========================
# MORTE + RESPAWN
# =========================

func morrer():
	eventos_global.batalha = false
	state = estado.morto

	if has_node("AvisoAlerta"):
		$AvisoAlerta.animar(false)

	laboratorio_global.bichos_desbloqueados.append(
		queméessebicho[0]
	)

	laboratorio_global.quantidade_h += 1

	var icon = load(
		"res://arte/vlad/satanas atomico/satanas atomico/ho2.png"
	)

	var notif = $"../../../UI/telas/notificacao"

	if notif != null:
		notif.mostrar_notificacao(
			"Você pegou Hidrogênio!",
			icon
		)

	desativar_bicho()

	if reaparecer:
		respawn()


func desativar_bicho():

	hide()

	set_physics_process(false)

	if has_node("CollisionShape3D"):
		$CollisionShape3D.set_deferred(
			"disabled",
			true
		)

	if has_node("area_de_knockpack_e_dano_laranja/CollisionShape3D"):
		$area_de_knockpack_e_dano_laranja/CollisionShape3D.set_deferred(
			"disabled",
			true
		)

	if has_node("area_receber_danovermelha/CollisionShape3D"):
		$area_receber_danovermelha/CollisionShape3D.set_deferred(
			"disabled",
			true
		)

	if has_node("area_h/CollisionShape3D"):
		$area_h/CollisionShape3D.set_deferred(
			"disabled",
			true
		)

	$pivod/hidrogenio/AnimationPlayer.stop()


func reativar_bicho():

	show()

	set_physics_process(true)

	if has_node("CollisionShape3D"):
		$CollisionShape3D.set_deferred(
			"disabled",
			false
		)

	if has_node("area_de_knockpack_e_dano_laranja/CollisionShape3D"):
		$area_de_knockpack_e_dano_laranja/CollisionShape3D.set_deferred(
			"disabled",
			false
		)

	if has_node("area_receber_danovermelha/CollisionShape3D"):
		$area_receber_danovermelha/CollisionShape3D.set_deferred(
			"disabled",
			false
		)

	if has_node("area_h/CollisionShape3D"):
		$area_h/CollisionShape3D.set_deferred(
			"disabled",
			false
		)

	vida = 3

	state = estado.conversa

	player = null

	direcao_alvo = Vector3.ZERO

	pode_mover = false

	global_position = posicao_inicial

	$pivod/hidrogenio/AnimationPlayer.play(
		"walk_2"
	)


func respawn():

	await get_tree().create_timer(
		tempo_renascer
	).timeout

	reativar_bicho()


# =========================
# COMBATE
# =========================

func _on_area_de_knockpack_e_dano_laranja_body_entered(body: Node3D) -> void:

	if state == estado.morto:
		return

	if body.is_in_group("player"):

		# dano
		if body.has_method("dano"):
			body.dano()

		# direção knockback
		var direcao_kb = (
			body.global_position - global_position
		)

		direcao_kb.y = 0

		direcao_kb = direcao_kb.normalized()

		# força horizontal
		var knockback = direcao_kb * forca_knockback

		# arco
		knockback.y = forca_knockback * 0.7

		# aplica knockback
		body.receber_knockback(knockback)


func _on_area_receber_danovermelha_area_entered(area: Area3D) -> void:

	if state == estado.morto:
		return

	if area.is_in_group("ataque_player"):

		vida -= 1

		DadosInimigos.status_inimigo["vida"] = vida

		DadosInimigos.status_inimigo["fraqueza"] = fraqueza

		if vida <= 0:
			morrer()


func _on_area_h_body_entered(body: Node3D) -> void:

	if state == estado.morto:
		return

	if body.is_in_group("player"):

		player = body
		voltando_para_casa = false # Interrompe a volta se o player reentrar na área

		if has_node("AvisoAlerta"):
			$AvisoAlerta.animar(true)

		DadosInimigos.inimigo_atual = self
		DadosInimigos.status_inimigo["vida"] = vida
		DadosInimigos.status_inimigo["fraqueza"] = fraqueza
		eventos_global.batalha = true
		pode_mover = true

		$pivod/hidrogenio/AnimationPlayer.play("walk_2")


func _on_area_h_body_exited(body: Node3D) -> void:

	if body.is_in_group("player"):

		player = null
		DadosInimigos.inimigo_atual = null

		if has_node("AvisoAlerta"):
			$AvisoAlerta.animar(false)
		
		# Ativa o modo de retorno
		voltando_para_casa = true
		pode_mover = true
		
		# Garante que ele continue tocando a animação de andar até chegar lá
		$pivod/hidrogenio/AnimationPlayer.play("walk_2")
