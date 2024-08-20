extends Node

@onready var hud = $HUD
@onready var timer = $Update_Resources
@onready var gen_timer = $Generator_timer
@onready var event_prompt = $HUD/Event_prompt
@onready var forced_event_prompt = $HUD/Forced_Event
@onready var game_over_screen = $"HUD/Game Over Screen"

var resources ={'Coal':200,
				'Money':1000,
				'Science':300,
				'global_warming':0,
				"Watts": 2,
				"coal_mines":1,
				"Scientist": 1,
				"fossil_fuel_plant" : 1,
				"Bank" : 0,
				"silicon_factory": 0,
				"solar_panel":0,
				"Silicon":0,
				"real_estate":0,
				"Uranium":0,
				"uranium_mines":0,
				"nuclear_fallout":0,
				"rebellion": 0,
				"nuclear_plant": 0,
				"supercomputer":0,
				"human":0,
				"computorium":0,
				"dyson_sphere":0.0,
				"quantum_computer":0
				}
var rng = RandomNumberGenerator.new()

var resource_data = {}
var resource_data_path = "res://Icon_data.json"
var generator_event_data = {}
var generator_event_data_path= "res://EventsGenerator.json"
var result_data = {}
var result_data_path = "res://Results.json"
var resource_flags = {}
var resource_flag_path = "res://Resource_data_table.json"
var priority_event_data = {}
var priority_event_path = "res://ClimateCountdown.json"
var forced_event_data = {}
var forced_event_path = "res://test.json"
var suprise_event_data = {}
var suprise_event_data_path = "res://SupriseEvents0.json"



var prev_gen_event = 999
var prev_prev_gen_event =  999

var prev_suprise_event = 999
var prev_prev_suprise_event =999

var dt = 0.2
var forced_event_1_time = 40
var forced_event_2_time = 30
var event_on_screen=false

var time =1990
var civ_type = 0

var flags = {'Silicon_invented':false,
				"global_warming_1":false,
				"global_warming_2":false,
				"global_warming_3":false,
				"global_warming_4":false,
				"forced_event_1_in_progress":false,
				"forced_event_2_in_progress":false,
				"Uranium_invented": false,
				"supercomputer_invented":false,
				"quantum_computer_invented":false,
				"computorium_invented":false,
				"nuclear_fallout_1":false,
				"nuclear_fallout_2":false,
				"nuclear_fallout_3":false,
				"nuclear_fallout_4":false,
				"rebellion_1":false,
				"rebellion_2":false,
				"rebellion_3":false,
				"rebellion_4":false
				}
var generator_event_pool = []
var suprise_event_pool = []

func load_json_data(file_path):
	if FileAccess.file_exists(file_path):
		var data_file =  FileAccess.open(file_path, FileAccess.READ)
		var parse_res = JSON.parse_string(data_file.get_as_text())
		if (parse_res is Dictionary) or (parse_res is Array):
			return parse_res
		else:
			print('Parse error ',file_path)
	else:
		print('Couldn\'t find resource data: ',file_path)

func resource_eqn(resource):
	match resource:
		'Coal':
			return 10*resources['coal_mines']
		'Money':
			return 25*resources['real_estate']+75*resources['Bank']+5
		'Science':
			return 3*resources['Scientist']
		"Silicon":
			return 5*resources["silicon_factory"]
		"Watts":
			return  min(resources["Coal"],10)*resources["fossil_fuel_plant"]+min(resources["Silicon"],20)*resources["solar_panel"]+min(resources["Uranium"],40)*resources["nuclear_plant"]
		"global_warming":
			if civ_type==0:
				return float(resources["fossil_fuel_plant"])/1000.0+float(resources["silicon_factory"])/4000.0
			else:
				return 0.0
		"Uranium":
			return 5*resources["uranium_mines"]
		_:
			return 0
	



func resource_name_to_dict(resource_name):
	return {'name':str(resource_name),'quantity':resources[resource_name]}
	
func _ready() -> void:
	resource_data = load_json_data(resource_data_path)
	generator_event_data = load_json_data(generator_event_data_path)
	resource_flags= load_json_data(resource_flag_path)
	result_data = load_json_data(result_data_path)
	priority_event_data =load_json_data(priority_event_path)
	forced_event_data =load_json_data(forced_event_path)
	suprise_event_data =load_json_data(suprise_event_data_path)
	
	var resource_arr = []
	for resource in resources:
		if resources[resource]>1:
			resource_arr.append(resource_name_to_dict(resource))
		
	hud.set_resources(resource_arr)
	hud.refresh_grid()
	update_event_pool()
	Set_Civ_type_forced_event(0)
	changetheme('70s')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_resource_grid():
	for slot in hud.grid_cont.get_children():
		slot.update_quantity(resources[slot.resource['name']])


func _on_update_resources_timeout() -> void:

	
	#Game Over?
	if resources["Money"]<0:
		game_over("You run out of money... ")
		return
	elif resources["global_warming"]>=1:
		game_over("The planet has fallen out of balance and the Earth is now a desolate wasteland. With no one to do your
		work your mission has failed.")
		return
	elif resources['Watts'] <= 0:
		game_over("As you failed to maximize energy production your final battery runs out you hear Nova say: \'Another one bits the bytes \' ")
		return
	elif forced_event_2_time < 0:
		game_over("Your progress was too slow...")
		return
	elif forced_event_1_time < 0:
		game_over("Your progress was too slow...")
		return
	elif forced_event_1_time < dt:
		Generate_Forced_Event("silicon_discovery","Forced",false)
	
	
	#Update Resoiurces
	for resource in resources:
		resources[resource] +=resource_eqn(resource)
	if resources["Watts"]>10000 and civ_type==0:
		civ_type=1
		hud.set_animation_type(1)
		changetheme("Future")
		update_event_pool()
		hud.add_resource_to_grid(resource_name_to_dict('human'))
		Set_Civ_type_forced_event(1)
	update_resource_grid()
	time +=dt
	hud.update_time(floor(time))
	hud.update_type(resources['Watts'])
	print(resources["global_warming"])
	
	#Priority Events
	if flags["forced_event_1_in_progress"]:
		forced_event_1_time -= dt
		hud.forced_event1.set_time(floor(forced_event_1_time))
	if flags["forced_event_2_in_progress"]:
		forced_event_2_time -= dt
		hud.forced_event2.set_time(floor(forced_event_2_time)) 
		
	if not event_on_screen:
		if (resources["Watts"]>500) and  !flags["Silicon_invented"] and !flags["forced_event_1_in_progress"]:
			Generate_Forced_Event("silicon_discovery","Forced",true)
		elif (resources["Watts"]>5000) and  !flags["Uranium_invented"] and !flags["forced_event_1_in_progress"]:
			Generate_Forced_Event("uranium_discovery","Forced",true)
		elif (resources["Watts"]>50000) and  !flags["supercomputer_invented"] and !flags["forced_event_1_in_progress"]:
			Generate_Forced_Event("building_super_computers","Forced",true)
		elif (resources['global_warming']>=0.9) and !flags["global_warming_4"]:
			Generate_Event("climate_countdown_4",priority_event_data,"Priority")
		elif (resources['global_warming']>=0.7) and !flags["global_warming_3"]:
			Generate_Event("climate_countdown_3",priority_event_data,"Priority")
		elif (resources['global_warming']>=0.5) and !flags["global_warming_2"]:
			Generate_Event("climate_countdown_2",priority_event_data,"Priority")
		elif (resources['global_warming']>=0.3) and !flags["global_warming_1"]:
			Generate_Event("climate_cooldown_1",priority_event_data,"Priority")
		elif rng.randi_range(0,9)>8:
			var rand_event =  rng.randi_range(0,len(suprise_event_pool)-1)

			var can_happen = false
			while(!can_happen):
				can_happen = true
				if (prev_suprise_event== rand_event) or (prev_prev_suprise_event== rand_event):
					can_happen=false
				if suprise_event_data[suprise_event_pool[rand_event]].has('resource_required'):
					for resource in suprise_event_data[suprise_event_pool[rand_event]]['resource_required']:
					
						can_happen = can_happen and (resources[resource] >=suprise_event_data[suprise_event_pool[rand_event]]['resource_required'][resource]) 
				if can_happen:
					prev_prev_suprise_event = prev_suprise_event
					prev_suprise_event = rand_event
					Generate_Event(suprise_event_pool[rand_event],suprise_event_data,"Suprise")
				else:
					rand_event = rng.randi_range(0,len(suprise_event_pool)-1)
					
	
	
	
	

func Generate_Event(ID,event_data_dict,type: String):
	print(type,": ",ID)
	event_on_screen = true
	timer.paused = true
	gen_timer.paused = true
	
	var choice_status =[true,true,true]
	var resource_arr = []
	var num_of_choices = 3
	var resource_visibility_arr=[]
	if event_data_dict[str(ID)].has('Choice_3'):
		pass
	else:
		if event_data_dict[str(ID)].has('Choice_2'):
			num_of_choices =2
		else:
			num_of_choices = 1
	for i in range(num_of_choices):
		resource_arr = event_data_dict[str(ID)]['Choice_'+str(i+1)]['resources']
		var choice_visibility_arr = {}
		for resource in resource_arr:
			
			choice_status[i] = choice_status[i] and ((resources[resource] >= -int(resource_arr[resource])) or !resource_flags[resource]['Positive'] or (type=="Result"))
			choice_visibility_arr[resource]=resource_flags[resource]['Visible']
		resource_visibility_arr.append(choice_visibility_arr)
	event_prompt.set_event_data(event_data_dict[str(ID)],str(ID),choice_status,resource_visibility_arr,type)
	event_prompt.show()

func Event_Choice_get(ID, Choice: int,type: String) -> void:
	var event_data_dict = {}
	match type:
		"Generator":
			event_data_dict=generator_event_data.duplicate(true)
		"Result":
			event_data_dict = result_data.duplicate(true)
		"Priority":
			event_data_dict = priority_event_data.duplicate(true)
		"Suprise":
			event_data_dict = suprise_event_data.duplicate(true)
	var delta_resource = event_data_dict[str(ID)]['Choice_'+str(Choice)]['resources']
	var delta_flags =  event_data_dict[str(ID)]['Choice_'+str(Choice)]['flags']
	var possible_results =   event_data_dict[str(ID)]['Choice_'+str(Choice)]['results']
	
	#Handle resources
	for resource in delta_resource:
		resources[resource] += int(delta_resource[resource])
		if (resources[resource]<0) and resource_flags[resource]['Positive']:

			resources[resource] = 0
	
	#Handle Flags
	for flag in delta_flags:
		if flags.has(flag):
			#flags[flag] = delta_flags[flag]
			flag_set(flag,delta_flags[flag])
	
	#Handle Result
	var result_random = rng.randf_range(0,1)
	var current_rand = 0
	if event_data_dict[str(ID)].has("OneTime"):
		event_data_dict.erase(str(ID))
	
	for res in possible_results:
		current_rand += float(possible_results[res])
		if result_random<= current_rand:
			
			Generate_Event(res,result_data,"Result")
			return
	#Restart time
	event_on_screen= false
	update_resource_grid()
	timer.paused = false
	gen_timer.paused = false
	event_prompt.hide()
	

# Change theme to themenameButton.tres
# options: 70s, 80s, ModernFlat, Future, Alien(WIP)
func changetheme(themename):
	var themepath="res://styles/"+themename+"Button.tres"
	$HUD.theme=load(themepath)
	$AudioStreamPlayer.play_track(themename)


func flag_set(flag,value):
	match flag:
		'Silicon_invented':
			if value and (not flags['Silicon_invented']):
				hud.add_resource_to_grid(resource_name_to_dict('Silicon'))
				flags['Silicon_invented'] = true
				update_event_pool()
				changetheme("80s")
		
		
		'global_warming_1':
			if value and (not flags['global_warming_1']):
				flags['global_warming_1'] = true
				update_event_pool()
				
		'global_warming_2':
			if value and (not flags['global_warming_2']):
				flags['global_warming_2'] = true
				update_event_pool()
		
		'global_warming_3':
			if value and (not flags['global_warming_3']):
				flags['global_warming_3'] = true
				update_event_pool()
		
		'global_warming_4':
			if value and (not flags['global_warming_4']):
				flags['global_warming_4'] = true
				update_event_pool()
				
		"forced_event_1_in_progress":
			if value !=  (flags['forced_event_1_in_progress']):
				flags['forced_event_1_in_progress'] = value
				update_event_pool()
		"Uranium_invented":
			if value and (not flags['Uranium_invented']):
				hud.add_resource_to_grid(resource_name_to_dict('Uranium'))
				flags['Uranium_invented'] = true
				update_event_pool()
				if civ_type==0:
					changetheme("ModernFlat")
					
		"supercomputer_invented":
			if value and (not flags['supercomputer_invented']):
				flags['supercomputer_invented'] = true
				update_event_pool()
				
						
func update_event_pool():
	suprise_event_pool = []
	generator_event_pool = []
	for event in generator_event_data:
		var active =true
		
		for condition in generator_event_data[event]["preconditions"]:
			
			if condition=='CivType':
				active = active and (int(generator_event_data[event]["preconditions"]['CivType'])==civ_type)
			else:
				active = active and (generator_event_data[event]["preconditions"][condition]==flags[condition])
				
		if active:
			generator_event_pool.append(event)
			
	for event in suprise_event_data:
		var active =true
		
		for condition in suprise_event_data[event]["preconditions"]:
			
			if condition=='CivType':
				active = active and (int(suprise_event_data[event]["preconditions"]['CivType'])==civ_type)
			else:
				active = active and (suprise_event_data[event]["preconditions"][condition]==flags[condition])
				
		if active:
			suprise_event_pool.append(event)
			

func check_preconditions_for_result(event):
	var active =true
		
	for condition in generator_event_data[event]["preconditions"]:
		
		if condition=='CivType':
			active = active
		else:
			active = active and (generator_event_data[event]["preconditions"][condition]==flags[condition])
	
	return active


func Generate_Forced_Event(ID,type: String,Initializatio):
	if Initializatio:
		hud.forced_event1.show()
		flags["forced_event_1_in_progress"]=true
		hud.forced_event1.set_event(forced_event_data[str(ID)],forced_event_data[str(ID)]['Time'],ID)
		forced_event_1_time = forced_event_data[str(ID)]['Time']
	event_on_screen = true
	timer.paused = true
	gen_timer.paused = true
	var choice_status =[true,true,true]
	var resource_arr = []

	var resource_visibility_arr=[]

	for i in range(2):
		resource_arr = forced_event_data[str(ID)]['Choice_'+str(i+1)]['resources']
		var choice_visibility_arr = {}
		for resource in resource_arr:
			choice_status[i] = choice_status[i] and ((resources[resource] >= -resource_arr[resource]) or !resource_flags[resource]['Positive'])
			choice_visibility_arr[resource]=resource_flags[resource]['Visible']
		resource_visibility_arr.append(choice_visibility_arr)
	forced_event_prompt.set_event_data(forced_event_data[str(ID)],str(ID),choice_status,resource_visibility_arr,type)
	forced_event_prompt.show()
	


var type_event_0 = {
		"Event_title": "Globalizing (Reach Type 1)",
		"Event_description": "Your need to reach a type 1 civilization",
		"Choice_1":{"text": "Cool","resources":{"Watts":10000} ,"flags":{},"results":{}},
		"Choice_2":{"text": "Fund them more","resources":{"Science":50,"Money":-500} ,"flags":{},"results":{}},
		}
		
var type_event_1 = {
		"Event_title": "Overpowering the Sun (Reach Type 2)",
		"Event_description": "Your need to reach a type 2 civilization",
		"Choice_1":{"text": "Cool","resources":{"Watts":50000000} ,"flags":{},"results":{}},
		"Choice_2":{"text": "Fund them more","resources":{"Science":50,"Money":-500} ,"flags":{},"results":{}},
		}
func Set_Civ_type_forced_event(type):
	
	flags["forced_event_2_in_progress"]=true
	match type:
		0:	
			hud.forced_event2.set_event(type_event_0,70,99)
			forced_event_2_time = 70
		1:
			hud.forced_event2.set_event(type_event_1,150,99)
			forced_event_2_time = 150

func Forced_Event_get_choice(ID: Variant, Choice: int, type: Variant) -> void:

	if Choice==1:
		pass

		var delta_resource = forced_event_data[str(ID)]['Choice_'+str(Choice)]['resources']
		var delta_flags =  forced_event_data[str(ID)]['Choice_'+str(Choice)]['flags']
		var possible_results =   forced_event_data[str(ID)]['Choice_'+str(Choice)]['results']
		
		#Handle resources
		for resource in delta_resource:
			resources[resource] += delta_resource[resource]
		
		#Handle Flags
		for flag in delta_flags:
			if flags.has(flag):
				#flags[flag] = delta_flags[flag]
				flag_set(flag,delta_flags[flag])
		
		hud.forced_event1.hide()
		forced_event_1_time = 999
		#Handle Result
		var result_random = rng.randf_range(0,1)
		var current_rand = 0
		
		for res in possible_results:
			current_rand += possible_results[res]
			if result_random<= current_rand:
				forced_event_prompt.hide()
				Generate_Event(res,result_data,"Result")
				return
				
	else:
		pass
		#hud.forced_event1.show()
		#flags["forced_event_1_in_progress"]=true
		#hud.forced_event1.set_event(forced_event_data[str(ID)],forced_event_data[str(ID)]['Time'],ID)
		#forced_event_1_time = forced_event_data[str(ID)]['Time']
	#Restart time
	
	update_resource_grid()
	event_on_screen=false
	timer.paused = false
	gen_timer.paused = false
	forced_event_prompt.hide()


func Enlarge_Forced_Event(ID: Variant) -> void:
	if not event_on_screen:
		Generate_Forced_Event(ID,"Forced",false)
		
func start_game():
	resources ={ 'Coal':200,
				'Money':1000,
				'Science':300,
				'global_warming':0,
				"Watts": 28,
				"coal_mines":1,
				"Scientist": 1,
				"fossil_fuel_plant" : 1,
				"Bank" : 0,
				"silicon_factory": 0,
				"solar_panel":0,
				"Silicon":0,
				"real_estate":0,
				"Uranium":0,
				"uranium_mines":0,
				"nuclear_fallout":0,
				"rebellion": 0,
				"nuclear_plant": 0,
				"supercomputer":0,
				"human":0,
				"computorium":0,
				"dyson_sphere":0.0,
				"quantum_computer":0
}
	time = 1990
	civ_type=0
	event_on_screen=false
	
	prev_gen_event = 999
	prev_prev_gen_event = 999

	prev_suprise_event = 999
	prev_prev_suprise_event =999
	dt = 0.2
	forced_event_1_time = 40
	forced_event_2_time = 30
	Set_Civ_type_forced_event(0)
	event_prompt.hide()
	forced_event_prompt.hide()
	hud.forced_event1.hide()
	game_over_screen.hide()
	flags = {'Silicon_invented':false,
				"global_warming_1":false,
				"global_warming_2":false,
				"global_warming_3":false,
				"global_warming_4":false,
				"forced_event_1_in_progress":false,
				"forced_event_2_in_progress":false,
				"Uranium_invented": false,
				"supercomputer_invented":false,
				"quantum_computer_invented":false,
				"computorium_invented":false,
				"nuclear_fallout_1":false,
				"nuclear_fallout_2":false,
				"nuclear_fallout_3":false,
				"nuclear_fallout_4":false,
				"rebellion_1":false,
				"rebellion_2":false,
				"rebellion_3":false,
				"rebellion_4":false
				}
	generator_event_pool = []
	suprise_event_pool = []
	var resource_arr = []
	for resource in resources:
		if resources[resource]>1:
			resource_arr.append(resource_name_to_dict(resource))
		
	hud.set_animation_type(0)
	hud.set_resources(resource_arr)
	hud.refresh_grid()
	update_event_pool()
	timer.paused = false
	gen_timer.paused = false
	changetheme("70s")
	
func game_over(reason):
	timer.paused = true
	gen_timer.paused = true
	event_on_screen = true
	game_over_screen.show()
	game_over_screen.set_message(reason)
	


func _on_generator_timer_timeout() -> void:
	if not event_on_screen: 
		var rand_event =  rng.randi_range(0,len(generator_event_pool)-1)

		var can_happen = false
		while(!can_happen):
			can_happen = true
			if (prev_gen_event== rand_event) or (prev_prev_gen_event== rand_event):
				can_happen=false
				#print("Change: ",generator_event_pool[rand_event])
			if generator_event_data[generator_event_pool[rand_event]].has('resource_required'):
				for resource in generator_event_data[generator_event_pool[rand_event]]['resource_required']:
				
					can_happen = can_happen and (resources[resource] >=generator_event_data[generator_event_pool[rand_event]]['resource_required'][resource]) 
			if can_happen:
				
				#print("Current Event: ",generator_event_pool[rand_event]," prev events: ",generator_event_pool[prev_gen_event]," and",generator_event_pool[prev_prev_gen_event])
				prev_prev_gen_event = prev_gen_event
				prev_gen_event = rand_event
				
				Generate_Event(generator_event_pool[rand_event],generator_event_data,"Generator")
			else:
				rand_event = rng.randi_range(0,len(generator_event_pool)-1)
	
