extends Button

var is_paused = false

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	text = "⏸️"  # Initial button text: pause symbol
	connect("pressed", Callable(self, "_on_PauseButton_pressed"))

func _on_PauseButton_pressed():
	is_paused = not is_paused
	if is_paused:
		get_tree().paused = true
		text = "▶️"  # Change to play symbol
	else:
		get_tree().paused = false
		text = "⏸️"  # Change back to pause symbol
