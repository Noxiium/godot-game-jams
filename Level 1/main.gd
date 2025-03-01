extends Node

@export var mob_scene: PackedScene
@export var power_up_scene: PackedScene

var score
var player_invincible = false

func _ready():
	$Player.connect("collected_power_up", Callable(self, "_on_power_up_collected"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	
	$Music.play()
	
	pass # Replace with function body.

#Mobs
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	pass # Replace with function body.

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	pass # Replace with function body.

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
	pass # Replace with function body.

# Power-Up Spawning Function
func _on_power_up_timer_timeout() -> void:
	if power_up_scene == null:
		print("PowerUp scene is not assigned!")
		return
	
	var power_up = power_up_scene.instantiate()
	var power_up_instance = power_up_scene.instantiate()
	
	var min_x = 10
	var max_x = 470
	var min_y = 10
	var max_y = 710
	
	var rand_x = randf_range(min_x, max_x)
	var rand_y = randf_range(min_y, max_y)
	
	add_child(power_up_instance)
	power_up_instance.call_deferred("set_global_position", Vector2(rand_x, rand_y))
	
	add_child(power_up)
	print("PowerUp spawned at: ", power_up.global_position)
	
	add_child(power_up_instance)
	power_up_instance.add_to_group("powerups")
	
	power_up_instance.connect("collected", Callable(self, "_on_power_up_collected"))
	
	$PowerUpSound.play()
	
func _on_power_up_collected():
	print("Power-up collected! Player is invicible for 5 seconds.")
	player_invincible = true
	$Player.set_collision_layer_value(1, false)
	$Player.set_modulate(Color(1, 1, 1, 0.5))
		
	await get_tree().create_timer(5).time
		
	player_invincible = false
	$Player.set_collision_layer_value(1, true)
	$Player.set_modulate(Color(1, 1, 1, 1,))
