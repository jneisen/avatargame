extends CharacterBody2D

var playerMovement : Vector2
@export var maxSpeed = 350.0
@export var groundSpeed = 20.0
@export var airSpeed = 15.0
@export var airFriction = 5.0
@export var friction = 15.0
@export var jumpHeight = 350.0
@export var fallSpeedDecreaser = 0.6
var hitstunTimer = 0
var health : float
var lives = 3

var left : bool
var right : bool
var up : bool
var down : bool
var attack : bool
var special : bool

var grounded : bool

var facingLeft = false


#func _ready() -> void:
	
func _process(_delta: float) -> void:
	left = Input.is_action_pressed("Left")
	right = Input.is_action_pressed("Right")
	up = Input.is_action_pressed("Jump")
	down = Input.is_action_pressed("Down")
	
	attack = Input.is_action_pressed("Attack")
	special = Input.is_action_pressed("Special")
	
	if(left && !facingLeft):
		facingLeft = true
	if(right && facingLeft):
		facingLeft = false

func _physics_process(_delta: float) -> void:
	if(hitstunTimer > 0):
		hitstunTimer -= _delta
		return
	grounded = is_on_floor()
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

func hitSelf(knockback, hitstun, damage):
	playerMovement = knockback
	health += damage
	hitstunTimer = hitstun
	
