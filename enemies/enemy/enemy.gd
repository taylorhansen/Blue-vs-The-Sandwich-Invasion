extends Area2D

signal fired

# movement speed in pixels/second
export(float) var MOVEMENT_SPEED = 100

# player to target
var player

func _process(delta):
    # face the player
    look_at(player.global_position)
    
    # move towards the player
    var direction = (player.global_position - global_position).normalized()
    global_position += MOVEMENT_SPEED * delta * direction


func _on_fired():
    """
    Called when being hit by a fireball.
    """
    # destroy this enemy
    queue_free()
