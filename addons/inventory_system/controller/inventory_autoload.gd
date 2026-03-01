class_name InventoryAutoload
extends Node

#refactor so that this can become an singleton
@export var item_repo: GamePlayItem3DLinkedList 
@export var weight_limit: float

signal enter_over_encumbered
signal exit_over_encumbered

signal equip_item(item:Item)
signal use_item(item:Item)

signal item_added(item:Item)
signal item_removed(item:Item)

signal ingredient_added(item:Item)
signal ingredient_removed(item:Item)

var over_encumbered : bool = false
var weight : float 

func _ready() -> void:
	pass

func get_all_items():
	return item_repo.get_all_items()

func pick_up(item)->void:
	if fits(item):
		accept(item)
	else:
		reject(item)
	
func fits(item) -> bool:
	return true
	
func accept(item)->void:
	add_item(item)
	weight += item.weight
	check_and_emit_encumberence()

func add_item(item)->void:
	var slot = item_repo.append_item(item)
	if is_ingredient(item):
		#figure out how to get rid of this condition
		#maybe something like emit_signal(item.type+"_added", item)
		ingredient_added.emit(slot)
	else:
		emit_signal("item_added", item)

func is_ingredient(item)->bool:
	return item.type == "ingredient"
	
func reject(item)->void:
	var rejection_message: String = "Inventory full"
	drop(item)
	print_debug(rejection_message)
	# gives player a rejected item message

func drop(item)->void:
	remove_item(item)
	weight -= item.weight
	check_and_emit_encumberence()
	# instantiates removed it in game play world

func remove_item(item)->void:
	item_repo.remove_by_item(item)
	if is_ingredient(item):
		emit_signal("ingredient_removed", item)
	else:
		emit_signal("item_removed", item)

func use(item_database_index)->void:
	var item = item_repo.get_by_index(item_database_index)
	emit_signal("use_item", item)

	weight -= item.weight
	check_and_emit_encumberence()
	
func equip(item_database_index)->void:
	var item = item_repo.get_by_index(item_database_index)
	emit_signal("equip_item", item)
	item.equip()
	
func examine(item_database_index)->void:
	var item = item_repo.get_by_index(item_database_index)
	
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
