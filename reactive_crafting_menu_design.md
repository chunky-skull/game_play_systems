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



Player component:

- character component:
  
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
