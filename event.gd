extends Control

@onready var event_name = $"Event Name"
@onready var description = $"Event Description"
@onready var choice1 = $Choice_grid/Choice_Slot1
@onready var choice2 = $Choice_grid/Choice_Slot2
@onready var choice3 = $Choice_grid/Choice_Slot3

signal forced_choice_made(ID, Choice: int,type)

var event_id = -1
var type = "Forced"
# Test



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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


func Event_setup(ID: int):
	event_id = ID
	
func resource_dict_to_arr(dict):
	var arr = []
	for key in dict:
		arr.append({"name":key,'quantity':dict[key]})
	return arr
func set_event_data(event_data,ID,Choice_status,resource_visibility_arr,event_type):
	type = event_type
	event_name.text = event_data['Event_title']
	description.text = event_data['Event_description']
	choice1.set_choice(event_data['Choice_1']['text'],resource_dict_to_arr(event_data['Choice_1']['resources']),1,Choice_status[0],resource_visibility_arr[0])
	if event_data.has('Choice_2'):
		choice2.set_choice(event_data['Choice_2']['text'],resource_dict_to_arr(event_data['Choice_2']['resources']),2,Choice_status[1],resource_visibility_arr[1])
		if event_data.has('Choice_3'):
			choice3.set_choice(event_data['Choice_3']['text'],resource_dict_to_arr(event_data['Choice_3']['resources']),3,Choice_status[2],resource_visibility_arr[2])
		else:
			choice3.complete_disable()
			$ColorRect.size += Vector2(0, -150)
			$Choice_grid/Choice_Slot3.hide()
	else:
		choice2.complete_disable()
		choice3.complete_disable()
		$ColorRect.size += Vector2(0,-300)
		$Choice_grid/Choice_Slot2.hide()
		$Choice_grid/Choice_Slot3.hide()

	event_id = ID
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_choice_slot_1_button_press() -> void:
	forced_choice_made.emit(event_id,1,type)
	

func _on_choice_slot_2_button_press() -> void:
	forced_choice_made.emit(event_id,2,type)
	

func _on_choice_slot_3_button_press() -> void:
	forced_choice_made.emit(event_id,3,type)
