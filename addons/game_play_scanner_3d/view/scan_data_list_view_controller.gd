extends Control

@export var entry_list: ItemList
@export var scan_data_repo: Node

@export var selected_entry_label: Label
@export var selected_entry_data: Label

func _ready() -> void:
	entry_list.item_selected.connect(_on_entry_list_item_selected)

func _on_entry_list_item_selected(index) -> void:
	var selected_entry = scan_data_repo.get_scan_entry(index)
	_set_selected_entry(selected_entry)

func _set_selected_entry(entry)-> void:
	selected_entry_label.text = entry.label
	selected_entry_data.text = entry.data

func init_entry_list()->void:
	var scan_data_entries: Array = scan_data_repo.get_all_scan_entries()
	var length: int = scan_data_entries.size()
	var index: int = 0
	var data

	while index < length:
		data = scan_data_entries[index]
		entry_list.add_item(data.label)
		++index
