extends Control

@onready var details = $Details
@onready var details_text = $Details/Label
@onready var Quantity = $Innter/Quantity
@onready var Icon = $Innter/ItemIcon
@onready var Icon2= $Innter/Icon

var resource = {"name": 'Default Resource', "quantity": -1, "texture": "res://Icons/science.png"}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_resource(resource)
	
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	details.show()
	details_text.show()
	return


func _on_button_mouse_exited() -> void:
	details.hide()
	details_text.hide()
	return

func add_resource(new_resource):
	resource = new_resource
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
	
