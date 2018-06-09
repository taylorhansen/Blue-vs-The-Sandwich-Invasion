extends Area2D

# speed in pixels/second, must be set during initialization
var speed

func _process(delta):
    # move along the current direction
    move_local_x(speed * delta, true)
    
    # fireball dies if time is up
    if $Timer.is_stopped():
        queue_free()

func _on_area_entered(area):
    """
    Called when hitting another area.
    """
    # see if we killed an enemy with fire
    if area.is_in_group("enemies"):
        area.emit_signal("fired")
        
        # destroy the fireball
        queue_free()
