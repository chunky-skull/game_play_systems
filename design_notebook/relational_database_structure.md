# Relational Database Structure

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

So each dialogue node is a dialogue response option? That means each response option has the text for the NPC's response. That means that there's a possibility that multiple entries will have the same exact NPC response. Only if I make it so. I could make each response to an option the player selects unique. 

Dialogue tree:

- dialogue node id

- parent dialogue node id

- dialogue option text

- ~~dialogue text id = is this another dialogue tree node, or a whole separate database? better to just make the text apart of the node? while the same dialogue response can be accessed multiple times, the dialogue option to get that response shouldn't change.~~

- dialogue response text: All the options for this response will have this node's dialogue node id as their parent node id. 

- expended - a Boolean value the represents if the player has already selected this node option. 

NPC:

- NPC id

- Dialogue tree id = the dialogue node that has a "null" parent dialogue node id field.

✨How do I keep track of expended dialogue options?✨ A Boolean field in each dialogue tree node entry?

~~Also, how do I make it so the player receives and item or quest when they go through a particular path through a dialogue tree? Maybe when the player reaches the terminal node in the dialogue tree, a bit of code checks if the player should receive something? That feels like I need to add more boolean fields, and therefore more conditions. Not ideal.~~ 

~~What about making a quest or item have a dialogue node id field. When a dialogue node is activated, a bit code checks makes a request to the database component to check if the quest or reward item tables have an entry that has a matching dialogue node id. Better, but I don't like that the code would need to make a database request for each dialogue option selected. Maybe I can flip this so that the dialogue node has an item and quest id. The code checks these fields and if they are not null, makes a request to the database component to get the corresponding entry.~~ 

✨The dialogue tree table would not keep track of which NPC gives quest or items. Instead that would be a special kind of NPC. Something like a join table that has an NPC's id, the quest's id, and potential and item's id.✨

Maybe I should make a this tree a specific datatype in game. Like a Doubly Linked List, or even a node tree. 

### Bestiary

Okay, so how about the bestiary and its entries? It's a one-to-many relationship, where there is only one "one.'' So really just a database table with no relational id's. But how would I mark which entries are in the player's bestiary? a Boolean value on each row? Or do I have the game add entries as the player plays? I don't like that because then the data is scattered throughout the game.

bestiary:

- entry id

- description

- model path or filename

- visible = Boolean value that indicates if the entry is in the player's bestiary

## Crafting

How about crafting recipes? similar to the inventory. While the majority of them will be in the player's recipe book, there will be some that other game entities will own. The game will use it's own logic to determine if a recipe is available to make for the player.

crafting menu: A join table that connects a game entity with their crafting recipes

- owner id

- recipe id

crafting recipe:

- recipe id

- output item id

- recipe label

- recipe description

- ~~visible = Boolean value that indicates if the recipe is in the player's recipe book~~

ludo item:s

- ludo item id
- etc

ingredient: A join table that connects ingredients with recipes

- ingredient id

- ludo item id

- recipe id
