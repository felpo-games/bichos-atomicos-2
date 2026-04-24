extends Node3D

var liberado = false
var pet_um = false
@export var bala_cena: PackedScene
@onready var arma: Marker3D = $Marker3D

func _ready() -> void:
	liberado = false
	hide()
	pass


func _process(delta: float) -> void:
	if laboratorio_global.pet_1 == false and liberado == true:
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
	var bala = bala_cena.instantiate()
	get_tree().root.add_child(bala)
	bala.global_position = arma.global_position
	bala.global_rotation = arma.global_rotation
	pass
