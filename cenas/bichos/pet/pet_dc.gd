extends Node3D

var liberado = false
var pet_um = false
@export var bala_cena: PackedScene
@onready var arma: Marker3D = $Marker3D

func _ready() -> void:
	liberado = false
	hide()
	pass


func _process(_delta: float) -> void:
	if laboratorio_global.pet_1 == true and liberado == true:
		pet_um = true
		show()
	else:
		pet_um = false
		hide()
	if laboratorio_global.pet_dc == true:
		liberado = true
		
		
	pass
	if Input.is_action_just_pressed("ataque_pet") and liberado == true and pet_um == true and eventos_global.batalha == true:
		atirar()
		pass

func atirar():
	if has_node("sfx_ataque"):
		$sfx_ataque.play()
	var bala = bala_cena.instantiate()
	
	# 1. Adiciona o nó na cena antes de aplicar as transformações globais
	get_tree().root.add_child(bala)
	
	# 2. Define a posição e rotação iniciais baseadas no Marker3D
	bala.global_position = arma.global_position
	bala.global_rotation = arma.global_rotation
	
	# 3. CORREÇÃO CRUCIAL: Passa a direção correta para a bala se mover no plano horizontal
	var direcao_tiro = -arma.global_transform.basis.z.normalized()
	direcao_tiro.y = 0 # Garante que o impulso inicial horizontal seja reto
	
	bala.direcao = direcao_tiro
