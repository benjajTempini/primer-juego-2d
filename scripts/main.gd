extends Node2D

@export var mob_scene: PackedScene
var score
var hud

func _ready():
	hud = $HUD

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

	if is_instance_valid(hud):
		hud.show_game_over()
	else:
		print("no es valido")
	$Music.stop()
	$DeathSound.play()

	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	hud.get_node("ScoreLabel").show()
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	if is_instance_valid(hud):
		hud.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
