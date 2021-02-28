extends Area2D

var Stone = preload("res://entities/Stone.tscn")
onready var m_Player = $AudioStreamPlayer

func breake():
	if not m_Player.playing:
		m_Player.play()

func _on_AudioStreamPlayer_finished():
	var stone = Stone.instance()
	stone.position = position
	get_parent().add_child(stone)
	queue_free()
