# Development Road Map

Rather than start with character movement or level building, I could test out must of the systems described above with 2D menus.

How?

1. Set up a connection to a database, SQLite

2. Set up a database and table naming convention that uses a unique prefix. Starting a new game file generates this prefix.

## Set up

Done =

1. Create a player component that is its own scene

2. Create a character component that is a child of the player component

3. Create a game component that is its own scene

4. Instantiate the player component as a child of that scene

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

## In Game Interactions

Done =

An interactive object will work with the game and player components. It will work using the same pattern as the inventory and crafting components. The game will connect the player component's input component with the interactive object's interactive component.

An interactive component will connect to a collision shape's "body_entered/exited" signals. It will check if the "body" is the player component and emit "player_entered/exited" signals. These signals return lambda functions that "activates" and "deactivates" the interactive component. On "player_entered" the game connects the activate function with the player's input component's "interact" signal. On "player_exited" the game calls the deactivate lambda and disconnects the interact signal from the activate function.

I should figure what to call the pattern of having a parent component connecting child component signals.

1. Create the player's input component:
   
   1. Capture inputs.
   
   2. Check if input is the interact input.
   
   3. Emit "interact_input" signal.

2. Create an interactive component:
   
   1. Has multiple signals:
      
      1. character_entered which provides a lambda function that "activates" the component
      
      2. character_exited which provides a lambda function that "deactivates" the component
   
   2. has a collision shape child node
   
   3. connect the interactive component with the collision shape's "body_entered/exited" signal:
      
      1. check if the body is the character and emit "character_entered/exited" signals

3. Forward the input component's "interact_input" signal through the player componet.

4. connect the player component's "interact_input" with the 

## Dialogue

Done = I can navigate a dialogue tree by selecting from multiple answers. Reaching certain points in the tree and selecting a specific answer adds an item to the character's inventory. 

Dialogue is a one-to-many relationship. Only one NPC can have the same Dialogue tree. Ah, but what about a the actual dialogue options in the tree? Each option can have many dialogue branches. So it's a one-to-many relationship.

Every dialogue option has one dialogue response. Each dialogue response can have multiple options.

Dialogue tree:

- dialogue node id

- parent dialogue node id

- dialogue option text

- ~~dialogue text id = is this another dialogue tree node, or a whole separate database? better to just make the text apart of the node? while the same dialogue response can be accessed multiple times, the dialogue option to get that response shouldn't change.~~

- dialogue response text: All the options for this response will have this node's dialogue node id as their parent node id

NPC:

- NPC id

- Dialogue tree id = the dialogue node that has a "null" parent dialogue node id field.

How do I keep track of expended dialogue options?

## Quests/Missions

## Saving and Loading

Done =

## Opening Locked Doors

Done =
