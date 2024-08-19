extends CanvasLayer

@onready var moon = $Moon
@onready var bank = $Area2D
@onready var bank2 = $Area2D2
var r = 500.0
var t = 0.0
var omega = 2.0*3.14/50.0
var moon_order = 1
var bank_order =3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Earth.play('default')

	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t+= delta
	moon.position.x = r*cos(omega*t)+728
	moon.position.y = r*sin(omega*t)*0.23+415
	moon.scale = 0.2*abs(1+0.7*sin(omega*t)*0.85)*Vector2(1,1)

	
	pass

func _on_timer_timeout() -> void:
	moon_order = 1-moon_order
	moon.z_index = moon_order





func _on_shadow_area_entered(area: Area2D) -> void:
	
	area.hide()
	pass


func _on_light_area_entered(area: Area2D) -> void:
	area.show() # Replace with function body.
