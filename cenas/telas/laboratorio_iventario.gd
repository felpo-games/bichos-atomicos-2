extends Control

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

#JANELA POPUP
@onready var janela_informacao: TextureRect = $JanelaInformacao
@onready var texto: RichTextLabel = $JanelaInformacao/Texto
@onready var titulo: Label = $JanelaInformacao/Titulo
@onready var bicho: TextureRect = $JanelaInformacao/Bicho
@onready var botao_sair: TextureButton = $JanelaInformacao/Botao_sair

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

func _ready() -> void:
	trocar_aba(tela_atomos)
	atualizar_colecao()
	limpar_bancada()
	laboratorio_global.atomo_atualizado.connect(_on_atomo_atualizado)
	atualizar_icones_inventario()

func _input(event: InputEvent) -> void:
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
	if laboratorio_global.quantidade_h > 0:
		h.show()
		
	if laboratorio_global.quantidade_o > 0:
		o.show()
		
	if laboratorio_global.quantidade_c > 0:
		c.show()

func _on_visibility_changed() -> void:
	if visible:
		atualizar_icones_inventario()

func trocar_aba(aba_ativa: Control) -> void:
	tela_atomos.hide()
	tela_sintese.hide()
	tela_compostos.hide()
	aba_ativa.show()
	if aba_ativa == tela_compostos:
		atualizar_colecao()

func verificar_acesso_compostos():
	if botao_composto.disabled == true: 
			botao_composto.disabled = false
			var tw = create_tween()
			tw.tween_property(botao_composto, "modulate", Color.GREEN, 0.5)
			tw.tween_property(botao_composto, "modulate", Color.WHITE, 0.2)

func atualizar_colecao():
# ÁGUA
	if laboratorio_global.bichos_desbloqueados.has("a"):
		img_agua_colecao.modulate = Color(1, 1, 1) 
		butao_h_2o.show()
		label_h_2o.show()
	else:
		img_agua_colecao.modulate = Color(0, 0, 0)
		butao_h_2o.hide()
		label_h_2o.hide()

	# CO2
	if laboratorio_global.bichos_desbloqueados.has("dc"):
		img_co2_colecao.modulate = Color(1, 1, 1) 
		butao_co_2.show() 
		label_co_2.show()
	else:
		img_co2_colecao.modulate = Color(0, 0, 0) 
		butao_co_2.hide()
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

	# --- 2. CÁLCULO DO CENTRO ---
	var centro_tela = get_viewport_rect().size / 2
	
	composto_animado.global_position = centro_tela - (composto_animado.size / 2)
	fundo_animado.global_position = centro_tela - (fundo_animado.size / 2)

	# --- 3. PREPARAÇÃO PARA O POP ---
	composto_animado.scale = Vector2.ZERO
	fundo_animado.scale = Vector2.ZERO
	composto_animado.modulate.a = 0
	fundo_animado.modulate.a = 0
	
	composto_animado.texture = textura
	fundo_animado.texture = imagem_brilho
	
	composto_animado.show()
	fundo_animado.show()

	# --- 4. FASE A: APARECER (Efeito Pop/Revelação) ---
	var tween = create_tween().set_parallel(true)
	var duracao_pop = 0.6
	
	# Composto e Aura crescem no centro
	tween.tween_property(composto_animado, "scale", Vector2(1.5, 1.5), duracao_pop).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(composto_animado, "modulate:a", 1.0, 0.3)
	
	tween.tween_property(fundo_animado, "scale", Vector2(2.0, 2.0), duracao_pop).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(fundo_animado, "modulate:a", 0.7, 0.4)
	tween.tween_property(fundo_animado, "rotation_degrees", 180, duracao_pop).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# --- 5. ESPERA (Tempo para admirar) ---
	await get_tree().create_timer(1.3).timeout
	
	# --- 6. FASE B: SEPARAÇÃO E VOO ---
	var tween_voo = create_tween().set_parallel(true)
	var duracao_voo = 0.8
	
	# Calcula destino apenas para o composto
	var destino = botao_composto.global_position + (botao_composto.size / 2)
	var pos_final_composto = destino - (composto_animado.size / 2)

	# O COMPOSTO voa para a aba, encolhe e some
	tween_voo.tween_property(composto_animado, "global_position", pos_final_composto, duracao_voo).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_voo.tween_property(composto_animado, "scale", Vector2.ZERO, duracao_voo)
	tween_voo.tween_property(composto_animado, "modulate:a", 0.0, duracao_voo)
	
	# A AURA fica parada no centro: apenas encolhe, some e termina de girar
	tween_voo.tween_property(fundo_animado, "scale", Vector2.ZERO, duracao_voo).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween_voo.tween_property(fundo_animado, "modulate:a", 0.0, duracao_voo)
	tween_voo.tween_property(fundo_animado, "rotation_degrees", 360, duracao_voo)

	# --- 7. FINALIZAÇÃO ---
	await tween_voo.finished
	composto_animado.hide()
	fundo_animado.hide()
	
	# Chama a notificação e pulsa o botão da aba
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
	trocar_aba(tela_compostos)
	pass # Replace with function body.

func _on_botao_atomos_pressed() -> void:
	trocar_aba(tela_atomos)
	pass # Replace with function body.

func _on_botao_sintese_pressed() -> void:
	trocar_aba(tela_sintese)
	pass # Replace with function body.

func abrir_janela_detalhes(tipo: String) -> void:
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
	titulo.text = ficha.titulo
	texto.text = ficha.descricao
	bicho.texture = ficha.icone
	
	janela_informacao.show()
	janela_informacao.scale = Vector2.ZERO
	janela_informacao.modulate.a = 0
	
	var tw = create_tween().set_parallel(true)
	tw.tween_property(janela_informacao, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(janela_informacao, "modulate:a", 1.0, 0.2)

func _on_botao_sair_pressed() -> void:
	janela_informacao.hide()
	pass # Replace with function body.
