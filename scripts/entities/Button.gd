extends Switchable
class_name ObjButton

var clonesInAreaCount = 0;

func checkSetStatus():
	if (Status && clonesInAreaCount == 0):
			Status = false
			# TODO Change Sprite   
	elif (!Status && clonesInAreaCount > 0):
		Status = true
		# TODO Change Sprite

func onAreaEntered(player):
		clonesInAreaCount += 1
		checkSetStatus()

func onAreaExited(player):
		clonesInAreaCount -= 1 
		checkSetStatus()
