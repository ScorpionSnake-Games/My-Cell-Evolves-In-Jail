extends CollisionShape3D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera = get_viewport().get_camera_3d()
		if not camera:
			return

		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000.0

		var space_state = get_world_3d().direct_space_state
		var ray = PhysicsRayQueryParameters3D.new()
		ray.from = from
		ray.to = to

		var ground = get_node_or_null("/root/RootNode/Ground")
		ray.exclude = [ground] if ground else []
		ray.collision_mask = 1

		var result = space_state.intersect_ray(ray)

		if result and result.collider == self.get_parent():
			var parent = get_parent()
			if parent.has_meta("use_gene"):
				var gene_id = parent.get_meta("use_gene")
				var cell_info_dict = parent.get_node("CellInfoDictionary").cell_info
				if cell_info_dict.has(gene_id):
					var cell_data = cell_info_dict[gene_id]
					show_right_panel(
						cell_data["Name"],
						cell_data["Type"],
						cell_data["Speed"],
						cell_data["Health"],
						cell_data["Damage"],
						cell_data["Intelligence"]
					)

# 🔧 把函数写在外面
func add_label(ui: Control, text: String) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 24)
	ui.add_child(label)

func show_right_panel(cellname, celltype, speed, health, damage, intelligence):
	var ui = get_node("/root/Node3D/CanvasLayer/RightPanel")
	if not ui:
		print("❌ RightPanel node not found")
		return

	ui.visible = true
	ui.process_mode = Node.PROCESS_MODE_ALWAYS

	var vbox = ui.get_node("VBox")
	for child in vbox.get_children():
		child.queue_free()

	add_label(vbox, "名称：" + str(cellname))
	add_label(vbox, "细胞类型：" + str(celltype))
	add_label(vbox, "—生活—")
	add_label(vbox, "速度👟：" + str(speed))
	add_label(vbox, "—战斗—")
	add_label(vbox, "血量❤️：" + str(health))
	add_label(vbox, "伤害⚔️：" + str(damage))
	add_label(vbox, "智慧🧠：" + str(intelligence))

	var close_button = Button.new()
	close_button.text = "❌"
	close_button.add_theme_font_size_override("font_size", 24)
	close_button.pressed.connect(func(): ui.visible = false)
	vbox.add_child(close_button)
