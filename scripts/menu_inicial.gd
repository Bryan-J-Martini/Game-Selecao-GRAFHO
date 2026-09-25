extends Control

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/mundo.tscn")

func _on_configuracoes_pressed() -> void:
	get_tree().change_scene_to_file("res://scripts/configuracoes.gd")

func _on_sair_pressed() -> void:
	get_tree().quit()
