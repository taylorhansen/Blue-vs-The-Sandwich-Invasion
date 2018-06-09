extends Camera2D

# initial shake intensity
const INTENSITY = 10

# rate at which to decay the screen shake intensity
const SHAKE_DECAY = 1

# screen shake intensity
var _screen_shake = 0

func shake():
    """
    Shakes the screen.
    """
    _screen_shake = INTENSITY
    
    # start shaking
    $Timer.start()

func _on_Timer_timeout():
    """
    Called every time the timer times out.
    """
    if _screen_shake > 0:
        # give the camera a new random offset of varying intensity
        offset = _screen_shake * Vector2(rand_range(-2, 2), rand_range(-2, 2))
        
        # decay the screen shake effect by a fixed rate
        _screen_shake -= SHAKE_DECAY
    
    elif _screen_shake < 0:
        # reset everything
        _screen_shake = 0
        $Timer.stop()
        offset = Vector2()
