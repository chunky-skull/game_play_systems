**Crafting menu changes.**

It gets new recipes added as the character finds them during play.

**Crafting recipes don't change.**

**The character's inventory changes**

As the character finds and uses crafting ingredients.



how do I connect the ingredients required in a crafting recipe to the ingredients in the character's inventory? Every time the inventory is updated, added to or taken from, the game checks if the item is an ingredient. If so, it iterates through all the available crafting recipes' ingredients and enables or disables recipes as needed. that's at least a loop nested with in a loop... not great. 

another option is to avoid disabling or enabling a recipe. instead checking the inventory and against a selected recipe's requirements when the player tries to craft it. but that just seems like a poor user interface that could lead to a poor user experience. 


