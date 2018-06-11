extends Node

# sounds
const PLAYER_DEATH = preload("res://sounds/Death.wav")
const PLAYER_HIT = preload("res://sounds/Hit_Hurt.wav")
const ENEMY_HIT = [
    preload("res://sounds/EnemyHit1.wav"),
    preload("res://sounds/EnemyHit2.wav"),
    preload("res://sounds/EnemyHit3.wav")
]

export(int) var POINTS_PER_SANDWICH = 25

var score = 0
var lives = 3

func _ready():
    _update_score()
    _update_wave()
    _update_lives()

func _input(event):
    # only process pause if we're not at the game over screen
    if event.is_action_pressed("pause") and not $GameOver.visible:
        _pause()

func _on_Player_hit():
    """
    Called when the player is hit and loses a life.
    """
    lives -= 1
    _update_lives()
    $Screen.shake()
    if lives <= 0:
        # play death sound
        $PlayerHit.stream = PLAYER_DEATH
        
        # game over sequence
        _game_over()
    else:
        # just play the regular hit sound
        $PlayerHit.stream = PLAYER_HIT
    
    $PlayerHit.play()

func _on_Sandwich_fired():
    """
    Called when a Sandwich enemy is "fired" or killed.
    """
    # increment score
    score += POINTS_PER_SANDWICH
    
    # update score label
    _update_score()
    
    # play a random enemy hit sound
    $EnemyHit.stream = ENEMY_HIT[randi() % ENEMY_HIT.size()]
    $EnemyHit.play()

func _on_Quit_pressed():
    """
    Called when clicking the Quit button.
    """
    get_tree().change_scene("res://menus/main/MainMenu.tscn")
    get_tree().paused = false

func _on_Restart_pressed():
    """
    Called when clicking the restart button.
    """
    get_tree().change_scene("res://world/World.tscn")
    get_tree().paused = false

func _play_select():
    """
    Called when a button is clicked.
    """
    global.play_select()

func _play_hover():
    """
    Called when a button is hovered over.
    """
    global.play_hover()

func _game_over():
    """
    Initiates the game over sequence.
    """
    $Player.queue_free()
    $GameOver.popup_centered()
    get_tree().paused = true
    
    # accumulate saved score
    global.points += score
    global.save_data()

func _pause():
    """
    Initiates the pause/unpause sequence.
    """
    if $PauseMenu.visible:
        # unpause
        $PauseMenu.hide()
        get_tree().paused = false
    else:
        # pause
        $PauseMenu.popup_centered()
        get_tree().paused = true

func _update_score():
    """
    Updates the score indicator in the HUD.
    """
    $HUD/TopPanel/Score.text = "Score: " + str(score)

func _update_wave():
    """
    Updates the wave indicator in the HUD. Called when the current wave is
    changed in the Enemies node.
    """
    $HUD/TopPanel/Wave.text = "Wave: " + str($Enemies.wave)

func _update_lives():
    """
    Updates the life indicator in the HUD.
    """
    $HUD/Lives/LifeCounter.text = str(lives)
