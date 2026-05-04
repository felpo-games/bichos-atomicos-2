extends CharacterBody3D

@export var ui_atomo: Control
var vida = 3

enum estado {normal, batalhando, morto}
var state = estado.normal

# MOVIMENTO
var SPEED = 5.0
@export var rotation_speed = 10.0

@export var bala_cena:PackedScene
@onready var arma: Marker3D = $body/Marker3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# DASH
var is_dashing := false
var dash_timer := 0.5

@export var dash_speed := 100
var dash_speed_normal := 100
@export var dash_duration := 0.15

var dash_em_cooldown := false
@export var dash_cooldown := 1.0

# ✅ KNOCKBACK
var em_knockback := false
@export var tempo_knockback := 0.3
func _ready() -> void:
	eventos_global.batalha = false
	
	pass
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("troca_de_pet"):
		laboratorio_global.pet_1 = !laboratorio_global.pet_1
		print(laboratorio_global.pet_1)
	
	# tiro
	if Input.is_action_just_pressed("campirar") and eventos_global.batalha == true:
		atirar()
	
	# dash
	if Input.is_action_just_pressed("dash"): 
		pass

	if eventos_global.numa_tela == false:
		
		# GRAVIDADE
		if not is_on_floor() and not is_dashing:
			velocity.y -= gravity * delta

		# 🚨 AQUI ESTÁ A CORREÇÃO
		if not em_knockback:
			
			var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
			var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

			if is_dashing:
				dash_timer -= delta
				if dash_timer <= 0:
					is_dashing = false
			else:
				if direction:
					velocity.x = direction.x * SPEED
					velocity.z = direction.z * SPEED
					$body/pivod/AnimationPlayer.play("walk_Pl")
					var target_angle = atan2(direction.x, direction.z)
					$body.rotation.y = lerp_angle($body.rotation.y, target_angle, rotation_speed * delta)
				else:
					$body/pivod/AnimationPlayer.stop()
					velocity.x = move_toward(velocity.x, 0, SPEED)
					velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()


func start_dash():
	if is_dashing or dash_em_cooldown or em_knockback:
		return
	
	is_dashing = true
	dash_em_cooldown = true
	dash_timer = dash_duration
	
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var dash_dir : Vector3
	
	if input_dir.length() > 0:
		dash_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
	else:
		dash_dir = -$body.global_transform.basis.z 

	velocity = dash_dir * dash_speed
	
	await get_tree().create_timer(dash_cooldown).timeout
	dash_em_cooldown = false


func receber_knockback(forca: Vector3):
	em_knockback = true
	
	# cancela dash se estiver acontecendo
	is_dashing = false
	
	velocity = forca
	
	await get_tree().create_timer(tempo_knockback).timeout
	em_knockback = false


func atirar():
	var bala = bala_cena.instantiate()
	get_tree().root.add_child(bala)
	bala.global_position = arma.global_position
	bala.global_rotation = arma.global_rotation


func dano():
	
	if vida > 0:
		vida -= 1
		if ui_atomo:
			ui_atomo.atualizar_vida(vida)
		if vida <= 0:
			morrer()
	pass

func morrer():
	get_tree().change_scene_to_file("res://cenas/gameover.tscn")
	pass # Replace with function body.
