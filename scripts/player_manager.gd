extends Node

var players = []
var current_player_index = -1





func _input(event):
	if event.is_action_pressed("switch_character"):
		switch_character()


func register_player(player):
	players.append(player)
	# If this is the first player, make it the active one.
	if current_player_index == -1:
		current_player_index = 0
		players[current_player_index].activate()


func set_active_character(player_to_activate):
	var new_index = players.find(player_to_activate)

	if new_index == -1:
		return  # Player not found in the manager

	if new_index == current_player_index:
		return  # Already the active player

	# Deactivate the old character
	if current_player_index != -1 && is_instance_valid(players[current_player_index]):
		players[current_player_index].deactivate()

	# Activate the new one
	current_player_index = new_index
	if is_instance_valid(players[current_player_index]):
		players[current_player_index].activate()


func switch_character():
	if players.size() < 2:
		return

	# Deactivate current player
	if current_player_index != -1 && is_instance_valid(players[current_player_index]):
		players[current_player_index].deactivate()

	# Find next valid player
	var next_player_found = false
	for i in range(players.size()):
		current_player_index = (current_player_index + 1) % players.size()
		if is_instance_valid(players[current_player_index]):
			next_player_found = true
			break

	if next_player_found:
		players[current_player_index].activate()
	else:
		# Handle case where all players might have been destroyed
		current_player_index = -1


func unregister_player(player):
	var index = players.find(player)
	if index != -1:
		players.remove_at(index)
		if index == current_player_index:
			# If the active player is removed, try to switch to another.
			current_player_index = -1  # Reset
			if players.size() > 0:
				current_player_index = 0
				players[0].activate()
