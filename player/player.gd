extends Area2D

# emitted when hit by an enemy
signal hit(enemy)

# fireball scene
const FIREBALL = preload("res://fireball/Fireball.tscn")

# player movement speed in pixels/second
export(float) var MOVEMENT_SPEED = 100

# fireball speed in pixels/second
export(float) var FIREBALL_SPEED = 500

func _process(delta):
    # move around
    var velocity = MOVEMENT_SPEED * \
        Vector2(_get_horizontal_input(), _get_vertical_input())
    transform.origin += velocity * delta
    
    # clamp position within the boundaries
    var bounds = get_viewport_rect().size
    transform.origin.x = clamp(transform.origin.x, 0, bounds.x)
    transform.origin.y = clamp(transform.origin.y, 0, bounds.y)
    
    # rotate towards the position of the mouse
    look_at(get_global_mouse_position())
    
    # shoot a fireball
    # this can only happen if the cooldown timer is over
    if Input.is_action_pressed("shoot_fireball") and \
        $FireballCooldown.is_stopped():
        # create a new fireball
        var fireball = FIREBALL.instance()
        $Fireballs.add_child(fireball)
        
        # set the fireball's velocity to the current direction scaled by the
        #  fireball speed
        fireball.global_transform = Transform2D(get_global_transform())
        fireball.global_position = Vector2(global_position)
        fireball.speed = FIREBALL_SPEED
        
        # restart the cooldown timer
        $FireballCooldown.start()

func _get_horizontal_input():
    """
    Gets the horizontal input direction: -1 for left, 1 for right, 0 for none.
    """
    return int(Input.is_action_pressed("move_right")) - \
        int(Input.is_action_pressed("move_left"))

func _get_vertical_input():
    """
    Gets the vertical input direction: -1 for up, 1 for down, 0 for none.
    """
    return int(Input.is_action_pressed("move_down")) - \
        int(Input.is_action_pressed("move_up"))

func _on_area_entered(area):
    """
    Called when another area collides with this one.
    """
    if area.is_in_group("enemies"):
        emit_signal("hit", area)
