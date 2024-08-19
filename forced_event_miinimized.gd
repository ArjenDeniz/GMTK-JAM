extends Control

signal Maximize_forced_event(ID)

var event_ID = -1

@onready var countdown = $Countdown
@onready var title = $Title
@onready var grid = $GridContainer
@onready var resource_slot_scene = preload("res://resource_slot.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func clear_grid():
	while(grid.get_child_count()>0):
		var child = grid.get_child(0)
		grid.remove_child(child)
		child.queue_free()

func resource_dict_to_arr(resource_dict,resource):

	return {"name":resource,'quantity':resource_dict[resource]}


func set_event(event_data,time,ID):
	event_ID = ID
	title.text = event_data["Event_title"]
	countdown.text = "Remaining: "+str(time)
	clear_grid()
	for resource in event_data['Choice_1']['resources']:
		var slot = resource_slot_scene.instantiate()
		slot.add_resource(resource_dict_to_arr(event_data['Choice_1']['resources'],resource))
		grid.add_child(slot)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_time(new_time):
	countdown.text = "Remaining: "+str(new_time)
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Maximize_forced_event.emit(event_ID)
