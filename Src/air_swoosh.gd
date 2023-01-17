extends KinematicBody2D

onready var hit_sparkle_scene = preload("res://Scenes/hit_sparkle.tscn")

# specifying that it has to be an integer
export var speed: int
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
		var collision = get_slide_collision(i)
		var space_state = get_world_2d().direct_space_state
		
		var distance = global_position.distance_to(collision.collider.position)
		
		# if it's facing left
		if $Sprite.flip_h == true:
			result = space_state.intersect_ray($Left.global_position, collision.collider.position, [self])
		else:
			result = space_state.intersect_ray($Right.global_position, collision.collider.position, [self])
		if result:
			var hit_sparkle = hit_sparkle_scene.instance()
			hit_sparkle.position = result.position
			get_parent().add_child(hit_sparkle)
			queue_free()

# if it doesnt hit anything by the time the timer runs out, it despawns
func _on_DespawnTimer_timeout():
	queue_free()
