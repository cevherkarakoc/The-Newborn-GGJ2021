extends Area2D


func fill():
	$Sprite.visible = false
	$Filled.visible = true
	set_collision_layer_bit(5, false)
