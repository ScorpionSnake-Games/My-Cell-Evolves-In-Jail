extends CharacterBody3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
const MIN_Y: float = -3.0
@export var bounciness: float = 0.5
var last_y: float = 5.0
var gene_loaded = false
@onready var self_radius: float = get_sphere_radius()
var health:float = 0.0
var damage:float = 0.0
var intelligence:float = 0.0
var speed:float = 0.0
@onready var mat: StandardMaterial3D = $MeshInstance3D.material_override
@export var team = "Player"

func _ready():
	if not mat:
		mat = StandardMaterial3D.new()
		$MeshInstance3D.material_override = mat

	if team == "Player":
		mat.albedo_color = Color(1, 1, 1)  # 白色
	else:
		mat.albedo_color = Color(0, 0, 0)  # 黑色

func _process(_dt: float) -> void:
	if has_meta("use_gene") and (not gene_loaded):
		await get_tree().create_timer(1.0).timeout
		var gene_id = get_meta("use_gene")
		var cell_info_dict = get_node("CellInfoDictionary").cell_info
		if cell_info_dict.has(gene_id):
			var cell_data = cell_info_dict[gene_id]
			health = cell_data["Health"]
			damage = cell_data["Damage"]
			intelligence = cell_data["Intelligence"]
			speed = cell_data["Speed"]
		gene_loaded = true

	for ball in get_tree().get_nodes_in_group("energy_balls"):
		if ball == self:
			continue
		if ball.has_method("get_sphere_radius") and is_touching_sphere(ball, ball.get_sphere_radius()):
			ball.queue_free()
			var energy = get_meta("Energy") if has_meta("Energy") else 0
			set_meta("Energy", energy + 1)
			break

	if has_meta("Energy") and get_meta("Energy") >= 10:
		set_meta("Energy", get_meta("Energy") - 10)
		var clone = duplicate()
		get_parent().add_child(clone)
		var pos = global_position
		pos.x -= get_sphere_radius() / 2
		global_position.x += get_sphere_radius() / 2
		clone.global_position = pos

func _physics_process(delta: float) -> void:
	#here but do not add more #s
	if not is_on_floor():
		velocity.y -= gravity * delta
		last_y = velocity.y
	else:
		if last_y < MIN_Y:
			velocity.y = -last_y * bounciness
		else:
			velocity.y = 0.0
	var closest_ball: Node3D = null
	var closest_dist = INF

	for ball in get_tree().get_nodes_in_group("energy_balls"):
		if ball == self:
			continue
		var dist = global_transform.origin.distance_to(ball.global_transform.origin)
		if dist < closest_dist:
			closest_dist = dist
			closest_ball = ball
			
	if closest_ball != null:
		var direction = (closest_ball.global_transform.origin - global_transform.origin)
		direction.y = 0  # no vertical direction, Y handled by gravity
		direction = direction.normalized()
		
		velocity.x += direction.x * speed * delta
		velocity.z += direction.z * speed * delta
		velocity.x = clamp(velocity.x, -speed / 50, speed / 50)
		velocity.z = clamp(velocity.z, -speed / 50, speed / 50)

		if velocity.x < 0:
			$MeshInstance3D.scale.x = -abs($MeshInstance3D.scale.x)
		elif velocity.x > 0:
			$MeshInstance3D.scale.x = abs($MeshInstance3D.scale.x)
	else:
		velocity.x = 0
		velocity.z = 0
	move_and_slide()

func is_touching_sphere(other_node: Node3D, other_radius: float) -> bool:
	var distance = global_transform.origin.distance_to(other_node.global_transform.origin)
	return distance < (self_radius + other_radius)

func get_sphere_radius() -> float:
	if $MeshInstance3D and $MeshInstance3D.mesh is SphereMesh:
		var sphere := $MeshInstance3D.mesh as SphereMesh
		return sphere.radius * $MeshInstance3D.scale.x
	return 0.5
