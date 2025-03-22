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
var health = 0.0
var lives = 3

var left : bool
var right : bool
var up : bool
var down : bool
var attack : bool
var special : bool

var grounded : bool

var facingLeft = false

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
	playerMovement = knockback * (1.0 + health)
	health += (damage / 100.0)
	hitstunTimer = hitstun

func die():
	lives -= 1
	if(lives <= 0):
		gameController.lose(player1)
	health = 0.0
	
#------------------------------------------------------------

func _ready():
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
	
	if(left && !facingLeft):
		facingLeft = true
		sprite.flip_h = true
	if(right && facingLeft):
		facingLeft = false
		sprite.flip_h = false

func _physics_process(_delta: float) -> void:
	grounded = is_on_floor()
	if(hitstunTimer > 0):
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
	
	# jumping + gravity
	if(up && grounded):
		playerMovement.y = -jumpHeight
		grounded = false
	elif(grounded):
		playerMovement.y = 0
	elif(up && !grounded && playerMovement.y < 0):
		# decrease gravity slightly if moving upwards and pressing jump
		playerMovement.y += get_gravity().y * fallSpeedDecreaser * _delta
	elif(!grounded):
		playerMovement.y += get_gravity().y * _delta
	
	# start a move
	if(attack || special):
		var attackCode : String
		if(left):
			attackCode = "sideLeft"
		elif(up):
			attackCode = "up"
		elif(right):
			attackCode = "sideRight"
		elif(down && grounded):
			attackCode = "downGround"
		elif(down && !grounded):
			attackCode = "downAir";
		else:
			attackCode = "neutral"
		if(attack):
			attackDirection(attackCode)
		if(special):
			specialDirection(attackCode)
	
	# move and slide to complete character movements for this frame
	velocity = playerMovement
	move_and_slide()

# functions that execute an attack
func attackDirection(attackCode):
	# spawn a move corresponding to the attackCode + play animation corresponding
	if(attackCode == "sideLeft"):
		return
	
func specialDirection(attackCode):
	if(attackCode == "sideLeft"):
		return
