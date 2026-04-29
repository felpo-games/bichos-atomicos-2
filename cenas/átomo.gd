extends Control

@onready var eletron1: Path2D = $eletron1
@onready var eletron2: Path2D = $eletron2
@onready var eletron3: Path2D = $eletron3

func atualizar_vida(vida: int):
	if vida == 2:
		eletron1.hide()
	elif vida == 1:
		eletron2.hide()
	elif vida <= 0:
		eletron3.hide()
