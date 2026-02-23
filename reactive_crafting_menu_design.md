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

To implement this I would need to change how reactive data works. Rather than the parent data being broadcast with each change, I would need to it up to broadcast the child data affected by the change. This functionality should be specific to how the character's inventory works. This system could also work for quest and progression items.  ⭐
