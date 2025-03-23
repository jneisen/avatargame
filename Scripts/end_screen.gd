extends Control

func setWinner(player_1_loss) -> void:
	if player_1_loss:
		$VBoxContainer/Label.text="Player 2 Wins"
	else:
		$VBoxContainer/Label.text="Player 1 Wins"

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/character_options.tscn") 
	queue_free()
	
func _on_end_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/stage.tscn") 
	queue_free()
	
