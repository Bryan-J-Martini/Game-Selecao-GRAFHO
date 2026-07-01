extends Area2D

# Velocidade de perseguição do monstro (ajuste se achar muito rápido ou lento)
const VELOCIDADE_INIMIGO = 100.0

# Guarda a referência do jogador para saber onde ele está
var jogador: Node2D = null
var pode_perseguir = false

func _ready() -> void:
	# Procura o jogador na cena principal pelo nome exato dele
	jogador = get_node_or_null("../Jogador")

func _physics_process(delta: float) -> void:
	# Só persegue se o Timer de delay terminou e se ele encontrou o jogador no mapa
	if pode_perseguir and jogador != null:
		# Calcula a direção exata em vetor do Inimigo até o Jogador
		var direcao = (jogador.position - position).normalized()
		
		# Move o inimigo naquela direção
		position += direcao * VELOCIDADE_INIMIGO * delta

# Esta função será chamada pelo jogador quando ele se mover
func ativar_cronometro():
	# Só inicia se o Timer não estiver rodando e se ainda não puder perseguir
	if not pode_perseguir and $Timer.is_stopped():
		$Timer.start()
		print("Jogador se moveu! Timer do inimigo iniciado!")

# Função que já configuramos: se encostar no jogador, dá Game Over
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jogador":
		print("O monstro te pegou! Game Over!")
		call_deferred("reiniciar_fase")

func reiniciar_fase():
	get_tree().reload_current_scene()

# Função do seu Timer (mantém o delay que vocês criaram antes!)
func _on_timer_timeout() -> void:
	pode_perseguir = true
