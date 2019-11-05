extends Area2D

# Projectile fired by the player, destroys enemies.

export var speed: float

func _process(delta):
	position += Vector2(speed * delta, 0).rotated(rotation)

func _on_Laser_body_entered(body):
	if body.is_in_group("Enemy"):
		body.hit()
	queue_free()
