extends CharacterBody2D

const VELOCIDADE = 500.0

var direcao_atual = Vector2.ZERO
var esta_deslizando = false
var inimigo: Node2D = null
var historico_de_posicoes: Array[Vector2] = []

var jogo_comecou: bool = true

# Nova linha: Cria uma referência para a sua câmera
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	# Procura o nó do cenário
	var mapa = get_node_or_null("../TileMapLayer")
	
	# CORREÇÃO DE CAMINHO: Como vimos na sua árvore de cenas, o Inimigo está com "I" maiúsculo!
	inimigo = get_node_or_null("../Inimigo")
	
	if mapa:
		var limites_mapa = mapa.get_used_rect()
		var tamanho_bloco = mapa.tile_set.tile_size
		
		camera.limit_left = limites_mapa.position.x * tamanho_bloco.x
		camera.limit_right = limites_mapa.end.x * tamanho_bloco.x
		camera.limit_top = limites_mapa.position.y * tamanho_bloco.y
		camera.limit_bottom = limites_mapa.end.y * tamanho_bloco.y
		
func _physics_process(_delta: float) -> void:
	# TRAVA DE INÍCIO: Se o botão "JOGAR" não foi clicado, o jogador não se move!
	if not jogo_comecou:
		$AnimatedSprite2D.play("parado") # Garante que ele fique na animação de parado
		velocity = Vector2.ZERO
		return

	if not esta_deslizando:
		verificar_comandos()
	
	if esta_deslizando:
		velocity = direcao_atual * VELOCIDADE
		
		if move_and_slide():
			parar_jogador()

	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("correr")
		
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("parado")
		
func verificar_comandos():
	var nova_direcao = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_right"):
		nova_direcao = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left"):
		nova_direcao = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_down"):
		nova_direcao = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		nova_direcao = Vector2.UP
		
	# Se o jogador apertou alguma tecla, inicia o deslize
	if nova_direcao != Vector2.ZERO:
		direcao_atual = nova_direcao # ou nova_direcao dependendo de como está seu script
		esta_deslizando = true
		# Salva a posição onde o jogador iniciou o movimento
		historico_de_posicoes.append(position)
		
		# SEGREDO: Se encontrou o inimigo no mapa, manda ele ligar o Timer!
		if inimigo != null and inimigo.has_method("ativar_cronometro"):
			inimigo.ativar_cronometro()

func parar_jogador():
	esta_deslizando = false
	velocity = Vector2.ZERO
	
	# Pega os dados exatos do impacto com a parede
	if get_slide_collision_count() > 0:
		var colisao = get_slide_collision(0)
		var normal_da_parede = colisao.get_normal()
		
		# 1. Se bateu no teto ou no chão (Normal aponta para cima/baixo no eixo Y)
		if abs(normal_da_parede.y) > 0.5:
			# Afasta o jogador na vertical para não colar
			position.y += normal_da_parede.y * 1.5
			# O SEGREDO: Como ele bateu verticalmente, o X dele DEVE ser arredondado 
			# para travar exatamente no centro do corredor horizontal!
			position.x = round(position.x)
			
		# 2. Se bateu nas paredes laterais (Normal aponta para os lados no eixo X)
		elif abs(normal_da_parede.x) > 0.5:
			# Afasta o jogador na horizontal
			position.x += normal_da_parede.x * 1.5
			# O SEGREDO: Como ele bateu horizontalmente, o Y dele DEVE ser arredondado
			# para travar exatamente no centro do corredor vertical!
			position.y = round(position.y)
	
	direcao_atual = Vector2.ZERO
	# Garante que o rastro salve a posição perfeitamente alinhada
	historico_de_posicoes.append(position)
	position = position.round()
