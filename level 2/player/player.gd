extends Area2D
signal hit

@export var speed = 400

var screen_size
var facing_direction = Vector2.RIGHT
var can_shoot = true  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		facing_direction = velocity
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if Input.is_action_just_released("shoot") and not is_mouse_over_ui():
		fire_projectile()

	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	can_shoot = false
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	can_shoot = true  
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func fire_projectile():
	if not can_shoot:
		return  # Prevents firing when dead
		
	print("fire")
	const PROJECTILE = preload("res://level 2/projectile/projectile.tscn")
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = %projectileMarker.global_position
	new_projectile.set_direction(facing_direction.normalized())
	#%projectileMarker.add_child(new_projectile)
	get_parent().add_child(new_projectile)
	
func is_mouse_over_ui():
	return get_viewport().gui_get_focus_owner() != null
