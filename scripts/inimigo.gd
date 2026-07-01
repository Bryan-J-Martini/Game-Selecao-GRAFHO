extends Area2D

const VELOCIDADE_INIMIGO = 280.0

var jogador: Node2D = null
var pode_perseguir = false # Começa parado!

var cena_mini_fogo = preload("res://cenas/mini_fogo.tscn")
var tempo_ultimo_fogo = 0.0
const INTERVALO_FOGO = 0.2

func _ready() -> void:
	jogador = get_node_or_null("../Jogador")
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("fogo")
	pode_perseguir = false # Força o monstro a esperar o movimento do jogador

func _physics_process(delta: float) -> void:
	if pode_perseguir and jogador != null:
		if jogador.historico_de_posicoes.size() > 0:
			var alvo_atual = jogador.historico_de_posicoes[0]
			var distancia = position.distance_to(alvo_atual)
			
			if distancia < 4.0:
				position = alvo_atual 
				jogador.historico_de_posicoes.remove_at(0) 
			else:
				var direcao = (alvo_atual - position).normalized()
				position += direcao * VELOCIDADE_INIMIGO * delta
				if direcao.x < 0:
					$AnimatedSprite2D.flip_h = true  
				elif direcao.x > 0:
					$AnimatedSprite2D.flip_h = false 
		else:
			var direcao = (jogador.position - position).normalized()
			position += direcao * VELOCIDADE_INIMIGO * delta
			
			if direcao.x < 0:
				$AnimatedSprite2D.flip_h = true
			elif direcao.x > 0:
				$AnimatedSprite2D.flip_h = false

		# Lógica do rastro de mini chamas
		tempo_ultimo_fogo += delta
		if tempo_ultimo_fogo >= INTERVALO_FOGO:
			tempo_ultimo_fogo = 0.0 
			var novo_foguinho = cena_mini_fogo.instantiate()
			novo_foguinho.position = position
			get_parent().add_child(novo_foguinho)

func ativar_cronometro():
	# Quando o jogador faz o primeiro movimento, o timer de contagem regressiva começa!
	if not pode_perseguir and has_node("Timer") and $Timer.is_stopped():
		$Timer.start()
		print("Jogador se moveu! Timer do inimigo iniciado!")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jogador":
		print("O monstro te pegou! Game Over!")
		get_tree().change_scene_to_file("res://cenas/morreu.tscn")

func _on_timer_timeout() -> void:
	# Quando o tempo do timer acaba, o monstro ganha o sinal verde para correr!
	pode_perseguir = true
	print("O monstro começou a perseguir!")
