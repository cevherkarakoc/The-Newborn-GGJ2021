extends Node2D


onready var n_Label = $Label

func set_text(new_text):
	$Label.text = new_text
