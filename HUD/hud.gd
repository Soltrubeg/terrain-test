extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%FPS.text = "FPS: %s" % Engine.get_frames_per_second()
	%Seed.text = "Seed: %s" % Global.seed
	%Loc.text = "XYZ: %s" % Global.loc
