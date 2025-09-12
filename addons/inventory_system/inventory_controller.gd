extends Node

@export var item_repository : ItemRepository
@export var view : Control
@export var weight_limit : float

signal enter_over_encumbered
signal exit_over_encumbered

signal equip_item(item:Item)
signal use_item(item:Item)

var over_encumbered : bool = false
var weight : float 

var active_item

func _ready() -> void:
	view.ready.connect(on_view_ready)

func on_view_ready() -> void:
	view.connect_to_pick_up_item_pressed(on_pick_up_item_pressed)
	view.connect_to_equip_item_pressed(on_equip_item_pressed)
	view.connect_to_drop_item_pressed(on_drop_item_pressed)
	view.connect_to_use_item_pressed(on_use_item_pressed)
	view.connect_to_item_selected(on_item_selected)
	
	view.disable_item_actions()
	
	init_item_list()

func on_pick_up_item_pressed() -> void:
	pick_up(item_repository.get_item_by_database_index(0))
	refresh_item_list()

func refresh_item_list() -> void:
	view.item_list.clear()
	init_item_list()

func on_item_selected(list_index)-> void:
	var in_scope_variables := {
		"new_label" : "Selected Item: ",
		"item_linked_list_index": 0
	}
	var to_conditional: Callable = func(node):
		var stop: bool = in_scope_variables.item_linked_list_index == list_index
		in_scope_variables.item_linked_list_index += 1
		return stop
	
	var execute: Callable = func(node):
		var item = item_repository.get_item_by_database_index(node.database_index)
		in_scope_variables.new_label += item.label
		set_inventory_actions(item)
		
		active_item = node

	item_repository.item_database_indices.iterate_to(to_conditional, execute)
	view.selected_item_label.text = in_scope_variables.new_label
	
func on_use_item_pressed() -> void:
	var item = get_active_item()
	var last_used_label = "Last Item Used: " + str(item.label)
	view.set_last_item_used_label(last_used_label)
	use(active_item.database_index)
	on_drop_item_pressed()
	
func set_inventory_actions(item: Item) -> void:
	view.equip_item.disabled = not item.can_equip
	view.use_item.disabled = not item.can_use
	view.drop_item.disabled = false
	

func init_item_list() -> void:
	weight = 0.0
	var items = get_all_items()
	var item_label : String
	for item in items:
		item_label = "item: "+ item.label + " quantity: " + str(item.quantity) + " weight: " + str(item.weight * item.quantity)
		view.add_item_to_list(item_label)
		weight += (item.weight * item.quantity)
	var weight_label = "Inventory Weight: "+ str(weight)
	view.set_inventory_weight_label(weight_label)
	view.disable_item_actions()

func get_active_item() -> Item:
	var item : Item = item_repository.get_item_by_database_index(active_item.database_index)
	return item

func on_equip_item_pressed() -> void:
	var item = get_active_item()
	view.set_equiped_item_label(str(item.label))
	equip(active_item.database_index)

func on_drop_item_pressed() -> void:
	var item = get_active_item()
	active_item = null
	drop(item)
	print_debug("drop item pressed")
	view.item_list.clear()
	var selected_label = "Selected Item: "
	view.set_selected_item_label(selected_label)
	view.drop_item.disabled = true
	init_item_list()

func get_all_items():
	return item_repository.get_all_items()

func pick_up(item)->void:
	if fits(item):
		accept(item)
	else:
		reject(item)
	
func fits(item) -> bool:
	return true
	
func accept(item)->void:
	weight += item.weight
	item_repository.add_item_database_index(item.database_index)
	check_and_emit_encumberence()

func reject(item)->void:
	pass

func drop(item)->void:
	item_repository.remove_item_by_database_index(item.database_index)
	weight -= item.weight
	#check_and_emit_encumberence()

func use(item_database_index)->void:
	var item = item_repository.get_item_by_database_index(item_database_index)
	emit_signal("use_item", item)

	item.use()
	weight -= item.weight
	check_and_emit_encumberence()
	
func equip(item_database_index)->void:
	var item = item_repository.get_item_by_database_index(item_database_index)
	emit_signal("equip_item", item)
	item.equip()
	
func examine(item_database_index)->void:
	var item = item_repository.get_item_by_database_index(item_database_index)
	
func is_over_encumbered()->bool:
	return (weight >= weight_limit)

func check_and_emit_encumberence() -> void:
	if not over_encumbered and is_over_encumbered():
		emit_enter_over_encumbered()
		over_encumbered = true
		return
	if over_encumbered and not is_over_encumbered():
		over_encumbered = false
		emit_exit_over_encumbered()
		return

func emit_enter_over_encumbered()->void:
	emit_signal("enter_over_encumbered")

func emit_exit_over_encumbered()->void:
	emit_signal("exit_over_encumbered")
