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
	player.interacted_event += onInteract

func onAreaExited(player):
	player.interacted_event -= onInteract
