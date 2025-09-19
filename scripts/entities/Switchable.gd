extends Node
class_name Switchable

signal StatusChangedEvent(this, status)

var Status: bool:
	get:
		return status
	set(value):
		emit_signal("StatusChangedEvent", self, value)
		status = value

var status = false
