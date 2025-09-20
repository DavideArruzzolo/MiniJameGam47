extends Switchable
class_name Lever

func onInteract():
	if Status:
		Status = false
		$AnimatedSprite2D.play("default")
		$AudioStreamPlayer.play()
	else:
		Status = true
		$AnimatedSprite2D.play("default", -1, true)
		$AudioStreamPlayer.play()

func onBodyEntered(body: Node2D) -> void:
	if body is Player:
		body.interacted_event.connect(onInteract)

func onBodyExited(body: Node2D) -> void:
	if body is Player:
		body.interacted_event.disconnect(onInteract)
