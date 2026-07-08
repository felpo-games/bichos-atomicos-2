extends Area3D

@export_multiline var texto_tutorial : String = "coisas"

@onready var tela_canvas = $CanvasLayer
@onready var texto_label = $CanvasLayer/RichTextLabel

func _ready():
	texto_label.text = texto_tutorial
	tela_canvas.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		tela_canvas.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		tela_canvas.hide()
