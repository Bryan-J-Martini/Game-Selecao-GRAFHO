extends AnimatedSprite2D

func _ready() -> void:
	# Adiciona este foguinho a um grupo chamado "chamas"
	# Isso serve para podermos apagar todos eles de uma vez depois!
	add_to_group("mini_fogo")
