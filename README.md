A two-person game is played with a set of identical stones arranged into a number of heaps. There may be any number of stones and any number of heaps. A move in this game consists of either removing any number of stones from one heap, or removing an equal number of stones from each of two heaps. The loser of this game is the player who picks up the last stone.
For example with three heaps, of sizes 3, 2, and 1, there are ten possible moves, leading to these states (where we use the obvious representation of game states in Prolog as a list of the sizes of the heaps):

Taking from the first heap only: [2,2,1], [1,2,1], [2,1] \
Taking from the second heap only: [3,1,1], [3,1] \
Taking from the third heap only: [3,2]\
Taking from the first and second heaps: [2,1,1], [1,1] \
Taking from the first and third heaps: [2,2]\
Taking from the second and third heaps: [3,1] \
[3,1] occurs twice because there are two different ways of reaching it in one move.
