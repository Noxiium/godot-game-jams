extends RigidBody2D

var health = 2
var mob_type


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	mob_type = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play(mob_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func take_damage():
	$mobDeathSound.play()
	health -= 1
	
	if health == 0:
		queue_free()
