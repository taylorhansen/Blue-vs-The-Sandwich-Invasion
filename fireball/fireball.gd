extends Area2D

onready var max_frames = $Sprite.hframes * $Sprite.vframes

# speed in pixels/second, must be set during initialization
var speed = 0

func _ready():
    $Sprite

func _process(delta):
    # move along the current direction
    move_local_x(speed * delta, true)

func _on_area_entered(area):
    """
    Called when hitting another area.
    """
    # see if we killed an enemy with fire
    if area.is_in_group("enemies"):
        area.emit_signal("fired")
        queue_free()

func _on_Timer_timeout():
    """
    Called once the fireball's Timer runs out.
    """
    queue_free()

func _on_AnimationTimer_timeout():
    """
    Called when it's time to switch to the next animation frame
    """
    $Sprite.frame = ($Sprite.frame + 1) % max_frames
