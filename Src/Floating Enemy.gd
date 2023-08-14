extends air_enemy

func _process(delta):
	if hit_point <= 0:
		$HitTimer.stop()

func _on_HitTimer_timeout():
	flinch_timeout()

func _on_VisibilityNotifier2D_screen_exited():
	respawn()
