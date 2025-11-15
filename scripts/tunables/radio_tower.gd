extends Tunable

signal frequency_tuned
signal tower_hit

const TUNED_TIMER = 1.0

var tuned_tower = false
var tuned_elapsed = 0

func _process(delta):
	# If we are waiting for the player to tune the tower
	if not tuned_tower:
		# and they ARE tuning the tower, keep track of how long for
		if game_manager.current_frequency == self.band:
			tuned_elapsed += delta
			# once they've tuned long enough, tell the narrative manager
			if tuned_elapsed >= TUNED_TIMER:
				tuned_tower = true
				emit_signal("frequency_tuned")
		# if they aren't focused on our frequency we restart the clock
		else:
			tuned_elapsed = 0
	
	# Now continue acting like a normal tunable
	super._process(delta)

# When we get hit, broadcast a signal
func any_hit():
	emit_signal("tower_hit")

func _on_health_health_changed(_current, _max):
	print("Tower HP: %d / %d" % [_current, _max])

func _on_health_died():
	print("Tower destroyed!")
