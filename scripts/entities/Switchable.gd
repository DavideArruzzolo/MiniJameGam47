extends Node
class_name Switchable

signal OnStatusChangedEvent(this, status)

var Status: bool:
		get: return status
		set(value):
			emit_signal("OnStatusChangedEvent", self, value)
			status = value

var status = false
