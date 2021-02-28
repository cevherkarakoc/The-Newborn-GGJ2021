extends Area2D


func bridge():
	$Bridge.visible = true
	set_collision_layer_bit(2, false)

