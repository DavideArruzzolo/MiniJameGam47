extends Node

signal egg_changed(egg_name)
signal player_switched(player_name, player_color)

var players = []
var current_player_index = -1

var current_egg = "Default"



func _ready():
	# Imposta l'uovo iniziale e notifica la UI
	set_current_egg(current_egg)


func set_current_egg(egg_name):
	current_egg = egg_name
	emit_signal("egg_changed", current_egg)


func _input(event):
	if event.is_action_pressed("switch_character"):
		switch_character()


func register_player(player):
	players.append(player)
	if current_player_index == -1:
		current_player_index = 0
		players[current_player_index].activate()


func set_active_character(player_to_activate):
	var new_index = players.find(player_to_activate)

	if new_index == -1:
		return

	if new_index == current_player_index:
		return

	if current_player_index != -1 && is_instance_valid(players[current_player_index]):
		players[current_player_index].deactivate()

	current_player_index = new_index
	if is_instance_valid(players[current_player_index]):
		players[current_player_index].activate()
		var player = players[current_player_index]
		var player_name = "Player"
		if player.is_clone:
			player_name = "Clone " + str(player.clone_generation)
		emit_signal("player_switched", player_name, player.texture.modulate)


func switch_character():
	if players.size() < 2:
		return

	if current_player_index != -1 && is_instance_valid(players[current_player_index]):
		players[current_player_index].deactivate()

	var next_player_found = false
	for i in range(players.size()):
		current_player_index = (current_player_index + 1) % players.size()
		if is_instance_valid(players[current_player_index]):
			next_player_found = true
			break

	if next_player_found:
		players[current_player_index].activate()
		var player = players[current_player_index]
		var player_name = "Player"
		if player.is_clone:
			player_name = "Clone " + str(player.clone_generation)
		emit_signal("player_switched", player_name, player.texture.modulate)
	else:
		current_player_index = -1


func unregister_player(player):
	var index = players.find(player)
	if index != -1:
		players.remove_at(index)
		if index == current_player_index:
			current_player_index = -1
			if players.size() > 0:
				current_player_index = 0
				players[0].activate()
