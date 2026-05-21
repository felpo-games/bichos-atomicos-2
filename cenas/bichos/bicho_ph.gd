extends Node3D

signal player_venceu
enum estado {conversa, batalhando, morto}
var state = estado.conversa

@export_multiline var falas_ph: Array[String]
@export var voz_ph: AudioStream

var ja_falou := false
var conversando := false

enum ataque {fogo, pocao, eletrizidade, nulo}
var receber_dano = ataque.nulo

var player_pos: Node3D = null

var cena_fogo = preload("res://cenas/obstaculos/fogo_normal.tscn")
var cena_aviso = preload("res://cenas/efeitos/cena_de_aviso_de_fogo.tscn")

@export var quantidade_fogo := 5
@export var raio_spawn := 5.0

signal anim_fogo
signal parar_fogo

# DASH
var direcao_dash = Vector3.ZERO
var velocidade_dash := 5.0
var tempo_dash := 5.0
var dash_ativo := false

# VIDA
var vida := 10

# GUARDA TODOS OS FOGOS
var fogos_ativos: Array = []


func _process(delta: float) -> void:

	# MOVIMENTO DO DASH
	if dash_ativo:
		global_position += direcao_dash * velocidade_dash * delta

	match state:

		estado.conversa:

			if player_pos != null and not ja_falou and not conversando:

				if Input.is_action_just_pressed("interacao"):
					iniciar_conversa_boss()

		estado.batalhando:
			if eventos_global.batalha == false:
				eventos_global.batalha = true
				
			pass

		estado.morto:
			if eventos_global.batalha == true:
				eventos_global.batalha = false
				emit_signal("player_venceu")
			pass


func iniciar_conversa_boss():

	conversando = true

	player_pos.em_dialogo = true

	if has_node("INTERACAO_E"):
		$INTERACAO_E.animar(false)

	$"../../UI/telas/TelaDeDiálogo".iniciar_dialogo(falas_ph, voz_ph)

	await $"../../UI/telas/TelaDeDiálogo".dialogo_encerrado

	conversando = false
	ja_falou = true

	player_pos.em_dialogo = false

	ataque_()


func _on_area_visao_body_entered(body: Node3D) -> void:

	if body.is_in_group("player"):

		DadosInimigos.inimigo_atual = self

		player_pos = body

		if has_node("INTERACAO_E"):
			$INTERACAO_E.animar(true)


func _on_area_visao_body_exited(body: Node3D) -> void:

	if body.is_in_group("player"):

		player_pos = null

		if has_node("INTERACAO_E"):
			$INTERACAO_E.animar(false)

		if conversando:

			conversando = false

			body.em_dialogo = false

			$"../../UI/telas/TelaDeDiálogo".cancelar_dialogo()


func ataque_():

	print("batalhar")

	state = estado.batalhando

	var chance := randf()

	if chance < 0.3:
		await ataque_de_fogo()
	else:
		await estado_eletrico()


func ataque_de_fogo():

	print("ATAQUE DE FOGO")

	$efeitos/fogo/GPUParticles3D.emitting = true
	$efeitos/raio/GPUParticles3D.emitting = false

	receber_dano = ataque.fogo

	emit_signal("anim_fogo")

	$pivod/AnimationPlayer.play("attack2_PH")

	$imagem/fogo.visible = true
	$imagem/pocao.visible = false
	$imagem/eletrizidade.visible = false

	await spawnar_fogo()

	estado_cansado()


func estado_eletrico():

	print("ATAQUE ELÉTRICO")

	$efeitos/fogo/GPUParticles3D.emitting = false
	$efeitos/raio/GPUParticles3D.emitting = true

	receber_dano = ataque.eletrizidade

	$pivod/AnimationPlayer.play("attack2_PH")

	$imagem/fogo.visible = false
	$imagem/pocao.visible = false
	$imagem/eletrizidade.visible = true

	await iniciar_dash()

	estado_cansado()


func estado_cansado():

	print("CANSEI")

	$efeitos/fogo/GPUParticles3D.emitting = false
	$efeitos/raio/GPUParticles3D.emitting = false

	receber_dano = ataque.pocao

	$pivod/AnimationPlayer.stop()

	$imagem/fogo.visible = false
	$imagem/pocao.visible = true
	$imagem/eletrizidade.visible = false

	$sistema_de_ataque/Timer.start()


func spawnar_fogo():

	# APAGA TODOS OS FOGOS ANTIGOS
	for fogo in fogos_ativos:

		if is_instance_valid(fogo):
			fogo.queue_free()

	# LIMPA ARRAY
	fogos_ativos.clear()

	# CRIA NOVOS FOGOS
	for i in range(quantidade_fogo):

		var pos = pegar_posicao_aleatoria()

		var aviso = mostrar_aviso(pos)

		if aviso == null:
			return

		await aviso.aviso_finalizado

		var fogo_instance = cena_fogo.instantiate()

		fogo_instance.global_position = pos

		get_tree().current_scene.add_child(fogo_instance)

		# GUARDA REFERÊNCIA
		fogos_ativos.append(fogo_instance)

		await get_tree().create_timer(0.3).timeout


func pegar_posicao_aleatoria():

	var offset = Vector3(
		randf_range(-raio_spawn, raio_spawn),
		0,
		randf_range(-raio_spawn, raio_spawn)
	)

	var origem = global_position + offset + Vector3(0, 10, 0)

	var destino = origem + Vector3(0, -20, 0)

	var space = get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.create(origem, destino)

	var result = space.intersect_ray(query)

	if result:
		return result.position + Vector3(0, 0.2, 0)

	return global_position + offset


func mostrar_aviso(pos):

	var aviso = cena_aviso.instantiate()

	aviso.global_position = pos

	get_tree().current_scene.add_child(aviso)

	return aviso


func iniciar_dash():

	if player_pos == null:
		return

	var direcao = (player_pos.global_position - global_position)

	direcao.y = 0

	direcao_dash = direcao.normalized()

	dash_ativo = true

	await get_tree().create_timer(tempo_dash).timeout

	dash_ativo = false


func _on_timer_timeout() -> void:

	ataque_()


func _on_area_vida_area_entered(area: Area3D) -> void:

	match receber_dano:

		ataque.fogo:

			if area.is_in_group("ataque_agua"):
				tomar_dano()

		ataque.eletrizidade:

			if area.is_in_group("ataque_dc"):
				tomar_dano()

		ataque.pocao:

			if area.is_in_group("ataque_player"):
				tomar_dano()

		ataque.nulo:
			pass


func tomar_dano():

	vida -= 1

	print("VIDA:", vida)

	if vida <= 0:

		state = estado.morto

		eventos_global.batalha = false

		# APAGA TODOS OS FOGOS AO MORRER
		for fogo in fogos_ativos:

			if is_instance_valid(fogo):
				fogo.queue_free()

		fogos_ativos.clear()

		queue_free()
