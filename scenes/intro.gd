extends Sprite


onready var n_Tween = $Tween

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene("res://scenes/TestScene.tscn")

func _ready():
	n_Tween.interpolate_property(
			self,"scale",
			Vector2(2,2), Vector2(2.25,2.25),
			1.75,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(
			self,"scale",
			Vector2(2.25,2.25), Vector2(2,2),
			1.75,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT , 1.75)
	n_Tween.start()
