extends Area2D

var Wood = preload("res://entities/Wood.tscn")
onready var m_Player = $AudioStreamPlayer2D

func cut_down():
	if not m_Player.playing:
		m_Player.play()

func _on_AudioStreamPlayer2D_finished():
	var wood = Wood.instance()
	wood.position = position
	get_parent().add_child(wood)
	queue_free()
