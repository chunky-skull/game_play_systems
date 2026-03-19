**Crafting menu changes.**

It gets new recipes added as the character finds them during play.

**Crafting recipes don't change.**

**The character's inventory changes**

As the character finds and uses crafting ingredients.

how do I connect the ingredients required in a crafting recipe to the ingredients in the character's inventory? Every time the inventory is updated, added to or taken from, the game checks if the item is an ingredient. If so, it iterates through all the available crafting recipes' ingredients and enables or disables recipes as needed. that's at least a loop nested with in a loop... not great. 

another option is to avoid disabling or enabling a recipe. instead checking the inventory and against a selected recipe's requirements when the player tries to craft it. but that just seems like a poor user interface that could lead to a poor user experience. 

I wish I could look at the code for games like Subnautica and Tainted Grail to see how they handle enabling crafting recipes while having such a large number of different crafting ingredients. Do they have nested loops like I do, or do they implement a cleverer system? 

How can I avoid the nested loops? Let's think about the situation I have now:

1. The character activates a crafting table.

2. The crafting table loops through the character's inventory.
   
   1. If the inventory item is a crafting ingredient, the crafting table loops through all the crafting recipes. 
      
      1. The crafting table loops through each recipe's ingredient list
      
      2. If the inventory ingredient matches an item in a recipe's ingredient list:
         
         1. If the ingredient amount is greater than the recipe's requirements, the recipe's availability is set to true.
         
         2. if the not, the recipe's availability is set to false.

I should look at the code I have already for this system. 

I was hoping that setting up the reactive data type would help get rid of some of this crafting menu loops. It can. At least the first loop. Maybe I can set up the inventory to broadcast when an item is added to it. In that broadcast, I can include the new item and its current amount. The crafting menu then loop through the crafting recipes and their ingredient lists. This would eliminate the first loop were it goes through each item in character's inventory. 

⭐Could I take it further? Maybe each crafting recipe subscribes to the inventory. When the inventory is changed, each recipe checks to see if the change is relevant to them. If it is, each recipe checks to see if it is available to the character. So:

1. inventory broadcasts a change.

2. crafting recipe checks if the change involved a crafting ingredient.

3. If it did, the crafting recipe loops through its ingredient list to check if it includes the involved ingredient.

4. If it does, the recipe checks if the change allows the character to use the recipe.

That is one loop with no nested loops. However, it is one loop that each crafting recipe does at the same time. I don't know the performance cost for that would be.  I would imaging slightly better than loops that are nested three levels deep.

To implement this I would need to change how reactive data works. Rather than the parent data being broadcast with each change, I would need to it up to broadcast the child data affected by the change. This functionality should be specific to how the character's inventory works. This system could also work for quest and progression items.  

Maybe I don need to change the implementation of the reactive data, but instead I can simply write the inventory to have this functionality. So the inventory emits a "item_subtracted" and "item_added" signal. Quest trackers and crafting menus connect to the signal with logic that decides what to do with the added or subtracted item. I am no longer certain that the reactive data type is needed for this use case. 

⭐

~~To make the above described system work, I need to make the inventory data and controller an auto-loaded singleton. The problem is how to I keep this singleton from becoming a giant file. Also I like being able to create items and set up variables in the editor. I clearly need to learn more about what I can do with a singleton in Godot.~~

~~The Inventory Item Linked List is an auto-loaded singleton. This is where the data about the items in the character's inventory is stored.  The crafting recipe list is also an auto-loaded singleton. That way I don't need to re-enable the recipes list every time the character enters a new scene.~~

~~There is the database, SQLite. Scripts get data from the db. In the case of the inventory system and the crafting system, how does the crafting menu connect each crafting recipe to the inventory's "ingredient_added/removed" signals?~~

the inventory component has: 

- the item_repository, a linked list that extends resource and uses a slot datatype to store an item's data and count. 
  
  - The item_repository stores the item data that the character has in inventory; 

- an exported property for an encumbrance limit; 

- methods for using, dropping, adding, examining, and equipping items; 

- signals for item_add/removed that provides the effected item_repository slot

- entering/leaving_over_encumbrance signals

The crafting component has: 

- the recipe_repository that extends resource and has an array of recipes that are available to the character; 
  
  - a recipe is a resource that has:
    
    - an output item
    
    - an ingredient array of dictionaries that have item id's or labels, an integer "amount" field, a Boolean "available" field
    
    - an "enabled" Boolean property
    
    - a set_enabled_by_ingredient method takes an item id or label, and an amount as arguments. it loops through the ingredient list, checks if the item matches with an ingredient, sets that ingredient's "available" field if the amount > than an ingredient's amount, and finally it set's the recipe's "enabled" property based on the ingredients' "available" fields.

- a property for a selected recipe; 

- a method for adding recipes to the recipe_repository; 

- a "use_recipe" and signal that provides a selected recipe; 

- a "recipe_added" signal that provides the new recipe.

I need some sort of "glue" script:

- that connects to the crafting component's "recipe_added" signal. 
  
  - when that signal emits, the scripts connects its own "ingredient_added/removed" signals to the recipe's set_enabled_by_ingredient method

- connects the inventory's "item_added/removed" signal
  
  - when that signal emits, the script checks if the item has the "ingredient" type and emits its ingredient_added/removed signals. 

- connects the crafting component's use_recipe signal with the inventory's add_items and remove_items methods.

<u>How does this script have access to both the inventory and crafting components?</u> 

let's just start throwing stuff at the wall. Maybe I can set up some "higher level glue," as Jonas calls it, to connect the these components. Something like an "item manager" that is an auto-loaded singleton.

Or the inventory and crafting components can be auto-loaded singletons. The "glue" script just connects the two. 
I was also thinking I could  make the script attached to the character script somehow. It sounds correct that the character script would have access to at least the inventory script. Though, as I think about it, I am not so sure. The player access the menu through a button, not by making the character preform some sort of action.

Maybe the script attaches to the player's script. The player will need to have the ability to open the inventory menu and the crafting menu. But thinking again reveals that the player script will only need the ability to open those menus. The menus themselves will have the ability to handle the player's interactions.

So far the only functional options seems to be to work with some sort of singleton. I am trying to avoid that. Not sure why...

What part of the game has access to both the inventory and crafting components?

The more I think about it, the more it makes sense to have the player component own the inventory and crafting components. The player would have all the components that relate to game play.

Player component: has the "glue" script that connects all the sub components together

- character component: has the "glue" script that connects all the sub components together
  
  - movement component
  
  - battle component
  
  - corpus component
  
  - equipped component

- crafting component

- inventory component

- quest component

- ludo environment scanner component

- ludo map component

- journal component

- bestiary component

- input component

- - save inventory
  
  - save crafting recipe book
  
  - save bestiary
  
  - save character attributes

The player component is it's own scene, and a child scene of the level the player is in. 

Where does the crafting component's recipe repository get its recipes from? Should the recipe repository be an auto-loaded singleton? And should the inventory's item repository be one also?

I could avoid that by figuring out how to pass a resource from one to scene to another.

~~How about a "PlayerSpawnPoint" node for each "level's" scene. every "level" scene has this node. When transitioning between levels, the Player node is set as a child of the PlayerSpawnPoint. 
So the player node only moves throughout a level while in the spawn point node?~~

## Relational Database Structure

### Inventory

If I was to use a relational database like SQLite, the relationship between the character and the their inventory would be many to many:

character table:

- character id

inventory slot table:

- owner id = character id, or store id, or loot box id

- ludo item id

- ludo item count

ludo item:

- ludo item id
- etc

The reason this is not a one-to-many relationship is even with single player games, there are things like shops that have inventories, and loot chest that have contents.

### Dialogue

Dialogue is a one-to-many relationship. Only one NPC can have the same Dialogue tree. Ah, but what about a the actual dialogue options in the tree? Each option can have many dialogue branches. So it's a one-to-many relationship.

Every dialogue option has one dialogue response. Each dialogue response can have multiple options. 

Dialogue tree:

- dialogue node id

- parent dialogue node id

- dialogue option text

- ~~dialogue text id = is this another dialogue tree node, or a whole separate database?  better to just make the text apart of the node? while the same dialogue response can be accessed multiple times, the dialogue option to get that response shouldn't change.~~

- dialogue response text: All the options for this response will have this node's dialogue node id as their parent node id

NPC:

- NPC id

- Dialogue tree id = the dialogue node that has a "null" parent dialogue node id field.

How do I keep track of expended dialogue options?

### Bestiary

Okay, so how about the bestiary and its entries? It's a one-to-many relationship, where there is only one "one.'' So really just a database table with no relational id's. But how would I mark which entries are in the player's bestiary? a Boolean value on each row? Or do I have the game add entries as the player plays? I don't like that because then the data is scattered throughout the game.  

bestiary:

- entry id

- description

- model path or filename

- visible = Boolean value that indicates if the entry is in the player's bestiary

How about crafting recipes? similar to the inventory. While the majority of them will be in the player's recipe book, there will be some that other game entities will own. The game will use it's own logic to determine if a recipe is available to make for the player.

~~crafting menu: A join table that connects a game entity with their crafting recipes~~

- ~~owner id~~

- ~~recipe id~~

crafting recipe book:

- recipe id

- output item id

- recipe label

- recipe description

- visible = Boolean value that indicates if the recipe is in the player's recipe book

ludo item:

- ludo item id
- etc

ingredient: A join table that connects ingredients with recipes

- ingredient id

- ludo item id

- recipe id

## Save Game

Rather than having to make database calls each time the player's inventory, crafting menu, or bestiary changes, I can have those changes committed to the database when the player's game is saved. The game gets all of the player's data when the game loads.

I could set up the save-game component to simply commit the player's data to the database. Then I could easily set up "glue" scripts for the functionality the game design requires. If the game needs to have save at checkpoints, the checkpoint scripts uses the save-game component. If it needs to save between levels, the level transition script or component uses the save-game component.

Save-game component:

- database component

- needs access to:
  
  - inventory component's database update query
  
  - crafting recipe book component's database update query
  
  - character corpus (or attributes) component's database update query
  
  - bestiary component's database update query

How do decouple the save-game component from needing to know the specifics of each relevant database? Maybe each relevant component has a piece of its own database update/save calls? Better, there is a specific save component for each relevant component. So for the inventory database there is an inventory save component. For the bestiary database there is a bestiary save component. The same goes for loading. 

The save component can also check if a specific save component needs to be called at all.

Save-game component:

- inventory save component

- bestiary save component

- crafting recipe book save component

- character attributes save component

There will also be higher level save-game component that handles saving the game world. It would be structured similarly.

Save game world component ( come up with a better name ):

- save enemies

- save NPCs. These will work with groups to save all the like entities at once

- save loot placement

The loading component is nearly a mirror of this structure. One difference being that it does not need to check if something needs to be loaded. If it's child loading component, it gets loaded into the game. It would also need to reset the whole game to the point the player has loaded. So it may not be part of the player component, but part of the game component. 

### Pause menu

The pause menu input will be part of the player component's input component. The player component will have the journal, equipment, and inventory menu, aka the ludo menu. The game will have the pause menu component. The pause menu will handle saving, loading, options, and quit components.

When the player makes a pause menu, the player component emits a "pause" signal. The game will have a function that pauses the game and opens the pause menu connected to that signal.

### Interactive objects

An interactive object will work with the game and player components. It will work using the same pattern as the inventory and crafting components. The game will connect the player component's input component with the interactive object's interactive component. 

An interactive component will connect to a collision shape's "body_entered/exited" signals. It will check if the "body" is the player component and emit "player_entered/exited" signals. These signals return lambda functions that "activates" and "deactivates" the interactive component. On "player_entered" the game connects the activate function with the player's input component's "interact" signal. On "player_exited" the game calls the deactivate lambda and disconnects the interact signal from the activate function.

I should figure what to call the pattern of having a parent component connecting child component signals. 

I can cull enemies by using enemy spawn points.

### Generic and Specific Keys and Doors

How will keys, both generic and specific, work? I like Lunacid's approach: The player needs to equip the key in an item slot and use it when by a locked door. This avoids the need to loop there an inventory to ensure the player has a key.

I could also do something similar to crafting ingredients. There would be a helper or "glue" component that connects to the inventory's "item_added/removed" signals. This component checks if the item is a key. If so, it emits "generic_key_available" signal, and increments a generic_key_count variable. On "item_removed," The component checks if the item is a generic key and decrements the generic_key_count if so. If that variable equals zero, the component emits a "generic_key_unavailable" signal.

The map component or one of its child components, doors component most like, then sends something like an "unlock-able" signal to all the doors that unlock with generic keys on "generic_key_available." On "generic_key_unavailable," the doors component emits something like "locked." When the player opens a generic or specific door, in it's "unlock-able" state, the door's script disconnects from the doors component's "unlock-able" and "lock" signals. 

The helper component can also check if the added key is a specific key and send "specific_key_available" signals. This signals provides an door id. Specific keys can not be dropped. The component does not keep a count of specific keys available, and there is not "specific_key_unavailable" signal. 

This pattern adds a conditional to the inventory's "item_added/removed" signals. 

### Loot drops and placement

How will loot in chest and defeated enemies work
