extends Area2D

var Baby = preload("res://entities/Baby.tscn")
var m_respawn_loc = Vector2(72, 1000)
var m_finish_loc = Vector2(984, 72)

onready var n_Arrow = $Arrow
onready var n_SpriteTimer = $SpriteTimer
onready var n_AudioStreamPlayer = $AudioStreamPlayer
onready var n_FinishPlayer = $FinishPlayer

func stopTimer():
	n_SpriteTimer.visible = false
	n_SpriteTimer.stop()
	n_SpriteTimer.frame = 0

func respawn():
	position = m_respawn_loc
	var player = get_parent().get_node("Player")
	player.n_TweenMovement.remove_all()
	player.m_state = 0
	player.position = m_respawn_loc + Vector2(16, 0)
	player.n_Dialog.speak("I shouldn't leave it in the badlands")
	stopTimer()

func _input(event):
	if event.is_action_pressed("respawn"):
		respawn()

func _ready():
	n_Arrow.visible = true
	n_Arrow.rotation = global_position.angle_to_point(m_finish_loc)

func hold():
	n_Arrow.visible = false
	stopTimer()

func dropped():
	print(position)
	if m_finish_loc.distance_to(position) < 7:
		n_FinishPlayer.play()
		get_parent().get_node("Player").to_end()
		get_parent().get_node("Area2D/TileMap").set_cell(61,4,-1)
	else:
		if get_overlapping_areas():
			stopTimer()
		else:
			n_SpriteTimer.visible = true
			n_SpriteTimer.play("miss")
		
		n_Arrow.visible = true
		n_Arrow.rotation = global_position.angle_to_point(m_finish_loc)
	

func _on_SpriteTimer_frame_changed():
	n_AudioStreamPlayer.play()

func _on_SpriteTimer_animation_finished():
	respawn()
	


func _on_FinishPlayer_finished():
	var baby = Baby.instance()
	baby.position = position
	get_parent().add_child(baby)
	get_parent().get_node("Player").n_Dialog.speak("Thanks for playing", true)
	queue_free()
