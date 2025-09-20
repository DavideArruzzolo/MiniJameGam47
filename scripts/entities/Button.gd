extends Switchable
class_name ObjButton

var clonesInAreaCount = 0


func checkSetStatus():
	if Status && clonesInAreaCount == 0:
		Status = false
		$AnimatedSprite2D.frame = 0
		$AudioStreamPlayer.play()
	elif !Status && clonesInAreaCount > 0:
		Status = true
		$AnimatedSprite2D.frame = 1
		$AudioStreamPlayer.play()


func onBodyEntered(body):
	if body is Player:
		clonesInAreaCount += 1
		checkSetStatus()


func onBodyExited(body):
	if body is Player:
		clonesInAreaCount -= 1
		checkSetStatus()
