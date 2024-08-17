extends Control

@onready var event_name = $"Event Name"
@onready var description = $"Event Description"
@onready var choice1 = $Choice_grid/Choice_Slot1
@onready var choice2 = $Choice_grid/Choice_Slot2
@onready var choice3 = $Choice_grid/Choice_Slot3

signal choice_made(ID: int, Choice: int)

var event_id = -1

# Test
var resource1 = [{"name": 'Man Power', "quantity": '+100', "texture":"res://Icons/human.png" },
{"name": 'Science', "quantity":'-20', "texture":"res://Icons/science.png"}]
var choice1_data = {'text':'Wow thanks!','resources':resource1}
var resource2 = [{"name": 'Man Power', "quantity": '+10', "texture":"res://Icons/human.png" }]
var choice2_data = {'text':'Okay.....','resources':resource2}
var resource3 = [{"name": 'Man Power', "quantity": '-50', "texture":"res://Icons/human.png" },
{"name": 'Science', "quantity":'+10', "texture":"res://Icons/science.png"}]
var choice3_data = {'text':'Opinions of monkeys bears no importance for maximizing the energy output',
'resources':resource3}

var test_data = {'name':'You are cool', 'description':'The people think you are cool so they decided to gice you a reward',
'choice1':choice1_data,'choice2':choice2_data,'choice3':choice3_data,'ID':0}

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
func set_event_data(event_data,ID,Choice_status):
	event_name.text = event_data['Event Name']
	description.text = event_data['Event Description']
	choice1.set_choice(event_data['Choice1']['text'],resource_dict_to_arr(event_data['Choice1']['resources']),1,Choice_status[0])
	if event_data.has('Choice2'):
		choice2.set_choice(event_data['Choice2']['text'],resource_dict_to_arr(event_data['Choice2']['resources']),2,Choice_status[1])
		if event_data.has('Choice3'):
			choice3.set_choice(event_data['Choice3']['text'],resource_dict_to_arr(event_data['Choice3']['resources']),3,Choice_status[2])
		else:
			choice3.complete_disable()
	else:
		choice2.complete_disable()
		choice3.complete_disable()
	event_id = ID
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_choice_slot_1_button_press() -> void:
	choice_made.emit(event_id,1)
	

func _on_choice_slot_2_button_press() -> void:
	choice_made.emit(event_id,2)
	

func _on_choice_slot_3_button_press() -> void:
	choice_made.emit(event_id,3)
