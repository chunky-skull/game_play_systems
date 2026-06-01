# Development Road Map

This project implements the Mediator Pattern.

Rather than start with character movement or level building, I could test out must of the systems described above with 2D menus.

How?

1. Set up a connection to a database, SQLite.

2. Set up a database and table naming convention that uses a unique prefix. Starting a new game file generates this prefix.

## Set up

Done =

1. Create a player component that is its own scene.

2. Create a character component that is a child of the player component, and is its own scene.

3. Create a game component that is its own scene

4. Instantiate the player component as a child of the game component scene.

## Database access

Done =

## Inventory

Done = I can: pick up and item; potential get a warning if the item over encumbers the character; add that item to the character's inventory; open the character's inventory menu; "use," "equip," and drop an item from the inventory; And save and load the inventory's data.

1. make a database component that connects to the database.

2. Create a component that connect to the database component and creates character, inventory, and ludo_item tables.

3. Create the in-game component for a ludo_item that has:
   
   1. Label property
   
   2. Type property

4. Write a script that holds the in game data for the character's inventory, i.e. a linked list:
   
   1. Each node in the linked list will be a "slot." Each slot has:
      
      1. A "count" integer property.
      
      2. A "item" ludo_item property.
      
      3. A "next" slot property.

5. create a button that represents an item being picked up and potentially added to inventory. This button will need to
   
   1. Check if the item can fit into the "player's" inventory.
      
      1. add reject functionality
      
      2. add accept functionality that adds the item to the linked list

6. Create a UI for the inventory that lists items within the inventory and with buttons to use, view, equip, and drop items.

7. Write a script that gives those buttons the relevant functionality.

8. Write a script that saves the linked list's data to the SQLite's inventory table.

9. Write a script that loads the SQLite's inventory table data to the linked list.

10. Connect the two above steps' scripts to buttons

## Crafting

Dependencies: Inventory System

Done = when I open the crafting menu, it shows me which recipes I have the ingredients to make; When I execute a recipe, I gain the recipe's output in character's inventory and the relevant ingredients are removed from the character's inventory.

1. create a component that connects to the database component and creates crafting recipe and ingredient tables.

2. Create a recipe component that extends resource and has:
   
   1. An output item
   
   2. An ingredient array of dictionaries that have item id's or labels, an integer "amount" field, and a Boolean "available" field.
   
   3. An "enabled" Boolean property
   
   4. a set_enabled_by_ingredient method takes an item id or label, and an amount as arguments. it loops through the ingredient list, checks if the item matches with an ingredient, sets that ingredient's "available" field if the amount > than an ingredient's amount, and finally it set's the recipe's "enabled" property based on the ingredients' "available" fields.

3. Create a recipe_repository component that extends resource and stores all the crafting recipe data, the recipe repository.

4. Create a component that preforms all the functions for crafting:
   
   1. A property for a selected recipe.
   
   2. A method for adding recipes to the recipe_repository.
   
   3. A "use_recipe" signal that provides the selected recipe.
   
   4. A "recipe_added" signal that provides the new recipe.

5. create a "glue" component that connects the inventory's signals with the crafting component and vice versa: This "glue" component is the player component.
   
   1. Connects to the crafting component's "recipe_added" signal.
      
      1. When that signal emits, the scripts connects its own "ingredient_added/removed" signals to the recipe's set_enabled_by_ingredient method.
   
   2. Connects the inventory's "item_added/removed" signal.
      
      1. When that signal emits, the script checks if the item has the "ingredient" type and emits its ingredient_added/removed signals.
   
   3. Connects the crafting component's use_recipe signal with the inventory's add_items and remove_items methods

6. Create a UI that abstracts a player working with a crafting menu:
   
   1. Give it an element to show which crafting recipe a player has selected:
      
      1. Add a button that removes the required ingredients from the character's inventory and adds the recipe's outcome to the character's inventory
   
   2. A list of all crafting recipes:
      
      1. Give each recipe a button that allows the player to select the recipe.
      
      2. Disable the select button when the character does not have the ingredients to make the recipe.
      
      3. An indicator of which recipes the player can crafting given what's in their character's inventory.

## Scanning and Adding Recipes (Schemes) to Crafting Recipes

Dependencies: Crafting System, Inventory System, In Game Interaction System, Input Capture System

Done = I can tell when I can scan a specific item. I can scan the item, and when I do, a new recipe is added to my crafting recipe book.

1. create a component that connects to the database component and specifically accesses the crafting recipe book and the crafting menu tables.
2. Add "scan_input" to the input component:
   1. check if captured input is the scan input.
   2. Emit "scan_input" signal
3. create a scanner component:
   1. Give it an Area3D or CollisionShape3D child node.
   2. Give it a timer child node.
   3. Give it a "scan_complete" signal that returns the crafting recipe id of the item scanned.
   4. Give it a function that displays a scan complete message and emits the "scan_complete" signal.
   5. Connect the scanner component to the timer's "timeout" signal with a function that:
      1. Emits the "scan_complete" signal.
4. Create a scan-able in game object:
   1. Give it an in-game-interaction sub-component:
      1. Set up activate, deactivate, and CTA for a scan-able item:
         1. The activate function returns an array with the crafting recipe id and the scan_time init variable.
5. Create a scan component at the game level that has access to the player's scan component, input capture component, and the database component:
   1. on the scan components body_entered:
      1. A function that takes the "body_entered" signals activate lambda as an argument and adds a call to that lambda in a new lambda that it returns.
      2. this new lambda also sets the scan component's timer time, starts the scan component's timer, sets the scan-able item's in-game-interaction component's activate function to a blank lambda, and returns the scan-able item's crafting recipe id. 
      3. Call this function when the "scan_input" signal is emitted. This function connects the lambda it creates to the scan component's "scan_complete" signal.
   2. on the scan components body_exited:
      1. Set the "scanning" lambda to a lambda that does nothing.
      2. Set the scan component's timer to zero.
   3. Connect the player's scan component's "scan_complete" signal to database component's "create_entry" function and provide it arguments for adding an entry in the crafting menu table. 
6. Create a UI to test this functionality:
   1. Simulate a scan-able item:
      1. Give it an init "crafting_recipe_id" property with a test crafting recipe's id
      2. Give it an init "scan_time" property
      3. Attach the scan-able in game object to this UI
   2. Simulate the character and their scanner:
      1. Give the scan area a visible element. A BoxContainer should work
      2. Give character a BoxContainer.
      3. Show and hide the scan area when scan_input is pressed. 
      4. The scan area needs to able to pivot around the simulated character.
   3. Show a "Scan Successful" message when the scan component's timer finishes:
      1. If the scan area leaves the scan-able item, interrupt the scanner's timer with out showing the message. ALso set the scanner's timer to zero.
      2. ✨Do not allow the scanner to scan the same item twice✨

## In Game Interactions

Done = I can press the interaction key, and have a test interactive message appear.

1. Create the player's input component:
   
   1. Capture inputs.
   
   2. Check if input is the interact input.
   
   3. Emit "interact_input" signal.

2. Create an interactive component:
   
   1. Has multiple signals:
      
      1. character_entered which provides a lambda function that "activates" the component
      
      2. character_exited which provides a lambda function that "deactivates" the component
   
   2. has an Area3D child node
   
   3. connect the interactive component with the Area3D's "body_entered/exited" signal:
      
      1. check if the body is the character and emit "character_entered/exited" signals.
   
   4. Set up an init method that allows the the "activate" and "deactivate" to be defined for specific situations.

3. Forward the input component's "interact_input" signal through the player component.

4. The game component has a sub component that connects:
   
   1. the player component's "interact_input" with the interactive component's "character_entered" signal's product. This product is an "activate" method.
   
   2. To the interactive component's "character_exited" signal. When the signal is emitted:
      
      1. the game component calls the method the signal returns. 
      
      2. Disconnects the "activate" method from the player component's "interact_input" signal.

5. Create a UI that abstracts a player's interaction:
   
   1. A Simulation of interactive object:
      1. Has a simulation Area3D as a child node. 
      2. Has a simulation of a CTA. 
      3. Has a hidden "interaction made message" that appears when an interaction is made. 
   2. A button that simulates the character entering the interactive object's interaction zone.
   3. A button that simulates the character leaving the interactive object's interaction zone. 

## Dialogue

Dependencies: In Game Interaction System, Input Capture System

Done = I can navigate a dialogue tree by selecting from multiple answers. Reaching certain points in the tree and selecting a specific answer adds an item to the character's inventory. 

1. Create a component that connect to the database component that creates the dialogue tree table and NPC table.

2. Create an NPC component:
   
   1. Give this component an instance of the interactive object component.
   2. Set the interactive object component's "activate" function to open the dialogue UI component.

3. Create a dialogue ui component:
   
   1. Connects to the database component and gets the dialogue tree data by using the NPC's id. 
   
   2. connects the dialogue tree nodes and response to UI elements:
      
      1. Create a UI to simulate navigating a dialogue tree with an NPC:
         
         1. A simulation of an NPC
         
         2. A Text box for dialogue to appear.
         
         3. A set of buttons that represent the response options the player has:
            
            1. Each button has label that has the text for the for the response option.
            2. when pressed:
               1. the text in the dialogue text box when pressed.
               2. the current dialogue tree node's expended field is set to true.
         
         4. A button to initiate a dialogue tree with the simulated NPC.

## Quests/Missions

Done = 

## Bestiary

Done =

## Saving and Loading

Done =

## Doors and Locks

Dependencies: In Game Interactions System

Done =

### Generic Key Locks

Done = 

I could also do something similar to crafting ingredients. There would be a helper or "glue" component that connects to the inventory's "item_added/removed" signals. This component checks if the item is a key. If so, it emits "generic_key_available" signal, and increments a generic_key_count variable. On "item_removed," The component checks if the item is a generic key and decrements the generic_key_count if so. If that variable equals zero, the component emits a "generic_key_unavailable" signal.

The map component or one of its child components, doors component most like, then sends something like an "unlock-able" signal to all the doors that unlock with generic keys on "generic_key_available." On "generic_key_unavailable," the doors component emits something like "locked." When the player opens a generic or specific door, in it's "unlock-able" state, the door's script disconnects from the doors component's "unlock-able" and "lock" signals.

### Specific Key Locks

Done =

The helper component can also check if the added key is a specific key and send "specific_key_available" signals. This signals provides an door id. Specific keys can not be dropped. The component does not keep a count of specific keys available, and there is not "specific_key_unavailable" signal.

## Level/Map

Done = 

### Flora

Done = Moving through the map feels like exploring an actual place. The environment feels verdant, lush, and living without compromising the game's performance.  

### Item/Loot Placement

Done = There always seems like there is something to find when exploring. If I leave an item if position in the level persists through loads. Once I take the item, it will no longer be were I picked it up, even after reloading the map.

Some sort or relationship in the database. Like a many to many. For one map there are many items/loot, and most items are available on multiple maps. As part of the map's loading script, the "map_item" table and spawns in items based on the entry's data. When the player removes an item from the map, somewhere a script runs to remove that entry from the "map_item" table.

### Entity Placement

Done =

### Expository Notes

Dependencies: Item/Loot Placement System

Done =
