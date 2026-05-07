extends Node3D

enum estado  {conversa, batalhando, morto}
var state = estado.conversa

enum ataque  {fogo, pocao, eletrizidade, nulo}
var receber_dano = ataque.nulo

var player_pos

# fogo
signal anim_fogo
signal parar_fogo

@export var cena_fogo: PackedScene
@export var cena_aviso: PackedScene
@export var quantidade_fogo = 5
@export var raio_spawn = 5.0

# raio
var direcao_dash = Vector3.ZERO
var velocidade_dash = 10.0
var tempo_dash = 1.0
var dash_ativo = false

# batalha

@onready var timer: Timer = $sistema_de_ataque/Timer
var vida = 10


func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	if dash_ativo:
		global_position += direcao_dash * velocidade_dash * delta
	match state:
		estado.conversa:
			
			pass
		estado.batalhando:
				
				
			pass
		estado.morto:
			
			pass
	
	pass


func ataque_():
	print("batalhar")
	var escolha = randi() % 2
	state = estado.batalhando
	if escolha == 0:
		ataque_de_fogo()
	else:
		estado_eletrico()
	pass




func ataque_de_fogo():
	$efeitos/fogo/GPUParticles3D.emitting = true
	$efeitos/raio/GPUParticles3D.emitting = false
	print("uuuuu")
	receber_dano = ataque.fogo
	emit_signal("anim_fogo")
	$pivod/AnimationPlayer.play("attack2_PH")
	$imagem/fogo.visible = true
	spawnar_fogo()
	$imagem/fogo.visible = true
	$imagem/pocao.visible = false
	$imagem/eletrizidade.visible = false
	
	await spawnar_fogo()
	estado_cansado()
	pass


func estado_eletrico():
	$efeitos/fogo/GPUParticles3D.emitting = false
	$efeitos/raio/GPUParticles3D.emitting = true
	print("uiii")
	receber_dano = ataque.eletrizidade
	$efeitos/raio/GPUParticles3D.emitting = true
	$pivod/AnimationPlayer.play("attack2_PH")
	
	$imagem/fogo.visible = false
	$imagem/pocao.visible = false
	$imagem/eletrizidade.visible = true
	
	iniciar_dash()
	
	await iniciar_dash()
	estado_cansado()
	pass

func estado_cansado():
	$efeitos/fogo/GPUParticles3D.emitting = false
	$efeitos/raio/GPUParticles3D.emitting = false
	print("cansei")
	receber_dano = ataque.pocao
	$pivod/AnimationPlayer.stop()
	$imagem/fogo.visible = false
	$imagem/pocao.visible = true
	$imagem/eletrizidade.visible = false
	$sistema_de_ataque/Timer.start()
	pass


func spawnar_fogo():
	if cena_fogo == null:
		print("ERRO: cena_fogo não definida!")
		return

	for i in range(quantidade_fogo):
		var pos = pegar_posicao_aleatoria()
		
		var aviso = mostrar_aviso(pos)

		await aviso.aviso_finalizado

		var fogo_instance = cena_fogo.instantiate()
		fogo_instance.global_position = pos
		get_tree().current_scene.add_child(fogo_instance)

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
	else:
		return global_position + offset

func mostrar_aviso(pos):
	if cena_aviso == null:
		return null
		
	var aviso = cena_aviso.instantiate()
	aviso.global_position = pos + Vector3(0, 0, 0)
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
	pass # Replace with function body.




func _on_area_vida_area_entered(area: Area3D) -> void:
	match receber_dano:
		ataque.fogo:
			if area.is_in_group("ataque_agua") and receber_dano == ataque.fogo:
				tomar_dano()
			pass
		ataque.eletrizidade:
			if area.is_in_group("ataque_dc") and receber_dano == ataque.eletrizidade :
				tomar_dano()
			pass
		ataque.pocao:
			if area.is_in_group("ataque_player") and receber_dano == ataque.pocao:
				tomar_dano()
			pass
		ataque.nulo:
			pass
	pass # Replace with function body.

func tomar_dano():
	vida -= 1
	if vida <= 0:
		eventos_global.batalha = false
		queue_free()
		state = estado.morto
	pass


func _on_area_visao_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		DadosInimigos.inimigo_atual = self
		eventos_global.batalha = true
		player_pos = body
		ataque_()
	pass # Replace with function body.
