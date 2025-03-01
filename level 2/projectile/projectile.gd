extends Area2D

var direction = Vector2.ZERO  # Default to zero
var travelled_distance = 0
const SPEED = 650

func _physics_process(delta):
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > 720:
		queue_free()
		

func set_direction(new_direction):
	direction = new_direction.normalized()
	rotation = direction.angle()  # Rotate projectile to match direction
	
func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
	
