extends Sprite3D

@onready var gene_loaded = false

func _process(_dt: float) -> void:
	if get_parent().has_meta("use_gene") and not gene_loaded:
		await get_tree().create_timer(1.0).timeout
		var image = Image.new()
		image.load("res://" + get_parent().get_meta("use_gene") + ".png")
		texture = ImageTexture.create_from_image(image)
		gene_loaded = true
