extends Node

enum Dificuldade {
	FACIL,
	NORMAL,
	DIFICIL
}

var dificuldade_atual = Dificuldade.NORMAL

var configuracoes = {
	Dificuldade.FACIL: {
		"velocidade_inimigo": 100,
		"tempo_aparecimento": 10
	},

	Dificuldade.NORMAL: {
		"velocidade_inimigo": 150,
		"tempo_aparecimento": 6
	},

	Dificuldade.DIFICIL: {
		"velocidade_inimigo": 250,
		"tempo_aparecimento": 3
	}
}

func obter_configuracao(nome_configuracao: String):
	return configuracoes[dificuldade_atual][nome_configuracao]
