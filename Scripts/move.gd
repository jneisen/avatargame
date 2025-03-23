extends Area2D

@export var damage : float
@export var knockback : Vector2
@export var hitstun : float
@export var timeTillActive : float
@export var timeActive : float

func _ready() -> void:
	$CollisionShape2D.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if(body.get_parent() != get_parent()):
		body.hit(knockback, hitstun, damage)

func _process(delta):
	timeTillActive -= delta
	if(timeTillActive < 0):
		
