/*
 __    __     ______     ______     __  __        _____     ______     ______   ______    
/\ "-./  \   /\  __ \   /\  ___\   /\ \/ /       /\  __-.  /\  __ \   /\__  _\ /\  __ \   
\ \ \-./\ \  \ \ \/\ \  \ \ \____  \ \  _"-.     \ \ \/\ \ \ \  __ \  \/_/\ \/ \ \  __ \  
 \ \_\ \ \_\  \ \_____\  \ \_____\  \ \_\ \_\     \ \____-  \ \_\ \_\    \ \_\  \ \_\ \_\ 
  \/_/  \/_/   \/_____/   \/_____/   \/_/\/_/      \/____/   \/_/\/_/     \/_/   \/_/\/_/ 
                                                                                          
*/

// (!) Use this only for testing purposes. Move the puzzle data elsewhere (JSON file, CSV or any other data holder format)
// As you can see a puzzle is shaped as a matrix of rows and columns, where 1 represents a filled cell and 0 an empty one



// These examples are all puzzles taken from Picross S (Available for Switch console). They are all used ONLY for the sake of examples
// https://gamefaqs.gamespot.com/switch/222470-picross-s/faqs/75470/introduction
// Please use your own puzzles and avoid to replicate already existing puzzles!

// 5 x 5 example puzzle (a key)
/*
	□ ■ ■ ■ □
    □ ■ □ ■ □
    □ ■ ■ ■ □
    □ □ ■ □ □
    □ □ ■ ■ □
*/
pzl_5x5 = [
	[0, 0, 0, 0, 0],
	[1, 1, 1, 0, 0],
	[1, 0, 1, 1, 1],
	[1, 1, 1, 0, 1],
	[0, 0, 0, 0, 0],
];

// 10 x 10 example puzzle (a butterfly)
/*
	□ □ □ □ ■ □ □ □ ■ ■
	□ ■ ■ ■ □ ■ □ ■ □ ■
	■ ■ ■ ■ ■ □ ■ □ ■ ■
	■ ■ ■ ■ ■ ■ □ ■ ■ ■
	■ ■ ■ ■ ■ ■ ■ ■ ■ ■
	□ ■ ■ ■ ■ ■ □ ■ ■ ■
	□ □ □ ■ ■ ■ □ ■ ■ ■
	□ □ ■ ■ ■ ■ ■ ■ ■ ■
	□ ■ ■ ■ ■ ■ □ ■ ■ ■
	□ □ ■ ■ ■ □ □ □ ■ ■

*/
pzl_10x10 = [
	[0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
	[0, 1, 1, 1, 1, 1, 0, 0, 1, 0],
	[0, 1, 1, 1, 1, 1, 0, 1, 1, 1],
	[0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
	[0, 1, 0, 1, 1, 1, 1, 1, 1, 0],
	[0, 0, 1, 0, 1, 0, 0, 1, 0, 0],
	[0, 1, 0, 1, 1, 1, 1, 1, 1, 0],
	[1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
	[0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
];




// Store the current puzzle inside a global variable to be accessed by the puzzle object later
global.mockPuzzle = generateRandomPuzzle(10, 10);

