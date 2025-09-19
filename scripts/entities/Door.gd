extends Node2D
class_name Door

# Assign only Switchable - Godot does not allow exporting custom classes, but non-switchable won't work!
@export var SwitchesToOpen: Array[Node2D] = []
var statuses = {} # Switchable, bool

func _ready():
	for switchable in SwitchesToOpen:
		switchable.OnStatusChangedEvent += onStatusChanged
		statuses[switchable] = switchable.Status

func onStatusChanged(changingStatus: Switchable, status: bool):
	statuses[changingStatus] = status;
	checkOpen();

func checkOpen():
	var shouldOpen = true;
	for pair in statuses:
		if (pair.value == false):
			shouldOpen = false
			
	if (shouldOpen):
		# TODO Change sprite
		$Hitbox.set_deferred("disabled", true) # Either this or change layer
	else:
		# TODO Change sprite
		$Hitbox.set_deferred("disabled", false)
