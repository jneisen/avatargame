extends Area2D

@export var projectileVelocity : Vector2
@export var knockback : Vector2
@export var hitstun : float
@export var damage : float

var personSpawned

func _physics_process(delta: float) -> void:
	position += projectileVelocity

func setPerson(body):
	personSpawned = body
func die():
	personSpawned.finish_move(0.05)
	queue_free()
func reverse():
	projectileVelocity.x = -projectileVelocity.x
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.position.x += 35

func _on_body_entered(body: Node2D) -> void:
	if(body != personSpawned):
		if(body == CharacterBody2D):
			body.hit(knockback, hitstun, damage)
			personSpawned.finish_move(0.05)
		queue_free()
