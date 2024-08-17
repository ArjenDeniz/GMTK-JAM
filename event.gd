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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_event_data(test_data)
	pass # Replace with function body.

func set_event_data(event_data):
	event_name.text = event_data['name']
	description.text = event_data['description']
	choice1.set_choice(test_data['choice1']['text'],test_data['choice1']['resources'],1)
	choice2.set_choice(test_data['choice2']['text'],test_data['choice2']['resources'],2)
	choice3.set_choice(test_data['choice3']['text'],test_data['choice3']['resources'],3)
	event_id = event_data['ID']
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
