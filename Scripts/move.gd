extends Area2D

@export var damage : float
@export var knockback : Vector2
@export var hitstun : float
@export var timeTillActive : float
@export var timeActive : float
@export var lagTime : float
@export var hitboxFix : float
@export var damageType : String

func _ready() -> void:
	$CollisionShape2D.disabled = true

func reverse():
	knockback.x = -knockback.x
	position.x = -1 * position.x - hitboxFix

func _on_body_entered(body: Node2D) -> void:
	if(body != get_parent()):
		body.hit(knockback, hitstun, damage, damageType)

func _process(delta: float) -> void:
	timeTillActive -= delta
	if(timeTillActive <= 0):
		$CollisionShape2D.disabled = false
		timeActive -= delta
		if(timeActive <= 0):
			get_parent().finishMove(lagTime)
			queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
