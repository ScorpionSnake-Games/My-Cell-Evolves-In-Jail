extends CharacterBody3D

@export var clone_count: int = 39
@export var area_min_x: float = -25.0
@export var area_max_x: float = 25.0
@export var area_min_z: float = -25.0
@export var area_max_z: float = 25.0
@export var fixed_y: float = 1.5

func _ready() -> void:
	randomize()
	randomize_position()
	
	# Only clone if this node is NOT marked as a clone
	if not has_meta("is_clone"):
		set_meta("is_clone", false)  # original
		for i in range(clone_count):
			var clone = duplicate()
			clone.set_meta("is_clone", true)
			get_parent().call_deferred("add_child", clone)
			clone.call_deferred("add_to_group", "energy_balls")
			clone.call_deferred("randomize_position")
		add_to_group("energy_balls")

func randomize_position() -> void:
	var rand_x = randf_range(area_min_x, area_max_x)
	var rand_z = randf_range(area_min_z, area_max_z)
	global_transform.origin = Vector3(rand_x, fixed_y, rand_z)

func get_sphere_radius() -> float:
	if $MeshInstance3D and $MeshInstance3D.mesh is SphereMesh:
		var sphere := $MeshInstance3D.mesh as SphereMesh
		return sphere.radius * $MeshInstance3D.scale.x
	return 0.5
