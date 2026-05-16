extends Node3D

@export_multiline var falas_o: Array[String]
@export var voz_o: AudioStream
var conversando: bool = false

var player: Node3D = null
@export var icon: Texture2D

# respawn
@export var reaparecer = true
@export var tempo_renascer = 5.0

var posicao_inicial: Vector3

func _ready() -> void:
	posicao_inicial = global_position
	show()

func _process(_delta: float) -> void:
	if player != null and not conversando and Input.is_action_just_pressed("interacao"):
		$INTERACAO_E.animar(false)
		iniciar_conversa()

func iniciar_conversa():
	conversando = true
	player.em_dialogo = true 
	$"../../UI/telas/TelaDeDiálogo".iniciar_dialogo(falas_o, voz_o)
	await $"../../UI/telas/TelaDeDiálogo".dialogo_encerrado
	
	encerrar_conversa()
	coletado()

func encerrar_conversa():
	conversando = false
	if player != null:
		player.em_dialogo = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		if has_node("INTERACAO_E"):
			$INTERACAO_E.animar(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
		if has_node("INTERACAO_E"):
			$INTERACAO_E.animar(false)
		if conversando:
			encerrar_conversa()
			$"../../UI/telas/TelaDeDiálogo".cancelar_dialogo()

func coletado():
	laboratorio_global.adicionar_atomo("o")
	
	var notif = $"../../UI/telas/notificacao"
	if notif != null:
		notif.mostrar_notificacao("Oxigênio", icon)
	
	desativar()
	
	if reaparecer:
		respawn()

func desativar():
	hide()
	if has_node("Area3D/CollisionShape3D"):
		$Area3D/CollisionShape3D.disabled = true
	set_process(false)

func reativar():
	show()
	if has_node("Area3D/CollisionShape3D"):
		$Area3D/CollisionShape3D.disabled = false
	player = null
	conversando = false
	global_position = posicao_inicial
	set_process(true)

func respawn():
	await get_tree().create_timer(tempo_renascer).timeout
	reativar()
