extends Area2D

# speed in pixels/second, must be set during initialization
var speed

func _process(delta):
    # move along the current direction
    move_local_x(speed * delta, true)
    
    # fireball dies if time is up
    if $Timer.is_stopped():
        queue_free()

func _on_body_entered(body):
    """
    Called when a body enters this area.
    """
    # fireball hit an object that isn't the player so it dies
    if not body.is_in_group("player"):
        queue_free()
