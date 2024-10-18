# Use this for transmitting signals without a reference to a node!
# Just be aware that it will be received by ALL NODES CONNECTED TO THE SIGNAL!
# Pro tips:
# 1. if you're emitting a signal check if it's been connected on the receiving node!
# 2. If you're receiving a signal, check if it's been emitted on the sending node!
# 
# Example usage:
#
# ====In Event Bus====
# # Example optional description
# @warning_ignore("unused_signal") signal example_event() # @warning_ignore("unused_signal") prevents a warning from appearing for this signal. Keep the debugge clean!
#
# ====In receiving node====
# func _ready():
# 	EventBus.connect("example_event",_event_function) # Remember, a function call without parenthesis makes a Callable object!
# # Remember, common convention for functions that connect to signals is to use an underscore before the name.
# func _event_function():
# 	pass
# 
# ====In sending node====
# func thing_that_happens():
# 	EventBus.emit_signal("example_event")
#
#
#
extends Node

@warning_ignore("unused_signal") # Starts dialogue in the dialogue manager
signal start_dialogue(new_dialogue : DialogueChain)
@warning_ignore("unused_signal") # Toggles the game hud's speech hint's alpha between 0.0 and 1.0.
signal toggle_speech_hint(value)
@warning_ignore("unused_signal") # Emitted from the dialogue UI when dialogue begins, but before animation finishes.
signal dialogue_started()
@warning_ignore("unused_signal") # Emitted from the dialogue UI when dialogue ends, but before animation finishes.
signal dialogue_finished_before_setup()
@warning_ignore("unused_signal") # Emitted from the dialogue UI when the dialogue ends and after the animation finishes.
signal dialogue_finished_after_setup()
