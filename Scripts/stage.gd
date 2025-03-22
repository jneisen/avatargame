extends Node

var player1
var player2

func _ready():
	var characterScene = preload("res://Scenes/character.tscn")
	player1 = characterScene.instantiate()
	player2 = characterScene.instantiate()

func setPlayers(player1Selection, player2Selection):
	player1.setCharacter(player1Selection)
	player1.setGameController(self)
	player2.setCharacter(player2Selection)
	player2.setGameController(self)

func lose(player1Bool):
	# send the loss player to the end screen
	return
