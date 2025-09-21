extends StaticBody2D
class_name Door

@export var SwitchesToOpen: Array[Node2D] = []
var statuses = {} 


func _ready():
	for switchable in SwitchesToOpen:
		if switchable != null:
			switchable.StatusChangedEvent.connect(onStatusChanged)
			statuses[switchable] = switchable.Status
			
	if len(SwitchesToOpen) == 0:
		open()


func onStatusChanged(changingStatus: Switchable, status: bool):
	statuses[changingStatus] = status
	checkOpen()


func checkOpen():
	var shouldOpen = true
	for key in statuses.keys():
		if statuses[key] == false:
			shouldOpen = false
	if shouldOpen:
		open()
	else:
		close()
			
func open():
	$AnimatedSprite2D.frame = 1
	if $CollisionShape2D:
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)

func close():
	$AnimatedSprite2D.frame = 0
	if $CollisionShape2D:
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, false)
