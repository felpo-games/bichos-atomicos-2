extends Button

@export var elemento:Array 
var elemento_trasmição 
enum elementos {o,h,c}
var state
func _ready() -> void:
	var state = elemento[0]
	print(elemento_trasmição)
	modulate = Color(0.0, 0.0, 0.0, 1.0)
	elemento_trasmição = elemento[0]
	pass 

func _process(delta: float) -> void:
	
	atualizar_cor()
	pass


func atualizar_cor():
	if elemento_trasmição in laboratorio_global.bichos_desbloqueados:
		modulate = Color(123.689, 123.689, 123.689, 1.0)
		
		pass
	pass


func _on_pressed() -> void:
	if elemento_trasmição in laboratorio_global.bichos_desbloqueados:
		
		match elemento_trasmição:
			"o":
				if laboratorio_global.quantidade_o > 0:
					laboratorio_global.quantidade_o -= 1
					adicionar_elemento()
				else:
					print("Sem oxigênio!")
			
			"h":
				if laboratorio_global.quantidade_h > 0:
					laboratorio_global.quantidade_h -= 1
					adicionar_elemento()
				else:
					print("Sem hidrogênio!")
			
			"c":
				if laboratorio_global.quantidade_c > 0:
					laboratorio_global.quantidade_c -= 1
					adicionar_elemento()
				else:
					print("Sem carbono!")

func adicionar_elemento():
	laboratorio_global.lista.append(elemento_trasmição)
	
	if laboratorio_global.lista.size() >= 4:
		laboratorio_global.lista.clear()
	
	$"../../..".fabricar()
