extends Node

var timers = []


func register(timer):
	timers.append(timer)

func pause_timers():
	for timer in timers:
		timer.paused = true

func unpause_timers():
	for timer in timers:
		timer.paused = false
