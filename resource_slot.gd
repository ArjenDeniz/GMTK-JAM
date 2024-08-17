extends Control

@onready var details = $Details
@onready var details_text = $Details/Label
@onready var Quantity = $Innter/Quantity
@onready var Icon = $Innter/ItemIcon


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
			print('Parse error')
	else:
		print('Couldn\'t find resource data ')
		
func _on_button_mouse_entered() -> void:
	details.show()
	details_text.show()
	return


func _on_button_mouse_exited() -> void:
	details.hide()
	details_text.hide()
	return

func add_resource(new_resource):
	resource['name'] = new_resource['name']
	resource['quantity'] = new_resource['quantity']
	var texture_data = load_json_data("res://Icon_data.json")
	resource['texture'] = texture_data[resource['name'] ]
	var image = Image.load_from_file(resource['texture'])
	image.resize(512,512)
	$Innter/ItemIcon.texture = ImageTexture.create_from_image(image)
	
	#Icon.texture = ResourceLoader.load(resource['texture'])
	$Innter/Quantity.text= str(resource['quantity'])
	$Details/Label.text = str(resource['name'])
	
	
func update_quantity(new_quantity):
	resource['quantity'] =new_quantity
	$Innter/Quantity.text = str(resource['quantity'])
	return
	
