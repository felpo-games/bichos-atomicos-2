extends Node3D

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
@onready var arma: Marker3D = $ataque/Marker3D
@export var projetil_cena: PackedScene
var pode_atirar = false
var em_batalha = false
@export var distancia_de_combate: float = 5.0
@export var culton_ataque: float = 5.0
@export_range(1, 10) var chance_acerto: int = 6

# variaveis de vida
@export var pontos_de_vida: int = 10
var morto = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	player = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		estado.conversa:
			if Input.is_action_just_pressed("interacao") and player != null:
				emit_signal("conversa")
			pass
		estado.batalhando:
			if player != null:
				
				var posicao_alvo_corpo = Vector3(player.global_position.x, global_position.y, player.global_position.z)
				look_at(posicao_alvo_corpo, Vector3.UP)
				arma.look_at(player.global_position, Vector3.UP)
			if pode_atirar and player:
				atirar()
				pass
			pass
		estado.morto:
			
			pass
	pass

#quando o player entrar no colicionshape medio podera coversar com o player
#tambem fica armazenado o alvo do bicho
func _on_area_interação_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
	pass # Replace with function body.


func _on_area_interação_body_exited(body: Node3D) -> void:
	pass # Replace with function body.


func _on_area_saida_body_entered(body: Node3D) -> void:
	pass # Replace with function body.

#quando o player sair do colisionshape grande vai deixar null para que a batalha pare.
#tambem fica armazenado o alvo do bicho, no caso a falta de alvo.
func _on_area_saida_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
		state = estado.conversa
	
	pass # Replace with function body.

# quando os dispartos do player chegar no bicho
func _on_area_receber_dano_area_entered(area: Area3D) -> void:
	if area.is_in_group("ataque_player"):
		pontos_de_vida -= 1
		if pontos_de_vida <= 0:
			morto = true
			derrotado()
		pass
	pass # Replace with function body.

func derrotado():
	state = estado.morto
	laboratorio_global.bichos_desbloqueados.append(queméessebicho[0])
	morto = true
	queue_free()

func preparar_batalha():
	em_batalha = true
	state = estado.batalhando
	if player != null:
		var direcao = (player.global_position - global_position).normalized()
		
		var nova_posicao = global_position + (direcao * distancia_de_combate)
		nova_posicao.y = player.global_position.y 
		
		player.global_position = nova_posicao
	
	await get_tree().create_timer(2.5).timeout
	pode_atirar = true
	pass


func atirar():
	pode_atirar = false
	
	# 1. Sorteia o número da sorte
	var sorteio = randi_range(1, 10)
	
	# 2. Instancia o projétil
	var tiro = projetil_cena.instantiate()
	get_tree().root.add_child(tiro)
	tiro.global_transform = arma.global_transform
	
	# 3. Lógica baseada na variável exportada
	# Se o sorteio for MAIOR que a chance de acerto, ele erra.
	if sorteio > chance_acerto:
		# ERROU: Calcula um desvio aleatório
		var desvio_graus = randf_range(15.0, 35.0)
		if randi() % 2 == 0: desvio_graus *= -1
		
		tiro.rotate_y(deg_to_rad(desvio_graus))
		print("Inimigo ERROU (Sorteio: ", sorteio, " / Necessário: ", chance_acerto, ")")
	else:
		# ACERTOU
		print("Inimigo ACERTOU (Sorteio: ", sorteio, " / Necessário: ", chance_acerto, ")")

	# 4. Cooldown
	await get_tree().create_timer(culton_ataque).timeout
	pode_atirar = true
func _on_conversas_cena_batalhar() -> void:
	preparar_batalha()
	pass # Replace with function body.
