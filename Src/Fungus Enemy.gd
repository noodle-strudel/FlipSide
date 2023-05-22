extends land_enemy

func _on_HitTimer_timeout():
	flinch_timeout()

func _on_VisibilityNotifier2D_screen_exited():
	respawn()
