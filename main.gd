extends Node

@onready var hud = $HUD
@onready var timer = $Update_Resources
@onready var event = $HUD/Event_prompt

var resources ={'Oil':2,
'Money':350,
'Work Power':25,
'Science':6,
'Uranium':0}
var rng = RandomNumberGenerator.new()

var resource_data = {}
var resource_data_path = "res://Icon_data.json"
var event_data = {}
var event_data_path = "res://test.json"
var time =1950


var flags = {'Uranium_added':false}

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

func resource_eqn(resource):
	match resource:
		'Oil':
			return 3
		'Money':
			return 50
		'Work Power':
			return 10
		'Science':
			return round(0.01*resources['Work Power'])
		'Uranium':
			return round(0.001*resources['Work Power'])



func resource_name_to_dict(resource_name):
	return {'name':str(resource_name),'quantity':resources[resource_name]}
	
func _ready() -> void:
	resource_data = load_json_data(resource_data_path)
	event_data = load_json_data(event_data_path)
	var resource_arr = []
	for resource in resources:
		if resources[resource]>1:
			resource_arr.append(resource_name_to_dict(resource))
		
	hud.set_resources(resource_arr)
	hud.refresh_grid()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_resource_grid():
	for slot in hud.grid_cont.get_children():
		slot.update_quantity(resources[slot.resource['name']])


func _on_update_resources_timeout() -> void:
	for resource in resources:
		resources[resource] +=resource_eqn(resource)
	update_resource_grid()
	time +=0.1
	hud.update_time(floor(time))
	if rng.randi_range(0,40)>38:
		Generate_Event(rng.randi_range(0,1))
	

func Generate_Event(ID):
	timer.paused = true
	var choice_status =[true,true,true]
	var resource_arr = []
	for i in range(3):
		resource_arr = event_data[str(ID)]['Choice'+str(i+1)]['resources']
		for resource in resource_arr:
			choice_status[i] = choice_status[i] and (resources[resource] >= -resource_arr[resource])
		
	event.set_event_data(event_data[str(ID)],ID,choice_status)
	event.show()

func Event_Choice_get(ID: int, Choice: int) -> void:
	var delta_resource = event_data[str(ID)]['Choice'+str(Choice)]['resources']
	var delta_flags =  event_data[str(ID)]['Choice'+str(Choice)]['flags']
	for resource in delta_resource:
		resources[resource] += delta_resource[resource]
	
	for flag in delta_flags:
		if flags.has(flag):
			#flags[flag] = delta_flags[flag]
			flag_set(flag,delta_flags[flag])
	timer.paused = false
	event.hide()
	
func flag_set(flag,value):
	match flag:
		'Uranium_added':
			if value and (not flags['Uranium_added']):
				hud.add_resource_to_grid(resource_name_to_dict('Uranium'))
				flags['Uranium_added'] = true
