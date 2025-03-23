extends Area2D

@export var damage : float
@export var knockback : Vector2
@export var hitstun : float
@export var timeTillActive : float
@export var timeActive : float
@export var lagTime : float

func _ready() -> void:
	$CollisionShape2D.disabled = true

func reverse():
	knockback.x = -knockback.x
	position.x *= -1

func _on_body_entered(body: Node2D) -> void:
	if(body != get_parent()):
		body.hit(knockback, hitstun, damage)

func _process(delta: float) -> void:
	timeTillActive -= delta
	if(timeTillActive <= 0):
		$CollisionShape2D.disabled = false
		timeActive -= delta
		if(timeActive <= 0):
			get_parent().finishMove(lagTime)
			queue_free()
