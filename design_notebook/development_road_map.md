# Development Road Map

Rather than start with character movement or level building, I could test out must of the systems described above with 2D menus.

How?

1. Set up a connection to a database, SQLite

2. Set up a database and table naming convention that uses a unique prefix. Starting a new game file generates this prefix.

### Inventory

Done = I can: pick up and item; potential get a warning if the item over encumbers the character; add that item to the character's inventory; open the character's inventory menu; "use," "equip," and drop an item from the inventory; And save and load the inventory's data.

1. Write a script that connects to the database and creates character, inventory, and ludo_item tables.

2. Write a script that holds the in game data for the character's inventory, i.e. a linked list.

3. create a button that represents an item being picked up and potentially added to inventory.

4. Check if the item can fit into the "player's" inventory.
   
   1. add reject functionality
   
   2. add accept functionality that adds the item to the linked list

5. Create a UI for the inventory that lists items within the inventory and with buttons to use, view, equip, and drop items.

6. Write a script that gives those buttons the relevant functionality.

7. Write a script that saves the linked list's data to the SQLite's inventory table.

8. Write a script that loads the SQLite's inventory table data to the linked list.

9. Connect step seven's and eight's scripts to buttons

### Crafting

Done = when I open the crafting menu, it shows me which recipes I have the ingredients to make; When I execute a recipe, I gain the recipe's output in character's inventory and the relevant ingredients are removed from the character's inventory.

### Saving and Loading

Done =

### Opening Locked Doors

Done =
