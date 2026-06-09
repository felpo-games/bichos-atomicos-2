extends Node3D



var vida = 2
var destruido = false
var emchamas = false
@export var particula1: Material
@export var particula2: Material
var acabou = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GPUParticles3D.emitting = true
	$GPUParticles3D.material_override = particula1
	emchamas = false
	show()
	var acabou = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if destruido == true and !acabou:
		hide()
		acabou = true
		eventos_global.batalha = false
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("oi")
	if area.is_in_group("ataque_player") and emchamas == false:
		print("oiis")
		vida -= 1
		emchamas = true
		$GPUParticles3D.material_override = particula2
	if area.is_in_group("ataque_agua") and emchamas == true:
		vida -= 1
		destruido = true
		
	pass # Replace with function body.
