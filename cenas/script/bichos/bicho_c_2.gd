extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var queméessebicho:Array = ["o","h","c"]

enum estado  {conversa, batalhando, morto}
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

# variáveis de knockback
@export var forca_knockback = 15.0
@export var forca_vertical = 5.0
var pode_bater = true
@export var tempo_knockback = 1.0

func _ready() -> void:
	$AnimationPlayer.play("inicio")
func _physics_process(delta):
	# gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	match state:
		estado.conversa:
			if Input.is_action_just_pressed("interacao") and player != null:
				emit_signal("conversa")
				print("conversa")
		
		estado.batalhando:
			andar()
			$AnimationPlayer.play("new_animation")
			
		estado.morto:
			eventos_global.batalha = false
			derrotado()
	
	move_and_slide()

var icon: Texture2D

func derrotado():
	icon = load("res://arte/vlad/satanas atomico/satanas atomico/o2.png")
	$"../../ui_dialogos/telas/notificacao".mostrar_notificacao("carbono", icon )
	state = estado.morto
	laboratorio_global.bichos_desbloqueados.append(queméessebicho[0])
	laboratorio_global.quantidade_c += 1
	morto = true
	queue_free()


func andar():
	$crecimento/pivod/AnimationPlayer.play("attack_C")
	if player == null:
		return
	
	var direcao = player.global_transform.origin - global_transform.origin
	var distancia = direcao.length()
	direcao = direcao.normalized()
	
	# movimento
	if distancia > 2.0:
		velocity.x = direcao.x * speed
		velocity.z = direcao.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	# olhar para o player sem inclinar
	var alvo = player.global_transform.origin
	alvo.y = global_transform.origin.y
	look_at(alvo, Vector3.UP)


func crecer():
	if not grande:
		eventos_global.batalha = true
		grande = true
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3.ONE * 2.0, 1.5)


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
		print("oi")
		player = body


func _on_area_conversa_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and state == estado.conversa:
		player = null


# quando o player erra a resposta
func _on_conversas_cena_batalhar() -> void:
	state = estado.batalhando
	crecer()


# quando o player acerta
func _on_conversas_cena_acertou() -> void:
	state = estado.morto


func _on_areade_dano_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and state == estado.batalhando:
		aplicar_knockback(body)
	pass # Replace with function body.


func _on_areade_dano_area_entered(area: Area3D) -> void:
	if area.is_in_group("ataque_player"):
		vida -= 1
		if vida <= 0:
			state = estado.morto
		pass
	pass # Replace with function body.
