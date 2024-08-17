extends Node

@onready var hud = $HUD
var resources ={'Oil':{"name": 'Oil', "quantity": 2, "texture":"res://Icons/Oil.png"},
'Money':{"name": 'Money', "quantity": 350, "texture":"res://Icons/Money.png"},
'Man Power':{"name": 'Man Power', "quantity": 25, "texture":"res://Icons/human.png" },
'Science':{"name": 'Science', "quantity":5, "texture":"res://Icons/science.png"},
'Uranium':{"name": 'Uranium', "quantity":0, "texture":"res://Icons/uranium.png"}}
var time =1950
var Uranium_added =false
func resource_eqn(resource):
	match resource:
		'Oil':
			return 3
		'Money':
			return 50
		'Man Power':
			return 10
		'Science':
			return round(0.01*resources['Man Power']['quantity'])
		'Uranium':
			return round(0.001*resources['Man Power']['quantity'])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resource_arr = []
	for resource in resources:
		if resources[resource]['quantity']>1:
			resource_arr.append(resources[resource])
		
	hud.set_resources(resource_arr)
	hud.refresh_grid()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func update_resource_grid():
	for slot in hud.grid_cont.get_children():
		slot.update_quantity(resources[slot.resource['name']]['quantity'])


func _on_update_resources_timeout() -> void:
	for resource in resources:
		resources[resource]['quantity'] +=resource_eqn(resource)
	if resources['Uranium']['quantity']>0 and (not Uranium_added) :
		hud.add_resource_to_grid(resources['Uranium'])
		Uranium_added = true
	update_resource_grid()
	time +=0.1
	hud.update_time(floor(time))
