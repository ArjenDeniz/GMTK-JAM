extends CanvasLayer

@onready var earth = $Earth
@onready var mars = $Mars
@onready var mercury = $Mercury
@onready var venus = $Venus
@onready var jupyter = $Jupyter
@onready var saturn = $Saturn


var r = 800.0
var t = 0.0
var omega = 2.0*3.14/10.0
var moon_order = 1
var bank_order =3
var theta = 3.14/180*20
var earth_order = 1
var mars_order = 1
var mercury_order = 1
var venus_order = 1
var jupyter_order = 1
var saturn_order = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t+= delta
	
	r=700
	omega = 2.0*3.14/10.0
	earth.position.x = r*cos(theta)*cos(omega*t)+0.23*r*sin(theta)*sin(omega*t)+975-r*cos(theta)
	earth.position.y =- r*sin(theta)*cos(omega*t)+ 0.23*r*cos(theta)*sin(omega*t)+453+r*sin(theta)
	earth.scale = 1*abs(1+0.3*sin(omega*t)*0.85)*Vector2(1,1)
	
	r=720
	omega = 2.0*3.14/12.0
	mars.position.x = r*cos(theta)*cos(omega*t)+0.23*r*sin(theta)*sin(omega*t)+1096-r*cos(theta)
	mars.position.y =- r*sin(theta)*cos(omega*t)+ 0.23*r*cos(theta)*sin(omega*t)+377+r*sin(theta)
	mars.scale = 1*abs(1+0.3*sin(omega*t)*0.85)*Vector2(1,1)
	
	r=630
	omega = 2.0*3.14/6.0
	mercury.position.x = r*cos(theta)*cos(omega*t)+0.23*r*sin(theta)*sin(omega*t)+750-r*cos(theta)
	mercury.position.y =- r*sin(theta)*cos(omega*t)+ 0.23*r*cos(theta)*sin(omega*t)+572+r*sin(theta)
	mercury.scale = 1*abs(1+0.3*sin(omega*t)*0.85)*Vector2(1,1)
	
	r=680
	omega = 2.0*3.14/8
	venus.position.x = r*cos(theta)*cos(omega*t)+0.23*r*sin(theta)*sin(omega*t)+878-r*cos(theta)
	venus.position.y =- r*sin(theta)*cos(omega*t)+ 0.23*r*cos(theta)*sin(omega*t)+526+r*sin(theta)
	venus.scale = 1*abs(1+0.3*sin(omega*t)*0.85)*Vector2(1,1)
	
	r=830
	omega = 2.0*3.14/18.0
	jupyter.position.x = r*cos(theta)*cos(omega*t)+0.23*r*sin(theta)*sin(omega*t)+1230-r*cos(theta)
	jupyter.position.y =- r*sin(theta)*cos(omega*t)+ 0.23*r*cos(theta)*sin(omega*t)+272+r*sin(theta)
	jupyter.scale = 1*abs(1+0.3*sin(omega*t)*0.85)*Vector2(1,1)
	
	
	r=890
	omega = 2.0*3.14/50.0
	saturn.position.x = r*cos(theta)*cos(omega*t)+0.23*r*sin(theta)*sin(omega*t)+1428-r*cos(theta)
	saturn.position.y =- r*sin(theta)*cos(omega*t)+ 0.23*r*cos(theta)*sin(omega*t)+143+r*sin(theta)
	saturn.scale = 1*abs(1+0.3*sin(omega*t)*0.85)*Vector2(1,1)

	

func _on_timer_timeout() -> void:
	earth_order = 1-earth_order # Replace with function body.
	earth.z_index = earth_order
	mars.z_index =earth_order
	mercury.z_index = earth_order
	venus.z_index =earth_order
	jupyter.z_index = earth_order
	saturn.z_index =earth_order
	


func mercury_timeout() -> void:
	mercury_order = 1-mercury_order # Replace with function body.
	mercury.z_index = mercury_order


func venus_timeout() -> void:
	venus_order = 1-venus_order # Replace with function body.
	venus.z_index = venus_order


func mars_timeout() -> void:
	mars_order = 1-mars_order # Replace with function body.
	mars.z_index = mars_order
	print(mars.z_index)


func jupyter_timeout() -> void:
	jupyter_order = 1-jupyter_order
	jupyter.z_index = jupyter_order


func saturn_timeout() -> void:
	saturn_order = 1-saturn_order
	saturn.z_index = saturn_order
