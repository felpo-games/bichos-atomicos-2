extends CharacterBody3D

@export var queméessebicho:Array = ["o","h","c"]
enum estado  {conversa, batalhando, morto}
var state = estado.conversa

@export_range(1, 10) var chance_acerto: int = 8
@export var SPEED = 5.0
@export var forca_knockback = 15.0 
@export var tempo_de_espera = 1

var player: CharacterBody3D = null
var direcao_alvo := Vector3.ZERO
var pode_mover = true

var PontosVida = 3

func _physics_process(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player and pode_mover:
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
		if randi() % 2 == 0: desvio *= -1
		direcao_alvo = direcao_real.rotated(Vector3.UP, desvio)
	
	await get_tree().create_timer(tempo_de_espera).timeout
	pode_mover = true




func _on_area_visaoverde_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		eventos_global.batalha = true
		pass
	pass 


func _on_area_visaoverde_body_exited(body: Node3D) -> void:
	if body == player:
		eventos_global.batalha = false
		player = null
		direcao_alvo = Vector3.ZERO
	pass


func _on_area_de_knockpack_e_dano_laranja_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var sorteio = randi_range(-3, 3)
		if body.has_method("receber_dano"):
			body.receber_dano(1)
		var direcao_kb = (body.global_position - global_position).normalized()
		direcao_kb.x = sorteio
		if "velocity" in body:
			body.velocity = direcao_kb * forca_knockback
	pass


func _on_area_receber_danovermelha_area_entered(area: Area3D) -> void:
	if area.is_in_group("ataque_player"):
		PontosVida -= 1
		if PontosVida <= 0:
			
			state = estado.morto
			laboratorio_global.bichos_desbloqueados.append(queméessebicho[0])
			laboratorio_global.quantidade_h += 1
			queue_free()
		pass
	pass # Replace with function body.
