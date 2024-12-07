
/*
 ______     __   __     __  __     __    __     ______    
/\  ___\   /\ "-.\ \   /\ \/\ \   /\ "-./  \   /\  ___\   
\ \  __\   \ \ \-.  \  \ \ \_\ \  \ \ \-./\ \  \ \___  \  
 \ \_____\  \ \_\\"\_\  \ \_____\  \ \_\ \ \_\  \/\_____\ 
  \/_____/   \/_/ \/_/   \/_____/   \/_/  \/_/   \/_____/ 
                                                          
*/

// Enumerate the input typologies
enum INPUT_MODE_ID {
	MOUSE,
	KEYBOARD
}

// Enumerate the possible cell states 
// [ ] = CellValue.EMPTY
// [■] = CellValue.FILLED
// [X] = CellValue.FLAGGED
enum CellValue {
	EMPTY = 0,
	FILLED,
	FLAGGED
}


/*  
 __    __     ______     ______     ______     ______     ______    
/\ "-./  \   /\  __ \   /\  ___\   /\  == \   /\  __ \   /\  ___\   
\ \ \-./\ \  \ \  __ \  \ \ \____  \ \  __<   \ \ \/\ \  \ \___  \  
 \ \_\ \ \_\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\  \/\_____\ 
  \/_/  \/_/   \/_/\/_/   \/_____/   \/_/ /_/   \/_____/   \/_____/ 
*/

#macro DEBUG             true          // Display debug info on screen
#macro HINTS_DELIMITER   "  "          // The delimiter of UI hints numbers. Examples: " - " or "  " => which might translate into "3 - 1" or "3  1"
#macro ROW_HINT_PADDING  8             // The space (in pixels) between row hints UI numbers and the board 
#macro COL_HINT_PADDING  8             // The space (in pixels) between column hints UI numbers and the board
#macro DRAW_ROWS_HINTS   true          // Flag to toggle on and off the row hints (set it to TRUE, otherwise you won't be able to play XD)
#macro DRAW_COLS_HINTS   true          // Flag to toggle on and off the column hints (set it to TRUE, otherwise you won't be able to play XD)
#macro DRAW_BOARD_BACKGROUND true      // Flag to toggle on and off the board backgound 
#macro BOARD_BACKGROUND_PADDING 8      // The padding of the board background in pixels (basically how much it extends outside the border bounds)
#macro MIN_PUZZLE_WIDTH  5             // The minimum size of a board (set it to a reasonable number, ex: 5)
#macro MAX_PUZZLE_WIDTH  15	           // The maximum size of a board (set it to a reasonable number, ex: 20)
#macro MIN_PUZZLE_SCALE  0.8           // This will reflect how big each cell in the board should be rendered when the board is very wide (MAX_PUZZLE_WIDTH) (1 is the size of the cell sprite, 2 is double the size, etc.)
#macro MAX_PUZZLE_SCALE  1.3           // This will reflect how big each cell in the board should be rendered when the board is very tiny (MIN_PUZZLE_WIDTH) (1 is the size of the cell sprite, 2 is double the size, etc.)


// Colors used in the example
// I used color palettes from this amazing website: https://colorhunt.co/palette/c96868fadfa1fff4ea7eacb5 

#macro DARK_COLOR        #211e1e         // Used for: board background, hints strip background
#macro LIGHT_COLOR       #FFF4EA         // Used for: empty cell background
#macro PRIMARY_COLOR     #C96868         // Used for: filled cell background, hints strip highlight background
#macro SECONDARY_COLOR   #7EACB5         // Used for: cross icon on flagged cells


/*
 ______     __         ______     ______     ______     __         ______    
/\  ___\   /\ \       /\  __ \   /\  == \   /\  __ \   /\ \       /\  ___\   
\ \ \__ \  \ \ \____  \ \ \/\ \  \ \  __<   \ \  __ \  \ \ \____  \ \___  \  
 \ \_____\  \ \_____\  \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\  \/\_____\ 
  \/_____/   \/_____/   \/_____/   \/_____/   \/_/\/_/   \/_____/   \/_____/ 
                                                                             
*/

// (!) These ones can also be manipulated runtime in your code

global.BOARD_PADDING_X      = 128                          // The distance (in pixels) between the left bound of the screen and the board
global.BOARD_PADDING_Y      = 128                          // The distance (in pixels) between the top bound of the screen and the board
														   // (!) Padding can be calculated automatically with the centerBoard() utility function

global.CELL_WIDTH           = sprite_get_width(sCell)      // The cell size (in pixles) - Taken directly from the actual sCell sprite size. You can set it to a specific number if you have sprites with transparent padding, for example. 
														   // (!) This is initialized properly inside the Puzzle Factory object
														   
global.INPUT_MODE           = INPUT_MODE_ID.KEYBOARD;      // Game input mode. It stores the input mode used by the puzzle (keyboard or mouse)
global.CHECK_FOR_ERRORS     = true;                        // Flag to check errors each time the player fill a cell. Useful if you want to implement an 'Error Mode'
global.SCALE_FACTOR         = 1;			               // The cells scale factor used to render cells at the right size for small and large puzzle boards. It is calculated automatically inside the puzzle initialization