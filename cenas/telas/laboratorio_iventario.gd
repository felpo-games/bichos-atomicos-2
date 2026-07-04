extends Control

#SFX UI
@onready var sfx_clique = $Sons_UI/sfx_clique
@onready var sfx_erro = $Sons_UI/sfx_erro
@onready var sfx_sintese = $Sons_UI/sfx_sintese
@onready var sfx_hover = $Sons_UI/sfx_hover


#QUANTIDADE DE ELEMENTOS QUE FORAM PEGOS
@onready var qnt_o = $TELA_ATOMOS/qnt_O
@onready var qnt_c = $TELA_ATOMOS/qnt_C
@onready var qnt_h = $TELA_ATOMOS/qnt_H


@onready var o: = $TELA_ATOMOS/O
@onready var h: = $TELA_ATOMOS/H
@onready var c: = $TELA_ATOMOS/C


#VAO HAVER INFORMAÇÕES DE CADA UM DELES
@export_group("Fichas de Dados")
@export var dados_h: InfoElemento
@export var dados_o: InfoElemento
@export var dados_c: InfoElemento
@onready var botao_h = $TELA_SINTESE/botao_h
@onready var botao_c = $TELA_SINTESE/botao_c
@onready var botao_o = $TELA_SINTESE/botao_o
@export var dados_agua: InfoElemento
@export var dados_co2: InfoElemento
@onready var botao_infos_h = $TELA_ATOMOS/botao_infos_h
@onready var botao_infos_c = $TELA_ATOMOS/botao_infos_c
@onready var botao_infos_o = $TELA_ATOMOS/botao_infos_o


#JANELA POPUP

@onready var janela_informacao: TextureRect = $janela_informacao
@onready var texto: RichTextLabel = $janela_informacao/texto
@onready var titulo: Label = $JanelaInformacao/Titulo
@onready var bichos: TextureRect = $JanelaInformacao/Bichos
@onready var botao_sair = $JanelaInformacao/Botao_sair

@onready var img_agua_colecao = $TELA_COMPOSTOS/agua
@onready var img_co2_colecao = $TELA_COMPOSTOS/Co2

@onready var butao_co_2 = $TELA_COMPOSTOS/butao_co2
@onready var butao_h_2o = $TELA_COMPOSTOS/butao_h2o
@onready var label_co_2: Label = $TELA_COMPOSTOS/Label_CO2
@onready var label_h_2o: Label = $TELA_COMPOSTOS/Label_H2O


@onready var tela_atomos = $TELA_ATOMOS
@onready var tela_sintese = $TELA_SINTESE
@onready var tela_compostos = $TELA_COMPOSTOS


@onready var botao_composto = $botao_composto
@onready var composto_animado = $TELA_SINTESE/Composto_animado
@onready var fundo_animado = $TELA_SINTESE/Fundo_animado
@export var imagem_brilho: Texture2D

var mistura_atual = []
@export var imagem_vazia: Texture2D
@export var imagem_o: Texture2D
@export var imagem_h: Texture2D
@export var imagem_c: Texture2D
@export var icone_agua: Texture2D
@export var icone_dioxido: Texture2D

@onready var slots = [$TELA_SINTESE/EspacoSintese/Icone, $TELA_SINTESE/EspacoSintese2/Icone, $"TELA_SINTESE/EspaçoSintese3/Icone"] 

@onready var botao_atomos: Button = $botao_atomos
@onready var botao_sintese: Button = $botao_sintese


# trocas de aba pelo controle
var aba_atual := 0
func _ready() -> void:
	var todos_botoes = [
		botao_infos_o,
		botao_infos_h,
		botao_infos_c,
		botao_o,
		botao_h,
		botao_c,
		butao_h_2o,
		butao_co_2,
		botao_atomos,
		botao_sintese,
		botao_composto
	]

	for botao in todos_botoes:
		botao.focus_entered.connect(_on_focus_entered.bind(botao))
		botao.focus_exited.connect(_on_focus_exited.bind(botao))
		aba_atual = 0
		trocar_aba(tela_atomos)
		atualizar_colecao()
		limpar_bancada()
		laboratorio_global.atomo_atualizado.connect(_on_atomo_atualizado)
		atualizar_icones_inventario()
	
	var botoes_info = {
		butao_h_2o: "agua",
		butao_co_2: "co2",
		botao_infos_h: "h",
		botao_infos_o: "o",
		botao_infos_c: "c"
	}
	
	for botao in botoes_info.keys():
		if botao != null:
			var id_bicho = botoes_info[botao]
			botao.mouse_entered.connect(_animar_brilho_botao.bind(botao, id_bicho, true))
			botao.mouse_exited.connect(_animar_brilho_botao.bind(botao, id_bicho, false))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("laboratorio") and visible:
		hide()
		get_tree().paused = false
		get_viewport().set_input_as_handled()
	if visible:
		if Input.is_action_just_pressed("aba_esquerda"):
			mudar_aba(-1)
		if Input.is_action_just_pressed("aba_direita"):
			mudar_aba(1)
	if Input.is_action_just_pressed("laboratorio") and visible:
		hide()
		get_tree().paused = false
		get_viewport().set_input_as_handled()

func _on_atomo_atualizado(tipo: String, _quantidade: int):
	match tipo:
		"h":
			h.show()
		"o":
			o.show()

func atualizar_icones_inventario() -> void:
	qnt_h.text = str(laboratorio_global.quantidade_h)
	qnt_o.text = str(laboratorio_global.quantidade_o)
	qnt_c.text = str(laboratorio_global.quantidade_c)
	
	# 1. Os ícones da bancada somem se não tiver quantidade
	if laboratorio_global.quantidade_h > 0: h.show()
	else: h.hide()
		
	if laboratorio_global.quantidade_o > 0: o.show()
	else: o.hide()
		
	if laboratorio_global.quantidade_c > 0: c.show()
	else: c.hide()

	# 2. Os botões de informação do Códice ficam SEMPRE liberados e visíveis
	botao_infos_h.disabled = false
	botao_infos_h.modulate = Color(1, 1, 1)
	
	botao_infos_o.disabled = false
	botao_infos_o.modulate = Color(1, 1, 1)
	
	botao_infos_c.disabled = false
	botao_infos_c.modulate = Color(1, 1, 1)

func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return
	var jogador = get_tree().get_nodes_in_group("player")
	if visible:
		atualizar_icones_inventario()
		if jogador.size() > 0 and jogador[0].ui_atomo != null:
			jogador[0].ui_atomo.visible = false
	else:
		if jogador.size() > 0 and jogador[0].ui_atomo != null:
			jogador[0].ui_atomo.visible = true

func trocar_aba(aba_ativa: Control) -> void:
	tela_atomos.hide()
	tela_sintese.hide()
	tela_compostos.hide()
	aba_ativa.show()
	if aba_ativa == tela_compostos:
		atualizar_colecao()
	
	await get_tree().process_frame
	focar_aba_atual()

func verificar_acesso_compostos():
	if botao_composto.disabled == true: 
			botao_composto.disabled = false
			var tw = create_tween()
			tw.tween_property(botao_composto, "modulate", Color.GREEN, 0.5)
			tw.tween_property(botao_composto, "modulate", Color.WHITE, 0.2)

func atualizar_colecao():
# ÁGUA
	if laboratorio_global.bichos_desbloqueados.has("a"):
		butao_h_2o.modulate = Color(1, 1, 1) 
		butao_h_2o.disabled = false
		label_h_2o.show()
	else:
		butao_h_2o.modulate = Color(1.0, 1.0, 1.0, 0.271)
		butao_h_2o.disabled = true
		label_h_2o.hide()

	# CO2
	if laboratorio_global.bichos_desbloqueados.has("dc"):
		butao_co_2.modulate = Color(1, 1, 1) 
		butao_co_2.disabled = false
		label_co_2.show()
	else:
		butao_co_2.modulate = Color(1.0, 1.0, 1.0, 0.271) 
		butao_co_2.disabled = true
		label_co_2.hide()

func _on_botao_o_pressed() -> void:
	adicionar_ao_frasco("o")

func _on_botao_h_pressed() -> void:
	adicionar_ao_frasco("h")

func _on_botao_c_pressed() -> void:
	adicionar_ao_frasco("c")

func adicionar_ao_frasco(elemento: String) -> void:
	if mistura_atual.size() >= 3:
		return
	var qtd_no_frasco = mistura_atual.count(elemento)
	var saldo_real = 0
	var botao_referencia: TextureButton
	match elemento:
		"h":
			saldo_real = laboratorio_global.quantidade_h
			botao_referencia = botao_h
		"o":
			saldo_real = laboratorio_global.quantidade_o
			botao_referencia = botao_o
		"c":
			saldo_real = laboratorio_global.quantidade_c
			botao_referencia = botao_c
	if qtd_no_frasco < saldo_real:
		mistura_atual.append(elemento)
		atualizar_slots()
		if mistura_atual.size() == 3:
			verificar_receita()
	else:
		piscar_botao_erro(botao_referencia)

func piscar_botao_erro(botao: TextureButton) -> void:
	if botao == null:
		return 
	sfx_erro.play()
	var tw = create_tween().set_parallel(true)
	tw.tween_property(botao, "modulate", Color.RED, 0.1)
	tw.chain().tween_property(botao, "modulate", Color.WHITE, 0.2)

func atualizar_slots() -> void:
	for icone in slots:
		icone.hide()
	for i in range(mistura_atual.size()):
		var icone_atual = slots[i]
		icone_atual.show()
		match mistura_atual[i]:
			"o":
				icone_atual.texture = imagem_o
			"h":
				icone_atual.texture = imagem_h
			"c":
				icone_atual.texture = imagem_c

func verificar_receita() -> void:
	var qtd_o = mistura_atual.count("o")
	var qtd_h = mistura_atual.count("h")
	var qtd_c = mistura_atual.count("c")
	
	if qtd_h == 2 and qtd_o == 1:
		fabricar("agua")
	
	elif qtd_c == 1 and qtd_o == 2:
		fabricar("dioxido_carbono")
		
	else:
		sfx_erro.play()
		print("sintese errada")
		#colocar som de erro
		await get_tree().create_timer(0.5).timeout
		limpar_bancada()

func fabricar(composto: String) -> void:
	var imagem_final: Texture2D
	var nome_final: String
	
	if composto == "agua":
		laboratorio_global.bichos_desbloqueados.append("a")
		laboratorio_global.pet_agua = true
		laboratorio_global.quantidade_h -= 2
		laboratorio_global.quantidade_o -= 1
		imagem_final = icone_agua
		nome_final = "Água"
	elif composto == "dioxido_carbono":
		laboratorio_global.bichos_desbloqueados.append("dc")
		laboratorio_global.pet_dc = true
		laboratorio_global.quantidade_c -= 1
		laboratorio_global.quantidade_o -= 2
		imagem_final = icone_dioxido
		nome_final = "Dióxido de Carbono"
	sfx_sintese.play()
	atualizar_icones_inventario()
	animar_desbloqueio(imagem_final, nome_final)
	verificar_acesso_compostos()
	await get_tree().create_timer(0.5).timeout
	limpar_bancada()

func animar_desbloqueio(textura: Texture2D, nome: String):
	composto_animado.scale = Vector2.ONE
	fundo_animado.scale = Vector2.ONE
	composto_animado.modulate.a = 1.0
	fundo_animado.modulate.a = 1.0
	composto_animado.rotation_degrees = 0
	fundo_animado.rotation_degrees = 0

	var centro_tela = get_viewport_rect().size / 2
	
	composto_animado.global_position = centro_tela - (composto_animado.size / 2)
	fundo_animado.global_position = centro_tela - (fundo_animado.size / 2)

	composto_animado.scale = Vector2.ZERO
	fundo_animado.scale = Vector2.ZERO
	composto_animado.modulate.a = 0
	fundo_animado.modulate.a = 0
	
	composto_animado.texture = textura
	fundo_animado.texture = imagem_brilho
	
	composto_animado.show()
	fundo_animado.show()

	var tween = create_tween().set_parallel(true)
	var duracao_pop = 0.6
	

	tween.tween_property(composto_animado, "scale", Vector2(1.5, 1.5), duracao_pop).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(composto_animado, "modulate:a", 1.0, 0.3)
	
	tween.tween_property(fundo_animado, "scale", Vector2(2.0, 2.0), duracao_pop).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(fundo_animado, "modulate:a", 0.7, 0.4)
	tween.tween_property(fundo_animado, "rotation_degrees", 180, duracao_pop).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(1.3).timeout
	
	var tween_voo = create_tween().set_parallel(true)
	var duracao_voo = 0.8
	

	var destino = botao_composto.global_position + (botao_composto.size / 2)
	var pos_final_composto = destino - (composto_animado.size / 2)

	tween_voo.tween_property(composto_animado, "global_position", pos_final_composto, duracao_voo).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_voo.tween_property(composto_animado, "scale", Vector2.ZERO, duracao_voo)
	tween_voo.tween_property(composto_animado, "modulate:a", 0.0, duracao_voo)
	
	
	tween_voo.tween_property(fundo_animado, "scale", Vector2.ZERO, duracao_voo).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_voo.tween_property(fundo_animado, "modulate:a", 0.0, duracao_voo)
	tween_voo.tween_property(fundo_animado, "rotation_degrees", 360, duracao_voo)

	
	await tween_voo.finished
	composto_animado.hide()
	fundo_animado.hide()
	
	
	get_tree().call_group("interface_notificacao", "mostrar_notificacao", nome, textura)
	
	var tween_feedback = create_tween()
	tween_feedback.tween_property(botao_composto, "scale", Vector2(1.2, 1.2), 0.1)
	tween_feedback.tween_property(botao_composto, "scale", Vector2(1.0, 1.0), 0.1)

func limpar_bancada() -> void:
	mistura_atual.clear()
	atualizar_slots()

func _on_botao_limpar_pressed() -> void:
	limpar_bancada()
	pass 

func _on_botao_composto_pressed() -> void:
	sfx_clique.play()
	trocar_aba(tela_compostos)
	pass # Replace with function body.

func _on_botao_atomos_pressed() -> void:
	sfx_clique.play()
	trocar_aba(tela_atomos)
	pass # Replace with function body.

func _on_botao_sintese_pressed() -> void:
	sfx_clique.play()
	trocar_aba(tela_sintese)
	pass # Replace with function body.

func abrir_janela_detalhes(tipo: String) -> void:
	if not jogador_tem_o_bicho(tipo):
		print("Jogador ainda não capturou o bicho: ", tipo)
		return
	sfx_clique.play()
	var ficha: InfoElemento
	match tipo:
		"h": ficha = dados_h
		"o": ficha = dados_o
		"c": ficha = dados_c
		"agua": ficha = dados_agua
		"co2": ficha = dados_co2

	if ficha == null:
		print("ERRO:'", tipo, "' TA VAZIA")
		return
		
	if titulo != null and texto != null and bichos != null:
		titulo.text = ficha.titulo
		texto.text = ficha.descricao
		bichos.texture = ficha.bichos
	
	
	janela_informacao.modulate.a = 0
	janela_informacao.show()
	
	var tw = create_tween()
	tw.tween_property(janela_informacao, "modulate:a", 1.0, 0.25)

func _on_botao_sair_pressed() -> void:
	var tw = create_tween()
	tw.tween_property(janela_informacao, "modulate:a", 0.0, 0.2)
	await tw.finished
	janela_informacao.hide()


func _on_botao_infos_o_pressed() -> void:
	abrir_janela_detalhes("o")
	pass # Replace with function body.


func _on_botao_infos_h_pressed() -> void:
	abrir_janela_detalhes("h")
	pass # Replace with function body.


func _on_botao_infos_c_pressed() -> void:
	abrir_janela_detalhes("c")
	pass # Replace with function body.


func _on_butao_h_2o_pressed() -> void:
	abrir_janela_detalhes("agua")
	pass # Replace with function body.

func _on_butao_co_2_pressed() -> void:
	abrir_janela_detalhes("co2")
	pass # Replace with function body.

func _animar_brilho_botao(botao: Control, id_bicho: String, entrando: bool) -> void:
	if jogador_tem_o_bicho(id_bicho):
		var cor_alvo = Color(1.4, 1.4, 1.4) if entrando else Color(1, 1, 1)
		var tw = create_tween()
		tw.tween_property(botao, "modulate", cor_alvo, 0.1)
		if entrando:
			sfx_hover.play()

#CHECAGEM DA QUANTIDADE DOS BICHOS QUE FAZ LIBERAR A TELA DE INFOS
func jogador_tem_o_bicho(tipo: String) -> bool:
	match tipo:
		"h": return true
		"o": return true
		"c": return true
		"agua": return laboratorio_global.bichos_desbloqueados.has("a")
		"co2": return laboratorio_global.bichos_desbloqueados.has("dc")
	return false


func mudar_aba(direcao:int):
	aba_atual += direcao
	if botao_composto.disabled:
		if aba_atual < 0:
			aba_atual = 1
		if aba_atual > 1:
			aba_atual = 0
	else:
		if aba_atual < 0:
			aba_atual = 2
		if aba_atual > 2:
			aba_atual = 0
	match aba_atual:
		0:
			trocar_aba(tela_atomos)
		1:
			trocar_aba(tela_sintese)
		2:
			trocar_aba(tela_compostos)



func focar_aba_atual():
	match aba_atual:
		0:
			botao_infos_o.grab_focus()
		1:
			botao_o.grab_focus()
		2:
			if not butao_h_2o.disabled:
				butao_h_2o.grab_focus()
			elif not butao_co_2.disabled:
				butao_co_2.grab_focus()

func _on_focus_entered(botao):
	var tw = create_tween()
	tw.tween_property(botao, "scale", Vector2(1.1, 1.1), 0.1)
	tw.parallel().tween_property(
		botao,
		"modulate",
		Color(1.3, 1.3, 1.3),
		0.1
	)

func _on_focus_exited(botao):
	var tw = create_tween()
	tw.tween_property(botao, "scale", Vector2.ONE, 0.1)
	tw.parallel().tween_property(
		botao,
		"modulate",
		Color.WHITE,
		0.1
	)
