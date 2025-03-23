extends Node2D

func setPlayerCharacters(player1, player2):
	$Player1.setCharacter(player1)
	$Player2.setCharacter(player2)



func _on_area_2d_body_exited(body: Node2D) -> void:
	body.die()

func lose(player_1_loss) -> void:
	var level = get_tree().root.get_node("Test")
	var myRoot = get_tree().root
	myRoot.remove_child(level)
	level.call_deferred("free")
	var switch = load("res://Scenes/end_screen.tscn").instantiate()
	switch.setWinner(player_1_loss)
	myRoot.add_child(switch)
