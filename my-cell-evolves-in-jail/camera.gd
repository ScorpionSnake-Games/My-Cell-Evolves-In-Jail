extends Camera3D

@export var move_speed: float = 5.0
@export var zoom_speed: float = 5.0

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	var input_vector = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_back"):
		input_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	input_vector = input_vector.normalized()
	global_translate(Vector3(input_vector.x, 0, input_vector.z) * move_speed * delta)

	# Zoom (Y-axis movement)
	if Input.is_action_pressed("zoom_in") or Input.is_action_pressed("ui_text_scroll_up"):
		global_translate(Vector3(0, -zoom_speed * delta, 0))
	if Input.is_action_pressed("zoom_out") or Input.is_action_pressed("ui_text_scroll_down"):
		global_translate(Vector3(0, zoom_speed * delta, 0))
