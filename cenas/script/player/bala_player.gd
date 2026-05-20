extends Area3D

@export var velocidade := 40.0
@export var dano := 1
@export var gravidade := 20.0 # Força da gravidade que puxa para baixo

var direcao: Vector3 = Vector3.ZERO
var velocidade_vertical := 0.0 # Controla a subida e a descida

func _ready() -> void:
	# Define uma velocidade vertical inicial para fazê-la começar subindo
	# Ajuste esse valor (ex: 10.0) para controlar a altura do arco
	velocidade_vertical = 12.0 
	
	# destrói depois de 2 segundos
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# 1. Movimento horizontal (X e Z) baseado na direção desejada
	var movimento_horizontal = direcao.normalized() * velocidade * delta
	global_position.x += movimento_horizontal.x
	global_position.z += movimento_horizontal.z
	
	# 2. Aplica a gravidade na velocidade vertical ao longo do tempo
	velocidade_vertical -= gravidade * delta
	
	# 3. Aplica a velocidade vertical na posição Y do projétil
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
