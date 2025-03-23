extends CharacterBody2D

var character = "Zuko"

var playerMovement : Vector2
@export var maxSpeed = 350.0
@export var groundSpeed = 20.0
@export var airSpeed = 15.0
@export var airFriction = 5.0
@export var friction = 15.0
@export var jumpHeight = 350.0
@export var fallSpeedDecreaser = 0.6
@export var player1 = true
var hitstunTimer = 0
var noMoveTime = 0
var health = 0.0
var lives = 3

var left : bool
var right : bool
var up : bool
var down : bool
var attack : bool
var special : bool

var grounded : bool
var actionable = true
var allowOthers = true

var facingLeft = true

@onready var sprite = $Player
@onready var animationPlayer = $AnimationPlayer
var gameController

#-------------------------------------------------
# External functions that are meant to be called by others
func setCharacter(string):
	character = string

func setGameController(someone):
	gameController = someone

func hit(knockback : Vector2, hitstun : float, damage : float):
	playerMovement = knockback * 100 * (1.0 + health)
	health += (damage / 100.0)
	hitstunTimer = hitstun
	actionable = true
	# if there is a scene underneath this one, delete it (aka a current move running)
	if(get_node_or_null("currentMove") != null):
		get_node("currentMove").queue_free()

func die():
	lives -= 1
	if(lives <= 0):
		gameController.lose(player1)
	health = 0.0
	position = Vector2(0, 0)
	
func finishMove(lagTime):
	actionable = true
	noMoveTime = lagTime
#------------------------------------------------------------

func _ready():
	sprite.position.x = -45.0
	$AnimatedSprite2D.visible = false
	# if you are on zuko, load the correct moves
	if(character == "Zuko"):
		return
	# if you are on katara, load the correct moves
	else:
		return
	
func _process(_delta: float) -> void:
	# takes the input for each player
	if(player1):
		left = Input.is_action_pressed("Left")
		right = Input.is_action_pressed("Right")
		up = Input.is_action_pressed("Jump")
		down = Input.is_action_pressed("Down")
		
		attack = Input.is_action_pressed("Attack")
		special = Input.is_action_pressed("Special")
	else:
		left = Input.is_action_pressed("Left2")
		right = Input.is_action_pressed("Right2")
		up = Input.is_action_pressed("Jump2")
		down = Input.is_action_pressed("Down2")
		
		attack = Input.is_action_pressed("Attack2")
		special = Input.is_action_pressed("Special2")
	
	if(left && !facingLeft && allowOthers):
		facingLeft = true
		sprite.position.x = -45.0
		sprite.flip_h = true
	if(right && facingLeft && allowOthers):
		facingLeft = false
		sprite.position.x = 30
		sprite.flip_h = false

func _physics_process(_delta: float) -> void:
	grounded = is_on_floor()
	if(noMoveTime > 0):
		noMoveTime -= _delta
	if(hitstunTimer > 0 || !actionable):
		if(!grounded):
			playerMovement.y += get_gravity().y * _delta
		velocity = playerMovement
		move_and_slide()
		hitstunTimer -= _delta
		return
	# moving left and right on the ground
	if(left && grounded && playerMovement.x > -maxSpeed):
		playerMovement.x -= groundSpeed
	if(right && grounded && playerMovement.x < maxSpeed):
		playerMovement.x += groundSpeed
	if(left && !grounded && playerMovement.x > -maxSpeed):
		playerMovement.x -= airSpeed
	if(right && !grounded && playerMovement.x < maxSpeed):
		playerMovement.x += airSpeed
	if(!left && !right && grounded):
		playerMovement.x -= sign(playerMovement.x) * friction
	if(!left && !right && !grounded):
		playerMovement.x -= sign(playerMovement.x) * airFriction
	
	if(grounded && abs(playerMovement.x) > 10 && allowOthers):
		animationPlayer.play("run")
	elif(allowOthers):
		animationPlayer.play("idle")
	
	# jumping + gravity
	if(up && grounded):
		if(allowOthers):
			animationPlayer.play("fall")
		playerMovement.y = -jumpHeight
		grounded = false
	elif(grounded):
		playerMovement.y = 0
	elif(up && !grounded && playerMovement.y < 0):
		# decrease gravity slightly if moving upwards and pressing jump
		if(allowOthers):
			animationPlayer.play("fall")
		playerMovement.y += get_gravity().y * fallSpeedDecreaser * _delta
	elif(!grounded):
		if(allowOthers):
			animationPlayer.play("fall")
		playerMovement.y += get_gravity().y * _delta
	
	# start a move
	if((attack || special) && noMoveTime <= 0):
		var attackCode : String
		if(left):
			attackCode = "sideLeft"
		elif(up):
			attackCode = "up"
		elif(right):
			attackCode = "sideRight"
		elif(down):
			attackCode = "down"
		else:
			attackCode = "neutral"
		if(attack && attackCode != "neutral"):
			actionable = false
			attackDirection(attackCode)
		if(special):
			actionable = false
			specialDirection(attackCode)
	
	# move and slide to complete character movements for this frame
	velocity = playerMovement
	move_and_slide()

# functions that execute an attack
func attackDirection(attackCode):
	# spawn a move corresponding to the attackCode + play animation corresponding
	var move
	if(attackCode == "sideLeft" || attackCode == "sideRight"):
		animationPlayer.play("sideAttack")
		allowOthers = false
		move = load("res://Scenes/Moves/Zuko/sideAttack.tscn").instantiate()
		move.name = "currentMove"
		if(attackCode == "sideLeft"):
			move.reverse()
		add_child(move)
	if(attackCode == "up"):
		animationPlayer.play("upAttack")
		allowOthers = false
		move = load("res://Scenes/Moves/Zuko/upAttack.tscn").instantiate()
		move.name = "currentMove"
		add_child(move)
	if(attackCode == "down"):
		animationPlayer.play("downAttack")
		allowOthers = false
		move = load("res://Scenes/Moves/Zuko/downAttack.tscn").instantiate()
		if(facingLeft):
			move.reverse()
		move.name = "currentMove"
		add_child(move)
	
func specialDirection(attackCode):
	if(attackCode == "sideLeft" || attackCode == "sideRight"):
		animationPlayer.play("sideSpecial")
		allowOthers = false
		var move = load("res://Scenes/Moves/Zuko/sideSpecial.tscn").instantiate()
		move.global_position = position + Vector2(0, -12)
		if(facingLeft):
			move.reverse()
		move.name = "currentMove"
		move.setPerson(self)
		add_sibling(move)
	if(attackCode == "up"):
		animationPlayer.play("upSpecial")
		allowOthers = false
		playerMovement.y = -2 * jumpHeight
		actionable = true
	if(attackCode == "down"):
		sprite.visible = false
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("downSpecial")
		allowOthers = false
		var move = load("res://Scenes/Moves/Zuko/downSpecial.tscn").instantiate()
		if(facingLeft):
			move.reverse()
		move.name = "currentMove"
		add_child(move)
	if(attackCode == "neutral"):
		animationPlayer.play("neutralSpecial")
		allowOthers = false
		var move = load("res://Scenes/Moves/Zuko/neutralSpecial.tscn").instantiate()
		if(facingLeft):
			move.reverse()
		move.name = "currentMove"
		add_child(move)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	allowOthers = true
	if(anim_name == "sideSpecial"):
		actionable = true


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible = false
	sprite.visible = true
	allowOthers = true
