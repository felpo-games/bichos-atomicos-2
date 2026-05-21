extends Control


# Lista de informações das criaturas
var dados_criaturas = [
	{
		"nome": "Hidrogenio",
		"descricao": "Anotação de Pesquisa: O Elemento Número 1. O Hidrogénio é puro entusiasmo! Ele tem tanta energia que não consegue ficar parado sozinho por um segundo; é o átomo mais inquieto que já estudei.",
		"imagem": preload("res://arte/vlad/satanas atomico/satanas atomico/ho2.png")
	},
	{
		"nome": "Receita da Água",
		"descricao": "Ufa, que calor! O Hidrogênio sozinho é uma bagunça, ele não para quieto e explode por qualquer coisinha. Mas eu descobri um truque: se eu juntar dois desses carinhas agitados com um Oxigênio bem calminho, eles viram Água! É o jeito perfeito de apagar esse fogaréu.",
		"imagem": preload("res://arte/vlad/satanas atomico/satanas atomico/nao sei oq atomico.png")
	},
	# Adicione as outras 3 aqui...
	{
		"nome": "Carbono",
		"descricao": "Anotação do Experimento 41: O átomo de Carbono é fascinante. Ele é o bloco de construção de tudo o que tem vida. Para que ele fique perfeitamente estável na minha Tabela, observei que ele sempre precisa se conectar em quatro pontos diferentes. Lembrete: nunca prosseguir com o experimento sem garantir essas quatro ligações químicas para o Carbono, ou a estrutura inteira desmorona.",
		"imagem": preload("res://arte/vlad/satanas atomico/satanas atomico/c.png")
	},
	{
		"nome": "Receita do CO2",
		"descricao": "Protocolo de Segurança #05: Os geradores estão sobrecarregados e soltando faíscas. Lembrete crucial a todos os assistentes: NUNCA usem Água (H2O) para apagar curtos-circuitos! A água conduz eletricidade e pioraria o desastre. A única forma segura de isolar as faíscas e sufocar o fogo elétrico é usando o gás Dióxido de Carbono. A síntese requer exatidão: conecte 1 átomo de Carbono a 2 átomos de Oxigênio (CO2). Essa união cria um gás pesado que apaga as chamas.",
		"imagem": preload("res://arte/vlad/satanas atomico/satanas atomico/co2.png")
	},
	{
		"nome": "Carbono",
		"descricao": "Anotação do Experimento 41: O átomo de Carbono é fascinante. Ele é o bloco de construção de tudo o que tem vida. Para que ele fique perfeitamente estável na minha Tabela, observei que ele sempre precisa se conectar em quatro pontos diferentes. Lembrete: nunca prosseguir com o experimento sem garantir essas quatro ligações químicas para o Carbono, ou a estrutura inteira desmorona.",
		"imagem": preload("res://arte/vlad/satanas atomico/satanas atomico/c.png")
	},
]

var pagina_atual = 0
var paginas_desbloqueadas = 1 # Começa com 1 ou 0 dependendo da sua lógica

func _ready():
	hide()
	paginas_desbloqueadas = eventos_global.paginas_coletadas
	atualizar_diario()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("diario"):
		eventos_global.numa_tela = true
		show()
		atualizar_diario()
		print(eventos_global.paginas_coletadas)
		paginas_desbloqueadas = eventos_global.paginas_coletadas
	pass
func atualizar_diario():
	var dados = dados_criaturas[pagina_atual]
	
	# Verifica se o player já coletou essa página
	if pagina_atual < paginas_desbloqueadas:
		$Label_nome.text = dados["nome"]
		$RichTextLabel.text = dados["descricao"]
		$TextureRect_imagem.texture = dados["imagem"]
		$TextureRect_imagem.modulate = Color(1, 1, 1, 1) # Imagem normal
	else:
		# Caso não tenha desbloqueado, mostra interrogações ou silhueta
		$Label_nome.text = "???"
		$RichTextLabel.text = "Página ainda não encontrada."
		$TextureRect_imagem.modulate = Color(0, 0, 0, 1) # Fica preto/silhueta


func _on_button_proximapagina_pressed():
	# Avança a página e volta para a primeira se chegar no fim
	pagina_atual += 1
	if pagina_atual >= dados_criaturas.size():
		pagina_atual = 0
	
	atualizar_diario()

func _on_button_sair_pressed():
	eventos_global.numa_tela = false
	hide() # Ou a lógica que você usa para fechar o menu
