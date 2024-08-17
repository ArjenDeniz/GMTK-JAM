extends Control

@onready var button = $Button
@onready var grid = $GridContainer
var choice_num
@onready var resource_slot_scene = preload("res://resource_slot.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func clear_grid():
	while(grid.get_child_count()>0):
		var child = grid.get_child(0)
		grid.remove_child(child)
		child.queue_free()
	

func set_choice(choice_text,resources,choice_ID):
	button.text = choice_text
	choice_num = choice_ID
	clear_grid()
	for resource in resources:
		var slot = resource_slot_scene.instantiate()
		slot.add_resource(resource)
		grid.add_child(slot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
