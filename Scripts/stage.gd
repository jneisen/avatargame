extends Node2D

func _ready():
	$Player1.setGameController(self)
	$Player2.setGameController(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	body.die()

func lose(player_1_loss) -> void:
	$Area2D.set_deferred("monitoring", false)
	var level = get_tree().root.get_node("Test")
	var myRoot = get_tree().root
	level.call_deferred("free")
	var switch = load("res://Scenes/end_screen.tscn").instantiate()
	switch.setWinner(player_1_loss)
	myRoot.add_child.call_deferred(switch)

func update_player_health(isPlayer1, new_health) -> void:
	if isPlayer1:
		$player_ui_1/percent.text=str(new_health)+"%"
	else:
		$player_ui_2/percent.text=str(new_health)+"%"

func update_player_lives(isPlayer1, new_lives) -> void:
	if isPlayer1:
		$player_ui_1/lives.text="Lives: "+str(new_lives)
	else:
		$player_ui_2/lives.text="Lives: "+str(new_lives)
