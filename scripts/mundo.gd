extends Node2D

func _ready() -> void:
	# 1. Ativa a movimentação do jogador imediatamente
	if has_node("Jogador"):
		$Jogador.jogo_comecou = true
	
	# 2. Garante que a música de fundo vai começar a tocar
	if has_node("MusicaFundo"):
		$MusicaFundo.play()
		
	print("Mundo carregado! Música tocando e jogador pronto.")
