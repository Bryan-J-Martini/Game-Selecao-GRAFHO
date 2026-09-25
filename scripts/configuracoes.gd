extends Node

const ARQUIVO_CONFIG = "user://configuracoes.cfg"

var volume_musica: float = 1.0
var volume_efeitos: float = 1.0

var tela_cheia: bool = false

# 0 = Fácil
# 1 = Normal
# 2 = Difícil
var dificuldade: int = 1


func _ready() -> void:
	carregar_configuracoes()
	aplicar_configuracoes()


# =========================================================
# SALVAR
# =========================================================

func salvar_configuracoes() -> void:

	var config = ConfigFile.new()

	config.set_value("audio", "volume_musica", volume_musica)
	config.set_value("audio", "volume_efeitos", volume_efeitos)

	config.set_value("video", "tela_cheia", tela_cheia)

	config.set_value("jogo", "dificuldade", dificuldade)

	config.save(ARQUIVO_CONFIG)


# =========================================================
# CARREGAR
# =========================================================

func carregar_configuracoes() -> void:

	var config = ConfigFile.new()

	if config.load(ARQUIVO_CONFIG) != OK:
		return

	volume_musica = config.get_value(
		"audio",
		"volume_musica",
		1.0
	)

	volume_efeitos = config.get_value(
		"audio",
		"volume_efeitos",
		1.0
	)

	tela_cheia = config.get_value(
		"video",
		"tela_cheia",
		false
	)

	dificuldade = config.get_value(
		"jogo",
		"dificuldade",
		1
	)


# =========================================================
# APLICAR CONFIGURAÇÕES
# =========================================================

func aplicar_configuracoes() -> void:

	# -------------------------
	# VOLUME DA MÚSICA
	# -------------------------

	var indice_musica = AudioServer.get_bus_index("Musica")

	if indice_musica != -1:
		AudioServer.set_bus_volume_linear(
			indice_musica,
			volume_musica
		)


	# -------------------------
	# VOLUME DOS EFEITOS
	# -------------------------

	var indice_efeitos = AudioServer.get_bus_index("Efeitos")

	if indice_efeitos != -1:
		AudioServer.set_bus_volume_linear(
			indice_efeitos,
			volume_efeitos
		)


	# -------------------------
	# TELA CHEIA
	# -------------------------

	if tela_cheia:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN
		)
	else:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_WINDOWED
		)


# =========================================================
# ALTERAR VOLUME DA MÚSICA
# =========================================================

func definir_volume_musica(valor: float) -> void:

	volume_musica = valor

	var indice = AudioServer.get_bus_index("Musica")

	if indice != -1:
		AudioServer.set_bus_volume_linear(
			indice,
			volume_musica
		)

	salvar_configuracoes()


# =========================================================
# ALTERAR VOLUME DOS EFEITOS
# =========================================================

func definir_volume_efeitos(valor: float) -> void:

	volume_efeitos = valor

	var indice = AudioServer.get_bus_index("Efeitos")

	if indice != -1:
		AudioServer.set_bus_volume_linear(
			indice,
			volume_efeitos
		)

	salvar_configuracoes()


# =========================================================
# ALTERAR TELA CHEIA
# =========================================================

func definir_tela_cheia(valor: bool) -> void:

	tela_cheia = valor

	if tela_cheia:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN
		)
	else:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_WINDOWED
		)

	salvar_configuracoes()


# =========================================================
# ALTERAR DIFICULDADE
# =========================================================

func definir_dificuldade(valor: int) -> void:

	dificuldade = valor

	salvar_configuracoes()
