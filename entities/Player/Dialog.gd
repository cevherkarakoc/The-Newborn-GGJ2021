extends Node2D

onready var n_Timer = $Timer
onready var n_SFXPlayerTalk = $SFXPlayerTalk
onready var n_Label = $Label

func speak(text, end = false):
	$Label.text = text
	visible = true
	if not n_SFXPlayerTalk.playing:
		n_SFXPlayerTalk.play()
	if not end:
		n_Timer.start()


func _on_Timer_timeout():
	visible = false
