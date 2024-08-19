extends Area2D


@export var r = 100.0
var t = 0.0
var omega = 2*2.0*3.14/4.6
@export var x0 = 600
@export var y0 = 415
@export var elipticity = 0.15
@export var sprite_texture : Texture2D
func _ready() -> void:
	$Sprite2D.texture = sprite_texture

func _process(delta: float) -> void:
	t+= delta
	position.x = r*cos(omega*t)+x0
	position.y = r*sin(omega*t)*elipticity+y0
	
