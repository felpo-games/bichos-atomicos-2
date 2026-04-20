extends CharacterBody3D

enum estado {normal, batalhando, morto}
var state = estado.normal

# Variáveis de movimentação
var SPEED = 5.0
@export var rotation_speed = 10.0

# Pegamos o valor da gravidade padrão do projeto uma única vez
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# Verifique se 'eventos_global' existe e se o nome da variável está correto
	if eventos_global.numa_tela == false:
		
		# 1. GRAVIDADE (Forma manual e segura)
		if not is_on_floor():
			velocity.y -= gravity * delta

		# 2. INPUT
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		# IMPORTANTE: Use Vector3 direto para movimento global, 
		# ou o player vai se comportar estranho ao girar.
		var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			# 3. ROTAÇÃO SUAVE DO BODY
			var target_angle = atan2(direction.x, direction.z)
			$body.rotation.y = lerp_angle($body.rotation.y, target_angle, rotation_speed * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		# 4. EXECUTAR MOVIMENTO
		move_and_slide()
