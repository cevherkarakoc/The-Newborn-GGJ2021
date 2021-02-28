extends Area2D

onready var n_AudioStreamPlayer = $AudioStreamPlayer

const dialogs = [
	"He lost his soul",
	"and then we lost him",
	"Take it away and find the hope"
]
var index = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if(index == 2):
		$Label.visible = false
	else:
		n_AudioStreamPlayer.play()
		index = index + 1
		$Label.visible = true
		$Label.text = dialogs[index]
		if index < 3:
			$Timer.start(2)
