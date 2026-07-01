extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jogador":
		# 1. ATIVAMOS A CHUVA
		var efeito = get_node_or_null("/root/Mundo/CamadaChuva/EfeitoChuva")
		if efeito != null:
			efeito.visible = true
			
		var musica = get_node_or_null("/root/Mundo/MusicaFundo")
		var audio_chuva = get_node_or_null("/root/Mundo/SomChuva")
		
		var tween = create_tween().set_parallel(true)
		
		if musica != null and musica.playing:
			tween.tween_property(musica, "volume_db", -80.0, 2.0)
		
		if audio_chuva != null:
			audio_chuva.volume_db = -80.0
			audio_chuva.play()
			tween.tween_property(audio_chuva, "volume_db", 0.0, 2.0) 
			
		# 2. DELETAMOS OS FOGOS E O INIMIGO
		apagar_todos_os_fogos()
		
		# 3. CONGELA O JOGADOR (Ele para de andar na chuva)
		if body.has_method("set_physics_process"):
			body.set_physics_process(false)
		
		# 4. TORNA A GOTA INVISÍVEL (Dá a sensação de que foi coletada)
		visible = false
		
		# 5. O SEGREDO: Espera exatamente 3 segundos antes de continuar!
		print("Vitória! Aguardando 3 segundos sob a chuva...")
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://cenas/Fim.tscn")

func apagar_todos_os_fogos() -> void:
	var todas_as_chamas = get_tree().get_nodes_in_group("mini_fogo")
	for chama in todas_as_chamas:
		chama.queue_free()

	var monstro = get_node_or_null("/root/Mundo/Inimigo")
	
	if monstro != null:
		if monstro.has_method("_physics_process"):
			monstro.set_physics_process(false)
			
		var sprite_inimigo = monstro.get_node_or_null("AnimatedSprite2D")
		
		if sprite_inimigo != null:
			sprite_inimigo.play("morte_fogo")
			await sprite_inimigo.animation_finished

		monstro.queue_free()
		print("Inimigo de fogo apagado com sucesso!")
