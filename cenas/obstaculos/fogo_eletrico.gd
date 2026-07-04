extends Node3D

var vida = 2
var destruido = false
var emchamas = false
var acabou = false

@export var textura_eletrica: Texture2D # elétrica
@export var textura_fogo: Texture2D # fogo

@onready var particulas = $GPUParticles

func _ready() -> void:
	show()
	modo_eletrico()

func _process(_delta: float) -> void:
	if destruido and !acabou:
		particulas.emitting = false
		acabou = true
		eventos_global.batalha = false

func _on_area_3d_area_entered(area: Area3D) -> void:

	if area.is_in_group("ataque_player") and !emchamas:
		vida -= 1
		emchamas = true
		modo_fogo()

	if area.is_in_group("ataque_agua") and emchamas:
		vida -= 1
		destruido = true

func modo_eletrico():
	var mat = $GPUParticles.material_override
	mat.albedo_texture = textura_eletrica

func modo_fogo():
	var mat = $GPUParticles.material_override
	mat.albedo_texture = textura_fogo
