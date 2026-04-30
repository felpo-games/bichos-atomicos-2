extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var queméessebicho:Array = ["o","h","c"]
enum estado  {conversa, batalhando, morto}
var state = estado.conversa

#esta variavel servira para o bicho tetectar se tem alguem para conversar e ou batalharr.
var player 

# variaveis para conversar
var conversar:bool = true
var conversando:bool = false

signal conversa

# variaveis para batalha
var vida = 4
var morto = false
var grande = false
@export var speed: float = 5.0

func _physics_process(delta):
	# gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	move_and_slide()
	
	match state:
		estado.conversa:
			if Input.is_action_just_pressed("interacao") and player != null:
				emit_signal("conversa")
				print("conversa")
			pass
		estado.batalhando:
			andar()
			crecer()
			pass
		estado.morto:
			eventos_global.batalha = false
			derrotado()
			pass
	pass

func derrotado():
	var icon = load("res://arte/vlad/WhatsApp Image 2026-04-28 at 16.12.42 (1).jpeg")
	$"../../ui_dialogos/telas/notificacao".mostrar_notificacao("carbono", icon )
	state = estado.morto
	laboratorio_global.bichos_desbloqueados.append(queméessebicho[0])
	laboratorio_global.quantidade_c += 1
	morto = true
	queue_free()

func andar():
	if player == null:
		return
	
	var direcao = (player.global_transform.origin - global_transform.origin).normalized()
	
	velocity.x = direcao.x * speed
	velocity.z = direcao.z * speed
	
	move_and_slide()
	look_at(player.global_transform.origin, Vector3.UP)
	var distancia = global_transform.origin.distance_to(player.global_transform.origin)
	if distancia > 2.0:
		velocity.x = direcao.x * speed
		velocity.z = direcao.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	pass

func crecer():
	if grande == false:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3.ONE * 2.0, 1.5)
		grande = true
		pass

func _on_area_conversa_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("oi")
		player = body
		pass
	pass # Replace with function body.

func _on_area_conversa_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
		pass
	pass # Replace with function body.

#quando o player erra a resposta ele entra em batalha
func _on_conversas_cena_batalhar() -> void:
	state = estado.batalhando
	pass # Replace with function body.
#se o player acerta ele so some
func _on_conversas_cena_acertou() -> void:
	state = estado.morto
	pass # Replace with function body.
