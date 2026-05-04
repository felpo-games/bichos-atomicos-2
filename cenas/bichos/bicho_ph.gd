extends Node3D

enum estado  {conversa, batalhando, morto}
var state = estado.conversa

enum ataque  {fogo, pocao, eletrizidade}

# fogo
signal anim_fogo
signal parar_fogo
@onready var fogo: Sprite3D = $imagem/fogo

@export var cena_fogo: PackedScene
@export var cena_aviso: PackedScene
@export var quantidade_fogo = 5
@export var raio_spawn = 5.0

# raio
@onready var eletricidade: Sprite3D = $imagem/eletrizidade




func _ready() -> void:
	await get_tree().process_frame
	ataque_de_fogo()
	pass 



func _process(delta: float) -> void:
	match state:
		estado.conversa:
			
			pass
		estado.batalhando:
			
			pass
		estado.morto:
			
			pass
	pass


func ataque_():
	
	pass




func ataque_de_fogo():
	emit_signal("anim_fogo")
	$pivod/AnimationPlayer.play("attack2_PH")
	$imagem/fogo.visible = true
	spawnar_fogo()
	
	pass


func estado_eletrico():
	$efeitos/raio/GPUParticles3D.emitting = true
	$pivod/AnimationPlayer.play("attack2_PH")
	
	pass

func estado_normal():
	
	pass


func spawnar_fogo():
	if cena_fogo == null:
		print("ERRO: cena_fogo não definida!")
		return

	for i in range(quantidade_fogo):
		var pos = pegar_posicao_aleatoria()
		
		var aviso = mostrar_aviso(pos)

		await aviso.aviso_finalizado

		var fogo_instance = cena_fogo.instantiate()
		fogo_instance.global_position = pos
		get_tree().current_scene.add_child(fogo_instance)

		await get_tree().create_timer(0.3).timeout

func pegar_posicao_aleatoria():
	var offset = Vector3(
		randf_range(-raio_spawn, raio_spawn),
		0,
		randf_range(-raio_spawn, raio_spawn)
	)

	var origem = global_position + offset + Vector3(0, 10, 0)
	var destino = origem + Vector3(0, -20, 0)

	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origem, destino)

	var result = space.intersect_ray(query)

	if result:
		return result.position + Vector3(0, 0.2, 0)
	else:
		return global_position + offset

func mostrar_aviso(pos):
	if cena_aviso == null:
		return null
		
	var aviso = cena_aviso.instantiate()
	aviso.global_position = pos + Vector3(0, 0, 0)
	get_tree().current_scene.add_child(aviso)
	
	return aviso
