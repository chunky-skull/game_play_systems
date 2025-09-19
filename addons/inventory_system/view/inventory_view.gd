extends Control

@export var item_list: ItemList

@export_category("Item Label")
@export var inventory_weight_label : Label
@export var last_item_used_label: Label
@export var selected_item_label: Label
@export var equiped_label: Label 

@export_category("Item Action")
@export var pick_up_item: Button
@export var equip_item: Button
@export var drop_item: Button
@export var use_item: Button

func _ready() -> void:
	pass

func set_equiped_item_label(new_label: String) -> void:
	equiped_label.text = new_label
	
func set_selected_item_label(new_label: String)-> void:
	selected_item_label.text = new_label
	
func connect_to_pick_up_item_pressed(pick_up_item_pressed: Callable)->void:
	pick_up_item.pressed.connect(pick_up_item_pressed)
	
func connect_to_drop_item_pressed(on_drop_item_pressed: Callable)->void:
	drop_item.pressed.connect(on_drop_item_pressed)
	
func connect_to_item_selected(on_item_selected: Callable)->void:
	item_list.item_selected.connect(on_item_selected)
	
func connect_to_use_item_pressed(on_use_item_pressed: Callable) -> void:
	use_item.pressed.connect(on_use_item_pressed)

func connect_to_equip_item_pressed(on_equip_item_pressed: Callable) -> void:
	equip_item.pressed.connect(on_equip_item_pressed)

func set_last_item_used_label(new_label) -> void:
	last_item_used_label.text = new_label

func add_item_to_list(item_label) -> void:
	item_list.add_item(item_label)

func set_inventory_weight_label(new_label) -> void:
	inventory_weight_label.text = new_label
	
func disable_item_actions() -> void:
	equip_item.disabled = true
	drop_item.disabled = true
	use_item.disabled = true
