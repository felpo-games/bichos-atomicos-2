extends Area3D



@export var velocidade := 45.0 # Diminuí um pouco para o arco ficar mais visível
@export var gravidade := 20.0 
@export var forca_pulo_inicial := 7.0 # Força que joga o projétil para cima

var direcao: Vector3 = Vector3.FORWARD # Direção padrão caso não seja definida
var velocidade_vertical := 0.0

func _ready() -> void:
	# Define a velocidade vertical inicial para criar o arco (parábola)
	velocidade_vertical = forca_pulo_inicial
	
	# Destrói depois de 3 segundos para não pesar o jogo
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# 1. Movimento horizontal (Mantém a direção X e Z que o jogador enviou)
	var movimento_horizontal = direcao.normalized() * velocidade * delta
	global_position.x += movimento_horizontal.x
	global_position.z += movimento_horizontal.z
	
	# 2. Aplica a gravidade diminuindo a velocidade vertical
	velocidade_vertical -= gravidade * delta
	
	# 3. Aplica o movimento vertical no eixo Y
	global_position.y += velocidade_vertical * delta


func _on_body_entered(body: Node3D) -> void:
	if !body.is_in_group("player"):
		destruir_com_som()


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("bicho"):
		destruir_com_som()


func destruir_com_som() -> void:

	$frasco.hide()

	$CollisionShape3D.set_deferred("disabled", true)

	$SfxImpacto.play()

	await $SfxImpacto.finished

	queue_free()

func caindo():
	global_position.y -= 1
