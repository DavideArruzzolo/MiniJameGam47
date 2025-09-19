extends Switchable
class_name Lever

func onInteract():
	if (Status):
		Status = false;
		# TODO Change Sprite
	else:
		Status = true;
		# TODO Change Sprite
	
func onAreaEntered(player):
	pass
	# player.InteractEvent += onInteract

func onAreaExited(player):
	pass
	# player.InteractEvent -= onInteract
