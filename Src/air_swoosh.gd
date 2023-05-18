extends KinematicBody2D

onready var hit_sparkle_scene = preload("res://Scenes/hit_sparkle.tscn")

# specifying that it has to be an integer
export var speed: int
export var damage: int
export (Vector2) var velocity

func _ready():
	$AnimationPlayer.play("swoosh")

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	velocity.x += speed
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# when it detects a collision with something that it can detect
	for i in get_slide_count():
		var result
		# position of the thing that the air swoosh hit
		var object_pos: Vector2
		
		var collision = get_slide_collision(i)

		var space_state = get_world_2d().direct_space_state
		
		if collision.collider is TileMap:
			var tile_pos: Vector2
			
			# tilemaps have local coordinates and im making the coordinates scene coordinates instead of tilemap coordinates
			
			# the ray will shoot into the tile instead of right next to it
			if $Sprite.flip_h == true:
				tile_pos = to_global(collision.collider.map_to_world(collision.collider.position)) - collision.collider.cell_size
			else:
				tile_pos = to_global(collision.collider.map_to_world(collision.collider.position)) + collision.collider.cell_size

			object_pos = tile_pos
		else:
			object_pos = collision.collider.global_position

		# if it's facing left
		if $Sprite.flip_h == true:
			result = space_state.intersect_ray($Left.global_position, object_pos, [self])
		# if it's facing right
		else:
			result = space_state.intersect_ray($Right.global_position, object_pos, [self])
		if result:
			var hit_sparkle = hit_sparkle_scene.instance()
			hit_sparkle.position = result.position
			get_parent().add_child(hit_sparkle)
			
			if collision.collider.get_parent() is PathFollow2D:
				collision.collider.deplete_health(damage)
			
			queue_free()

# if it doesnt hit anything by the time the timer runs out, it despawns
func _on_DespawnTimer_timeout():
	queue_free()
