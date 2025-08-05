extends Label3D

@onready var parent = get_parent()

func _ready() -> void:
	randomize()
	if not parent.has_meta("gene"):
		parent.set_meta("gene", [1.0, 1.0, 1.0, 1.0])
	else:
		var gene = parent.get_meta("gene")
		for i in range(len(gene)):
			var q: float = 0.0
			if i == 3:
				q = 0.4
			else:
				q = i / 20.0
			gene[i] += randf_range(q, q + 0.2) * (randi_range(0, 1) * 2 - 1)
			gene[i] = clamp(gene[i], 0, 2)
		parent.set_meta("gene", gene)

func _process(_delta: float) -> void:
	var gene = parent.get_meta("gene")
	var shown_gene = ""
	for i in gene:
		shown_gene += str(int(round(i)))
	parent.set_meta("use_gene", shown_gene)
	var gene_id = parent.get_meta("use_gene")
	var cell_info_dict = parent.get_node("CellInfoDictionary").cell_info
	if cell_info_dict.has(gene_id):
		var cell_data = cell_info_dict[gene_id]
		text = str(cell_data["Name"])
	else:
		print(shown_gene)
		text = "???"
