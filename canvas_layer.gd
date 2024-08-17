extends CanvasLayer

var resources =[]

@onready var grid_cont = $"Grid-BG/GridContainer"
@onready var resource_slot_scene = preload("res://resource_slot.tscn")
@onready var year = $"Time-BG/TimeLabel"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play('default')
	refresh_grid()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_grid():
	while(grid_cont.get_child_count()>0):
		var child = grid_cont.get_child(0)
		grid_cont.remove_child(child)
		child.queue_free()
	
	return

func set_resources(new_resources):
	resources = new_resources
	
func add_resource_to_grid(resource):
	resources.append(resource)
	refresh_grid()

func refresh_grid():
	clear_grid()
	for resource in resources:
		var slot = resource_slot_scene.instantiate()
		slot.add_resource(resource)
		grid_cont.add_child(slot)
	return

func update_time(new_time):
	year.text = str(new_time)

func update_grid():
	pass
