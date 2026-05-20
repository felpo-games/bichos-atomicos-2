extends CharacterBody3D

#FALAS
@export_multiline var falas_carbono: Array[String]
@export var voz_carbono: AudioStream

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var queméessebicho:Array = ["o","h","c"]

enum estado {conversa, batalhando, morto}
var state = estado.conversa

# referência do player
var player

# variáveis de conversa
var conversar:bool = true
var conversando:bool = false

signal conversa

# variáveis de batalha
var vida = 4
var morto = false
var grande = false
@export var speed: float = 3.0

# fraqueza do inimigo
@export var fraqueza = "pocao"

# variáveis de knockback
@export var forca_knockback = 15.0
@export var forca_vertical = 5.0
var pode_bater = true
@export var tempo_knockback = 1.0

# respawn
@export var reaparecer = true
@export var tempo_renascer = 5.0

var posicao_inicial: Vector3

func _ready() -> void:
	posicao_inicial = global_transform.origin
	$AnimationPlayer.play("inicio")
	
	# ATENÇÃO: Comentei estas linhas abaixo porque elas estão fazendo 
	# o Carbono morrer sozinho após 1.5s que a fase começa.
	# await get_tree().create_timer(1.5).timeout
	# derrotado()
	

func _physics_process(delta):

	# gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	match state:

		estado.conversa:
			if Input.is_action_just_pressed("interacao") and player != null and not conversando:
				conversando = true
				player.em_dialogo = true
				if has_node("INTERACAO_E"):
					$INTERACAO_E.animar(false)
				$"../../UI/telas/TelaDeDiálogo".iniciar_dialogo(falas_carbono, voz_carbono)
				await $"../../UI/telas/TelaDeDiálogo".dialogo_encerrado
				if player == null:
					conversando = false
					return
				iniciar_pergunta_carbono()

		estado.batalhando:
			
			# atualiza vida no global
			DadosInimigos.status_inimigo["vida"] = vida
			DadosInimigos.status_inimigo["fraqueza"] = fraqueza

			andar()
			$AnimationPlayer.play("new_animation")

		estado.morto:
			pass
			
	move_and_slide()

var icon: Texture2D

func derrotado():
	
	if player != null:
		player.em_dialogo = false
		
	eventos_global.batalha = false
	$crecimento/AreadeDano/CollisionShape3D.set_deferred("disabled", true)
	
	icon = load("res://arte/vlad/satanas atomico/satanas atomico/c.png")
	$"../../UI/telas/notificacao".mostrar_notificacao(
		"carbono",
		icon
	)

	state = estado.morto

	laboratorio_global.bichos_desbloqueados.append(queméessebicho[0])
	laboratorio_global.quantidade_c += 1

	morto = true

	desativar_bicho()

	if reaparecer:
		respawn()

func desativar_bicho():

	hide()

	set_physics_process(false)

	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = true

	if has_node("areade_dano/CollisionShape3D"):
		$areade_dano/CollisionShape3D.disabled = true

	if has_node("area_conversa/CollisionShape3D"):
		$area_conversa/CollisionShape3D.disabled = true

	$AnimationPlayer.stop()

func reativar_bicho():
	$crecimento/AreadeDano/CollisionShape3D.set_deferred("disabled", false)
	show()

	set_physics_process(true)

	if has_node("CollisionShape3D"):
		$CollisionShape3D.disabled = false

	if has_node("areade_dano/CollisionShape3D"):
		$areade_dano/CollisionShape3D.disabled = false

	if has_node("area_conversa/CollisionShape3D"):
		$area_conversa/CollisionShape3D.disabled = false

	# resetar variáveis
	vida = 4
	morto = false
	grande = false

	state = estado.conversa

	player = null

	scale = Vector3.ONE

	global_transform.origin = posicao_inicial

	$AnimationPlayer.play("inicio")

func respawn():

	await get_tree().create_timer(tempo_renascer).timeout

	reativar_bicho()

func andar():

	$crecimento/pivod/AnimationPlayer.play("attack_C")

	if player == null:
		return

	var direcao = player.global_transform.origin - global_transform.origin

	var distancia = direcao.length()

	direcao = direcao.normalized()

	if distancia > 2.0:

		velocity.x = direcao.x * speed
		velocity.z = direcao.z * speed

	else:

		velocity.x = 0
		velocity.z = 0

	var alvo = player.global_transform.origin

	alvo.y = global_transform.origin.y

	look_at(alvo, Vector3.UP)

func crecer():

	if not grande:
		
		eventos_global.batalha = true
		print(eventos_global.batalha)
		grande = true

		var tween = create_tween()

		tween.tween_property(
			self,
			"scale",
			Vector3.ONE * 5.0,
			1.5
		)

func aplicar_knockback(alvo):

	if not pode_bater:
		return

	pode_bater = false

	var direcao = alvo.global_transform.origin - global_transform.origin

	direcao.y = 0

	direcao = direcao.normalized()

	var forca = Vector3(
		direcao.x * forca_knockback,
		forca_vertical,
		direcao.z * forca_knockback
	)

	if alvo.has_method("receber_knockback"):
		alvo.receber_knockback(forca)

	await get_tree().create_timer(tempo_knockback).timeout

	pode_bater = true

func _on_area_conversa_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		if has_node("INTERACAO_E"):
			$INTERACAO_E.animar(true)

func _on_area_conversa_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null 
		if has_node("INTERACAO_E"):
			$INTERACAO_E.animar(false)

func _on_conversas_cena_batalhar() -> void:
	state = estado.batalhando
	if player != null:
		player.em_dialogo = false 
		
	crecer()

func _on_conversas_cena_acertou() -> void:
	state = estado.morto
	derrotado()

# Esta função veio da branch MAIN (Do Felipe) com seus áudios
func _on_areadeataque_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and state == estado.batalhando:
		if has_node("som_danoCO2"):
			$som_danoCO2.play()
		aplicar_knockback(body)
		body.dano()

func _on_areade_dano_area_entered(area: Area3D) -> void:
	if area.is_in_group("ataque_player"):
		vida -= 1
		
		if has_node("Som_ataque"):
			$Som_ataque.play()

		# atualiza global
		DadosInimigos.status_inimigo["vida"] = vida
		DadosInimigos.status_inimigo["fraqueza"] = fraqueza

		if vida <= 0:
			eventos_global.batalha = false
			state = estado.morto
			derrotado()

func iniciar_pergunta_carbono() -> void:
	$"../../UI/telas/conversas_cena".aparecer()
