extends Node
signal atomo_atualizado(tipo, quantidade)
var bichos_desbloqueados :Array

var lista:Array

var quantidade_o:int
var quantidade_c:int
var quantidade_h:int

var pet_agua = false
var pet_dc = false
var pet_1 = false

func adicionar_atomo(tipo: String):
	if tipo == "h":
		quantidade_h += 1
		atomo_atualizado.emit("h", quantidade_h)
	elif tipo == "o":
		quantidade_o += 1
		atomo_atualizado.emit("o", quantidade_o)
	elif tipo == "c":
		quantidade_c += 1
		atomo_atualizado.emit("c", quantidade_c)
