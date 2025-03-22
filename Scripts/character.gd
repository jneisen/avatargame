extends CharacterBody2D

var playerMovement : Vector2
@export var groundSpeed = 10.0
@export var airSpeed = 5.0
@export var jumpHeight = 10.0
@export var fallSpeedDecreaser = 0.9
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

var attackCode : int
var specialCode : int


#func _ready() -> void:
	
func _process(delta: float) -> void:
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

func _physics_process(delta: float) -> void:
	grounded = is_on_floor()
	# moving left and right on the ground
	if(left && grounded):
		playerMovement.x -= groundSpeed
	if(right && grounded):
		playerMovement.x += groundSpeed
	if(left && !grounded):
		playerMovement.x -= airSpeed
	if(right && !grounded):
		playerMovement.x += airSpeed
	
	# jumping + gravity
	if(up && grounded):
		playerMovement.y -= jumpHeight
		grounded = false
	elif(up && !grounded && playerMovement.y < 0):
		# decrease gravity slightly if moving upwards and pressing jump
		playerMovement.y += get_gravity().y * fallSpeedDecreaser
	elif(!grounded):
		playerMovement.y += get_gravity().y
	
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

# functions that execute an attack
func attackDirection(attackCode):
	# spawn a move corresponding to the attackCode + play animation corresponding
	if(attackCode == "sideLeft"):
		return
	
func specialDirection(attackCode):
	if(attackCode == "sideLeft"):
		return
