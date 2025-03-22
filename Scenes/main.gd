extends Control

func _on_play_pressed() -> void:
	#Replace with main game file
	get_tree().change_scene_to_file("res://Scenes/charachter options.tscn") 
func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.
	
