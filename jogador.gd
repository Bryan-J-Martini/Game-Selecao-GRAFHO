extends CharacterBody2D

const VELOCIDADE = 400.0

var direcao_atual = Vector2.ZERO
var esta_deslizando = false

# Nova linha: Cria uma referência para a sua câmera
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	# Procura o nó do cenário (mude para o nome exato do seu nó se não for 'TileMapLayer')
	var mapa = get_node_or_null("../TileMapLayer")
	
	if mapa:
		# Pega a área usada pelos blocos desenhados (em formato de grade)
		var limites_mapa = mapa.get_used_rect()
		# Pega o tamanho de cada quadradinho (ex: 16 pixels)
		var tamanho_bloco = mapa.tile_set.tile_size
		
		# Multiplica a grade pelo tamanho dos pixels para descobrir o tamanho real em tela
		camera.limit_left = limites_mapa.position.x * tamanho_bloco.x
		camera.limit_right = limites_mapa.end.x * tamanho_bloco.x
		camera.limit_top = limites_mapa.position.y * tamanho_bloco.y
		camera.limit_bottom = limites_mapa.end.y * tamanho_bloco.y
		
func _physics_process(_delta: float) -> void:
	if not esta_deslizando:
		verificar_comandos()
	
	if esta_deslizando:
		velocity = direcao_atual * VELOCIDADE
		
		# Move o personagem. Se houver colisão, processa a parada.
		if move_and_slide():
			parar_jogador()

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
		
	if nova_direcao != Vector2.ZERO:
		direcao_atual = nova_direcao
		esta_deslizando = true

func parar_jogador():
	esta_deslizando = false
	velocity = Vector2.ZERO
	
	# Pega os dados exatos do impacto com a parede
	if get_slide_collision_count() > 0:
		var colisao = get_slide_collision(0)
		# A 'normal' é um vetor que aponta para fora da parede atingida
		var normal_da_parede = colisao.get_normal()
		
		# Empurra o jogador levemente para fora da parede para desgrudar de vez
		position += normal_da_parede * 1.5
	
	direcao_atual = Vector2.ZERO
	position = position.round()
