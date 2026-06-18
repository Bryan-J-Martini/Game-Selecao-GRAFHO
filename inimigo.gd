extends Area2D

# Velocidade de perseguição do monstro (ajuste se achar muito rápido ou lento)
const VELOCIDADE_INIMIGO = 300.0

# Guarda a referência do jogador para saber onde ele está
var jogador: Node2D = null
var pode_perseguir = false

func _ready() -> void:
	jogador = get_node_or_null("../Jogador")

func _physics_process(delta: float) -> void:
	if pode_perseguir and jogador != null:
		# Se o jogador tiver posições gravadas no histórico
		if jogador.historico_de_posicoes.size() > 0:
			# O alvo atual do inimigo é a pegada mais antiga
			var alvo_atual = jogador.historico_de_posicoes[0]
			
			# Calcula a distância até a pegada
			var distancia = position.distance_to(alvo_atual)
			
			# Se o inimigo chegou muito perto da pegada (menos de 4 pixels)
			if distancia < 4.0:
				position = alvo_atual # Trava ele na posição exata da curva
				jogador.historico_de_posicoes.remove_at(0) # Apaga essa pegada e vai para a próxima
			else:
				# Move em direção à pegada atual
				var direcao = (alvo_atual - position).normalized()
				position += direcao * VELOCIDADE_INIMIGO * delta
		else:
			# Se o histórico estiver vazio (jogador parou e inimigo colou nele), 
			# ele vai direto na direção do jogador
			var direcao = (jogador.position - position).normalized()
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
