extends level

onready var tooltip_text = $CanvasLayer/Tooltips/RichTextLabel
onready var transition_rect := $CanvasLayer/SceneTransitionRect

var waiting_for_move_input = false
var waiting_for_left = false
var waiting_for_right = false
var waiting_for_attack = false
var waiting_for_defeated_enemy = false
var reached_double_jump_checkpoint = false

func _ready():
	Music.change_music(Music.i_dont_know)
	$Assassin.position = Vector2(256, 0)
	GameSwitches.health = 10
	GameSwitches.state = GameSwitches.DISABLED
	$Assassin.can_jump = false

func _input(event):
	if waiting_for_left:
		if event is InputEventKey:
			if event.pressed and (event.scancode == KEY_A or event.scancode == KEY_LEFT):
				waiting_for_left = false
	if waiting_for_right:
		if event is InputEventKey:
			if event.pressed and (event.scancode == KEY_D or event.scancode == KEY_RIGHT):
				waiting_for_right = false

func _physics_process(delta):
	if waiting_for_move_input:
		if !waiting_for_left and !waiting_for_right:
			change_tooltip("Sweet!")
			$Timers/JumpControlsTimer.start()
			waiting_for_move_input = false
	if waiting_for_attack:
		if Input.is_action_just_pressed("attack"):
			change_tooltip("Your sword can be used to interact with the world around you.")
			$Timers/AdvSwordControlsTimer.start()
			waiting_for_attack = false
			waiting_for_move_input = false
	if waiting_for_defeated_enemy:
		if $"Enemy/PathFollow2D/Ground Enemy".hit_point <= 0:
			change_tooltip("Defeated enemies drop a coin for you to collect!")
			waiting_for_defeated_enemy = false

func change_tooltip(text):
	tooltip_text.bbcode_text = "\n" + "[center]" + text
	
# door is closed
func _on_Lever_powered_on():
	$Door.set_deferred("visible", true)
	$Door/CollisionShape2D.set_deferred("disabled", false)

# door is opened
func _on_Lever_powered_off():
	$Lever/Area2D.set_deferred("monitoring", false)
	$Door.set_deferred("visible", false)
	$Door/CollisionShape2D.set_deferred("disabled", true)
	
	change_tooltip("The door has opened, time to move on!")
	$Timers/AdvSwordControlsTimer.stop()


func _on_WelcomeTimer_timeout():
	change_tooltip("Welcome to [wave amp=50 freq=2]FlipSide![/wave]")
	$Timers/MoveControlsTimer.start()


func _on_MoveControlsTimer_timeout():
	GameSwitches.state = GameSwitches.NORMAL
	change_tooltip("Use [color=yellow]LEFT[/color] and [color=yellow]RIGHT ARROW KEYS[/color] or [color=yellow]A[/color] and [color=yellow]D[/color] to move!")
	waiting_for_move_input = true
	waiting_for_left = true
	waiting_for_right = true


func _on_JumpControlsTimer_timeout():
	$Assassin.can_jump = true
	change_tooltip("Try jumping with [color=yellow]UP ARROW[/color], [color=yellow]SPACE[/color], or [color=yellow]W[/color] to proceed onward.")


func _on_VisibilityNotifier2D_screen_exited():
	if reached_double_jump_checkpoint:
		$Assassin.position = $RightGapSpawn.position
	else:
		$Assassin.position = $LeftGapSpawn.position


func _on_DJTooptipTrigger_body_entered(body):
	reached_double_jump_checkpoint = true
	$DJTooptipTrigger.set_deferred("monitoring", false)
	change_tooltip("Jump while midair to double jump.")


func _on_LeverTooltipTrigger_body_entered(body):
	$LeverTooltipTrigger.set_deferred("monitoring", false)
	change_tooltip("Splendid! You're an expert now!")
	$Timers/SwordControlsTimer.start()


func _on_SwordControlsTimer_timeout():
	change_tooltip("As an assassin, you're well skilled with a sword-like weapon.")
	yield(get_tree().create_timer(3), "timeout")
	change_tooltip("Tap [color=yellow]Z[/color] or [color=yellow]LEFT MOUSE CLICK[/color] to swing your sword")
	waiting_for_attack = true

func _on_AdvSwordControlsTimer_timeout():
	change_tooltip("Attack midair to create a forward-moving projectile!")


func _on_EnemyTooltipTrigger_body_entered(body):
	$EnemyTooltipTrigger.set_deferred("monitoring", false)
	change_tooltip("Enemy ahead! Use your sword to defeat it.")
	waiting_for_defeated_enemy = true


func _on_FirstLever_powered_on():
	$Door2.set_deferred("visible", false)
	$Door2/CollisionShape2D.set_deferred("disabled", true)

func _on_FirstLever_powered_off():
	$Door2.set_deferred("visible", true)
	$Door2/CollisionShape2D.set_deferred("disabled", false)

func _on_LeaveTooltipTrigger_body_entered(body):
	$LeaveTooltipTrigger.set_deferred("monitoring", false)
	change_tooltip("You've just about learned the basics! Exit the level to start your adventure.")

func _on_MainGameTrigger_body_entered(body):
	transition_rect.transition_to("res://Scenes/level.tscn")
