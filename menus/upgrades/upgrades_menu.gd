extends Panel

# points cost for the dash ability
const DASH_COST = 500

func _ready():
    _update_buttons()
    _update_points()

func _on_BuyDash_pressed():
    """
    Called when buying the dash ability.
    """
    if not global.is_unlocked("dash") and global.points >= DASH_COST:
        # able to buy the upgrade
        global.points -= DASH_COST
        _update_points()
        global.unlock("dash")
        global.save_data()
        $VBoxContainer/DashContainer/BuyDash.disabled = true

func _on_Back_pressed():
    """
    Called when the back button is pressed.
    """
    get_tree().change_scene("res://menus/main/MainMenu.tscn")

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

func _update_buttons():
    """
    Updates the functionality of upgrade buttons based on what's already been
    purchased.
    """
    if global.is_unlocked("dash"):
        var button = $VBoxContainer/DashContainer/BuyDash
        button.disabled = true
        button.text = "Dash (bought)"

func _update_points():
    """
    Updates the points label.
    """
    $Points.text = "Points: " + str(global.points)
