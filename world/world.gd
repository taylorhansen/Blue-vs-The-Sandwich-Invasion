extends Node

export(int) var POINTS_PER_SANDWICH = 25

var score = 0
var lives = 3

func _ready():
    _update_score()
    _update_wave()
    _update_lives()

func _on_Player_hit():
    """
    Called when the player is hit and loses a life.
    """
    lives -= 1
    _update_lives()
    $Screen.shake()
    if lives <= 0:
        # game over sequence
        _game_over()

func _on_Sandwich_fired():
    """
    Called when a Sandwich enemy is "fired" or killed.
    """
    # increment score
    score += POINTS_PER_SANDWICH
    
    # update score label
    _update_score()

func _on_Quit_pressed():
    """
    Called when clicking the Quit button.
    """
    get_tree().change_scene("res://main-menu/MainMenu.tscn")
    get_tree().paused = false

func _on_Restart_pressed():
    """
    Called when clicking the restart button.
    """
    get_tree().change_scene("res://world/World.tscn")
    get_tree().paused = false

func _game_over():
    """
    Initiates the game over sequence.
    """
    $GameOver.popup_centered()
    get_tree().paused = true
    
    # accumulate saved score
    global.points += score
    global.save_data()

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
