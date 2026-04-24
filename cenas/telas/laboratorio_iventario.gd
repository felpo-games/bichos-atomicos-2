extends Control


@onready var grid_container_2: GridContainer = $laboratorio/GridContainer2


func _ready() -> void:
	atualizar_slots()
	hide()
	eventos_global.numa_tela = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("labotario"):
		show()
		eventos_global.numa_tela = true
		
	pass



func fabricar():
	atualizar_slots()
	print(laboratorio_global.lista)
	var lista = laboratorio_global.lista
	
	if lista.count("o") >= 2 and lista.count("c") >= 1:
		laboratorio_global.bichos_desbloqueados.append("dc")
		print("dc")
		limpar_lista()
		laboratorio_global.quantidade_o -= 2
		laboratorio_global.quantidade_c -=1
		laboratorio_global.pet_dc = true
		pass
	if lista.count("o") >= 1 and lista.count("h") >= 2:
		laboratorio_global.bichos_desbloqueados.append("a")
		print("a")
		laboratorio_global.quantidade_h -= 2
		laboratorio_global.quantidade_o -=1
		laboratorio_global.pet_agua = true
		limpar_lista()
		pass
	pass

func limpar_lista(devolver := true):
	if devolver:
		for item in laboratorio_global.lista:
			match item:
				"o":
					laboratorio_global.quantidade_o += 1
				"h":
					laboratorio_global.quantidade_h += 1
				"c":
					laboratorio_global.quantidade_c += 1
	
	laboratorio_global.lista.clear()
	atualizar_slots()
	pass


func _on_sair_pressed() -> void:
	hide()
	eventos_global.numa_tela = false
	pass # Replace with function body.

func atualizar_slots():
	var lista = laboratorio_global.lista 
	var quantidade = lista.size()
	
	for i in range(3):
		var slot = grid_container_2.get_node(str(i + 1))
		
		if i < quantidade:
			slot.show()
			
			match lista[i]:
				"o":
					slot.frame = 3
				"h":
					slot.frame = 4
				"c":
					slot.frame = 1
		else:
			slot.hide()
