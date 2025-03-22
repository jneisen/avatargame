extends Control

var player_1_selection = ""

var player_2_selection = ""

func _on_pick_zuko_1_pressed() -> void:
	player_1_selection="zuko"
	_update_button_states()

func _on_pick_katara_1_pressed() -> void:
	player_1_selection="katara"
	_update_button_states()

func _on_pick_zuko_2_pressed() -> void:
	player_2_selection="zuko"
	_update_button_states()

func _on_pick_katara_2_pressed() -> void:
	player_2_selection="katara"
	_update_button_states()

func _update_button_states():   
	if player_1_selection == "zuko":
		$HBoxContainer/VBoxContainer/pick_zuko_1.modulate = Color(1, 1, 1)
		$HBoxContainer/VBoxContainer/pick_katara_1.modulate = Color(0.5, 0.5, 0.5)
	else:
		$HBoxContainer/VBoxContainer/pick_zuko_1.modulate = Color(1, 1, 1)
		$HBoxContainer/VBoxContainer/pick_katara_1.modulate = Color(0.5, 0.5, 0.5)
