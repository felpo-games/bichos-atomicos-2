extends CharacterBody3D

var em_dialogo: bool = false

@onready var menu_opcoes: Control = $"../../UI/telas/Config"
@export var ui_atomo: Control

# VIDA
var vida = 3

# ESTADOS
enum estado {normal, batalhando, morto}
var state = estado.normal

# MOVIMENTO
var SPEED = 30.0
@export var rotation_speed = 10.0

# TIRO
@export var bala_cena: PackedScene
@onready var arma: Marker3D = $body/Marker3D

var pode_atirar = true
@export var tempo_tiro := 0.3

# GRAVIDADE
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# INVENCIBILIDADE
var tomar_dano = true
@export var tempo_dano := 1.0

# KNOCKBACK
var em_knockback := false
@export var tempo_knockback := 0.3


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("abri_tela_opcoes"):
		alternar_pausa()

func alternar_pausa():
	var jogo_pausado = get_tree().paused
	get_tree().paused = !jogo_pausado
	menu_opcoes.visible = !jogo_pausado

func _physics_process(delta: float) -> void:

	# troca pet
	if Input.is_action_just_pressed("troca_de_pet"):
		laboratorio_global.pet_1 = !laboratorio_global.pet_1
		print(laboratorio_global.pet_1)

	# tiro
	if Input.is_action_just_pressed("campirar") and eventos_global.batalha == true:
		atirar()
		print(atirar)
		
	# dialogo
	if em_dialogo:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$body/pivod/AnimationPlayer.play("idle_Pl")
		move_and_slide()
		return

	# gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# movimento
	if not em_knockback:

		# =========================
		# MODO NORMAL
		# =========================
		if not eventos_global.batalha:

			var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
			var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
			
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				$body/pivod/AnimationPlayer.play("walk_Pl")
				var target_angle = atan2(direction.x, direction.z)
				$body.rotation.y = lerp_angle($body.rotation.y, target_angle, rotation_speed * delta)
			else:
				$body/pivod/AnimationPlayer.play("idle_Pl")
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)

		# =========================
		# MODO BATALHA (TANQUE)
		# =========================
		else:

			# gira esquerda/direita
			var rotacao := Input.get_axis("direita", "esquerda")
			$body.rotation.y += rotacao * rotation_speed * delta

			# frente/trás
			var mover := Input.get_axis("frente", "tras")

			# direção da frente do body
			var frente = -$body.global_transform.basis.z.normalized()

			velocity.x = frente.x * mover * SPEED
			velocity.z = frente.z * mover * SPEED

			if mover != 0:
				$body/pivod/AnimationPlayer.play("walk_Pl")
			else:
				$body/pivod/AnimationPlayer.play("idle_Pl")

	move_and_slide()


func atirar():
	if not eventos_global.batalha:
		return

	if not pode_atirar:
		return

	pode_atirar = false

	var bala = bala_cena.instantiate()

	get_tree().root.add_child(bala)

	bala.global_position = arma.global_position

	# direção do BODY que realmente gira
	bala.direcao = $body.global_transform.basis.z.normalized()

	if has_node("AUDIOS/SfxArremesso"):
		$AUDIOS/SfxArremesso.play()

	await get_tree().create_timer(tempo_tiro).timeout

	pode_atirar = true


func dano():
	# invencibilidade
	if not tomar_dano:
		return
	tomar_dano = false
	if vida > 0:
		vida -= 1
		print("vida:", vida)
		if ui_atomo:
			ui_atomo.atualizar_vida(vida)
		if vida <= 0:
			if has_node("AudioManager/SFXGameOver"):
				$"AudioManager/SFXGameOver".play()
			morrer()
	# espera invencibilidade
	await get_tree().create_timer(tempo_dano).timeout
	tomar_dano = true


func receber_knockback(forca: Vector3):
	em_knockback = true
	velocity = forca
	await get_tree().create_timer(tempo_knockback).timeout
	em_knockback = false


func morrer():
	state = estado.morto
	get_tree().change_scene_to_file("res://cenas/gameover.tscn")


func iniciar_batalha():
	pass
