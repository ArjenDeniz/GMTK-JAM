extends AudioStreamPlayer

var currently_playing = 1
var in_transition = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func play_track(track):
	print(track)
	match track:
		"70s":
			currently_playing = 1
			in_transition = false
			stream = load("res://Musıc/TRACK 1.wav")
		"80s":
			currently_playing = 2	
			in_transition = true
			stream = load("res://Musıc/TRANSITION 1.wav")
		"ModernFlat":
			currently_playing = 3	
			in_transition = true
			stream = load("res://Musıc/TRANSITION 2.wav")
		"Future":
			currently_playing = 4	
			in_transition = true
			stream = load("res://Musıc/TRANSITION 3wav.wav")
	play()	
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finished() -> void:
	if in_transition:
		in_transition = false
		match currently_playing:
			2:
				stream = load("res://Musıc/TRACK 2.wav")
				
			3:
				stream = load("res://Musıc/TRACK 3.wav")
			4:
				stream = load("res://Musıc/TRACK 4.wav")
		
	play()
		
