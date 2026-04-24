extends CharacterBody3D


enum estado {normal, batalhando, morto}
var state = estado.normal

# Variáveis de movimentação
var SPEED = 5.0
@export var rotation_speed = 10.0

@export var bala_cena:PackedScene
@onready var arma: Marker3D = $body/Marker3D

# Pegamos o valor da gravidade padrão do projeto uma única vez
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#dash
var is_dashing := false
var dash_timer := 0.5

@export var dash_speed := 100
var dash_speed_normal := 100
@export var dash_duration := 0.15

var last_direction := Vector2.RIGHT

var dash_em_cooldown := false
@export var dash_cooldown := 1.0 # tempo pra poder usar de novo

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("troca_de_pet"):
		laboratorio_global.pet_1 = !laboratorio_global.pet_1
		print(laboratorio_global.pet_1)
		pass
	# Sistema de tiro
	if Input.is_action_just_pressed("campirar") and eventos_global.batalha == true:
		atirar()
	
	# Sistema de Dash (usando uma tecla dedicada, ex: "dash" ou "shift")
	if Input.is_action_just_pressed("dash"): 
		start_dash()

	if eventos_global.numa_tela == false:
		
		# 1. GRAVIDADE (só aplica se NÃO estiver no dash)
		if not is_on_floor() and not is_dashing:
			velocity.y -= gravity * delta

		# 2. INPUT
		var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
		var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

		# 3. LÓGICA DE MOVIMENTO VS DASH
		if is_dashing:
			# Durante o dash, a velocidade é controlada pelo temporizador
			dash_timer -= delta
			if dash_timer <= 0:
				is_dashing = false
		else:
			# Movimentação normal
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				
				# ROTAÇÃO SUAVE DO BODY
				var target_angle = atan2(direction.x, direction.z)
				$body.rotation.y = lerp_angle($body.rotation.y, target_angle, rotation_speed * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)

		# 4. EXECUTAR MOVIMENTO
		move_and_slide()

func start_dash():
	if is_dashing or dash_em_cooldown:
		return
	
	is_dashing = true
	dash_em_cooldown = true
	dash_timer = dash_duration
	
	# Calcula a direção do dash: 
	# Se estiver se movendo, dash na direção do movimento. 
	# Se estiver parado, dash para onde o $body está virado.
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var dash_dir : Vector3
	
	if input_dir.length() > 0:
		dash_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
	else:
		# Pega a direção "frente" baseada na rotação do seu modelo
		dash_dir = -$body.global_transform.basis.z 

	# Aplica a velocidade de dash (Vector3)
	velocity = dash_dir * dash_speed
	
	# Timer para liberar o próximo dash
	await get_tree().create_timer(dash_cooldown).timeout
	dash_em_cooldown = false

func atirar():
	# 1. Cria uma instância da bala
	var bala = bala_cena.instantiate()
	get_tree().root.add_child(bala)
	bala.global_position = arma.global_position
	bala.global_rotation = arma.global_rotation
	
