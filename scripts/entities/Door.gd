extends Node2D
class_name Door

# Assign only Switchable - Godot does not allow exporting custom classes, but non-switchable won't work!
@export var SwitchesToOpen: Array[Node2D] = []
var statuses = {} # Switchable, bool

func _ready():
	for switchable in SwitchesToOpen:
		switchable.StatusChangedEvent.connect(onStatusChanged)
		statuses[switchable] = switchable.Status

func onStatusChanged(changingStatus: Switchable, status: bool):
	statuses[changingStatus] = status;
	checkOpen();

func checkOpen():
	var shouldOpen = true;
	for key in statuses.keys():
		if (statuses[key] == false):
			shouldOpen = false
			
	if (shouldOpen):
		$AnimatedSprite2D.frame = 1;
		$Hitbox.set_collision_layer_value(1, 0)
		$Hitbox.set_collision_mask_value(1, 0)
	else:
		$AnimatedSprite2D.frame = 0;
		$Hitbox.set_collision_layer_value(1, 1)
		$Hitbox.set_collision_mask_value(1, 1)
