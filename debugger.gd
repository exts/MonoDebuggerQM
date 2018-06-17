tool
extends EditorPlugin

# Popup Menu
var menu_button
var menu_popup

# Setting Constants
const WAIT_FOR_DEBUGGER = "mono/debugger_agent/wait_for_debugger"

func _enter_tree():
    menu_button = MenuButton.new()
    menu_button.text = "Debugger"
    
    menu_popup = menu_button.get_popup()
    menu_popup.hide_on_item_selection = false
    menu_popup.hide_on_state_item_selection = false
    menu_popup.hide_on_checkable_item_selection = false
    menu_popup.add_check_item("Wait for debugger", 1)
    menu_popup.connect("id_pressed", self, "debugger_menu_id_pressed")
    menu_button.connect("about_to_show", self, "debugger_menu_about_to_show")
    
    add_control_to_container(CONTAINER_TOOLBAR, menu_button)
    
func _exit_tree():
    menu_button.free()

func debugger_menu_about_to_show():
    var wfd_checked = get_setting(WAIT_FOR_DEBUGGER)
    menu_popup.set_item_checked(0, wfd_checked)

func debugger_menu_id_pressed(id):
    match id:
        1:
            var checked = menu_popup.is_item_checked(id-1)
            menu_popup.set_item_checked(id-1, !checked)
            set_setting(WAIT_FOR_DEBUGGER, !checked)

func get_setting(setting):
    if not ProjectSettings.has_setting(setting):
        print("Setting doesn't exist: ", setting)
        return null
    return ProjectSettings.get_setting(setting)

func set_setting(setting, value):
    if not ProjectSettings.has_setting(setting):
        print("Setting doesn't exist: ", setting)
        return
    
    ProjectSettings.set(setting, value)
    ProjectSettings.save()