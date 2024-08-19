extends Button

var resource = {"name": 'Default Resource', "quantity": -1, "texture": "res://Icons/science.png"}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#add_resource(resource)
	
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_json_data(file_path):
	if FileAccess.file_exists(file_path):
		var data_file =  FileAccess.open(file_path, FileAccess.READ)
		var parse_res = JSON.parse_string(data_file.get_as_text())
		if (parse_res is Dictionary) or (parse_res is Array):
			return parse_res
		else:
			print('Parse error in ',file_path)
	else:
		print('Couldn\'t find resource data ')

func add_resource(new_resource):
	resource['name'] = new_resource['name']
	resource['quantity'] = new_resource['quantity']
	var texture_data = load_json_data("res://Icon_data.json")
	
	if texture_data.has(resource['name']):
		resource['texture'] = texture_data[resource['name'] ]
	else:
		resource['texture'] = "res://icon.svg"
	# set icon
	icon = load(resource['texture'])
	# set quantity
	if resource['name']!= "Watts":
		text = str(resource['quantity'])
	else:
		text = str(resource['quantity'])+"TW"
	# set description
	tooltip_text = str(resource['name'])
	# text extension
	custom_minimum_size.x = max(10*len(text)+60,100)
	
func update_quantity(new_quantity):
	resource['quantity'] = new_quantity
	if resource['name'] != "Watts":
		text = str(resource['quantity'])
	else:
		text = str(resource['quantity'])+"TW"
	var length = len(text)
	custom_minimum_size.x = max(10*length+60,100)
	
