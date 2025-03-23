extends Control

var player_1_selection = ""

var player_2_selection = ""

func _ready():
	$warn_user.visible = false

func _on_pick_zuko_1_pressed() -> void:
	player_1_selection="zuko"
	_update_button_states(1)

func _on_pick_katara_1_pressed() -> void:
	player_1_selection="katara"
	_update_button_states(1)

func _on_pick_zuko_2_pressed() -> void:
	player_2_selection="zuko"
	_update_button_states(2)

func _on_pick_katara_2_pressed() -> void:
	player_2_selection="katara"
	_update_button_states(2)
	
func _on_start_pressed() -> void:
	if player_1_selection == "" or player_2_selection == "":
		$warn_user.visible = true
	else:
		var level = get_tree().root.get_node("Control")
		var myRoot = get_tree().root
		myRoot.remove_child(level)
		level.call_deferred("free")
		var switch = load("res://Scenes/stage.tscn").instantiate()
		switch.setPlayerCharacters(player_1_selection, player_2_selection)
		myRoot.add_child(switch)

func _update_button_states(player):   
	if player==1:
		if player_1_selection == "zuko":
			$VBoxContainer/HBoxContainer/VBoxContainer/pick_zuko_1.modulate = Color(1, 1, 1)
			$VBoxContainer/HBoxContainer/VBoxContainer/pick_katara_1.modulate = Color(0.5, 0.5, 0.5)
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer/pick_katara_1.modulate = Color(1, 1, 1)
			$VBoxContainer/HBoxContainer/VBoxContainer/pick_zuko_1.modulate = Color(0.5, 0.5, 0.5)
	else:
		if player_2_selection == "zuko":
			$VBoxContainer/HBoxContainer/VBoxContainer2/pick_zuko_2.modulate = Color(1, 1, 1)
			$VBoxContainer/HBoxContainer/VBoxContainer2/pick_katara_2.modulate = Color(0.5, 0.5, 0.5)
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer2/pick_katara_2.modulate = Color(1, 1, 1)
			$VBoxContainer/HBoxContainer/VBoxContainer2/pick_zuko_2.modulate = Color(0.5, 0.5, 0.5)

func _on_close_popup_pressed() -> void:
	$warn_user.hide() # Replace with function body.
