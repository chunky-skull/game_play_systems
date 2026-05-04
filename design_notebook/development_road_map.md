# Development Road Map

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

Done = I can tell when I can scan a specific item. I can scan the item, and when I do, a new recipe is added to my crafting recipe book.

1. create a component that connects to the database component and specifically access the crafting recipe book table.
2. create a scanner component:
   1. 

## In Game Interactions

Done = When I can press the interaction key, have a test interactive message appear, and

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

4. The game component connects:
   
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

## Opening Locked Doors

Done =
