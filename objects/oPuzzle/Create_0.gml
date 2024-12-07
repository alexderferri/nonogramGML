/// @description Initialize Puzzle

#region Members


targetPuzzle     = -1;        // The puzzle to solve                    ds_grid
playablePuzzle   = -1;        // The puzzle grid you interact with      ds_grid
puzzleWidth      = -1;        // Width of the puzzle                    number
puzzleHeight     = -1;        // Height of the puzzle                   number
hints            = -1;        // The hints of the puzzle                HintData[]             number[]
inputController  = -1;        // The input controller                   InputController
errorsCount      =  0;        // Player's errors count
lineHeight       = -1;        // The line height for the hints numbers
puzzleSolved     = false;     // Flag to store if the puzzle has been solved

#endregion



#region Methods

/// @function                        build(puzzle)
/// @param {number[][]}  puzzle      The puzzle to solve
/// @description                     Build all the puzzle's data
/// @returns {void} 
function build(puzzle) {
	
	// Load the puzzle
	loadPuzzle(puzzle);
	
	// Set the cursor if you enabled keyboard input mode
	if (global.INPUT_MODE == INPUT_MODE_ID.KEYBOARD) {
		inputController = new KeyboardInput(puzzleWidth, puzzleHeight, id);
	} else if (global.INPUT_MODE == INPUT_MODE_ID.MOUSE) {
	    inputController = new MouseInput(puzzleWidth, puzzleHeight, id);
	}
	
	// Calculate line height for hints
	lineHeight = font_get_size(fntGame) * 0.7 * global.SCALE_FACTOR;
}

/// @function                        loadPuzzle(puzzle)
/// @param {number[][]}  puzzle      The puzzle to solve
/// @description                     Load the puzzle and initialize the ds_grid and hints
/// @returns {void} 
function loadPuzzle(puzzle) {
	
	// Sanity check - the puzzle to solve is not valid
	if (array_length(puzzle) <= 0)    return;
	if (array_length(puzzle[0]) <= 0) return;
	
	// Calculate the width and height of the puzzle
	puzzleWidth  = array_length(puzzle);     // Row width
	puzzleHeight = array_length(puzzle[0]);  // Column height
	
	// Create ds_grid for the puzzle to solve
	targetPuzzle = ds_grid_create(puzzleWidth, puzzleHeight);
	
	// Set all puzzle grid cells to be empty cells
	for (var i = 0; i < puzzleWidth; i++) {
		for (var j = 0; j < puzzleHeight; j++) {
			var _cellValue = puzzle[i][j] == 0 ? CellValue.EMPTY : CellValue.FILLED;
			ds_grid_set(targetPuzzle, i, j, new PuzzleCell(_cellValue, i, j));
		}
	}
	
	// Calculate puzzle's hints
	hints = calculateBoardHints(targetPuzzle, puzzleWidth, puzzleHeight);
	
	// Initialize the playable puzzle
	initPuzzle(puzzleWidth, puzzleHeight);
	
}

/// @function                        initPuzzle(width, height)
/// @param {number}  width           The width of the puzzle
/// @param {number}  height          The height of the puzzle
/// @description                     Initialize the playable puzzle
/// @returns {void} 
function initPuzzle(width, height) {
	
	// Initialize puzzle grid with given width and height
	playablePuzzle = ds_grid_create(width, height);
	
	// Set all puzzle grid cells to be empty cells
	for (var i = 0; i < width; i++) {
		for (var j = 0; j < height; j++) {
			ds_grid_set(playablePuzzle, i, j, new PuzzleCell(CellValue.EMPTY, i, j));
		}
	}
	
	// Center the board
	centerBoard(width, height, room_width, room_height);
	
	

}


/// @function                        render()
/// @description                     Display the puzzle on screen
/// @returns {void} 
function render() {
	
	// Rendr Hints
	renderHints();
	
	// Draw puzzle grid container
	if (DRAW_BOARD_BACKGROUND) {
		
		
		var _xStart = global.BOARD_PADDING_X - BOARD_BACKGROUND_PADDING;
		var _yStart = global.BOARD_PADDING_Y - BOARD_BACKGROUND_PADDING;
		var _xScale = puzzleWidth + ((BOARD_BACKGROUND_PADDING / global.CELL_WIDTH) * 2);
		var _yScale = puzzleHeight + ((BOARD_BACKGROUND_PADDING / global.CELL_WIDTH) * 2);
		
		_xScale *= global.SCALE_FACTOR;
		_yScale *= global.SCALE_FACTOR;
		
		draw_sprite_ext(sCell, 0, _xStart, _yStart, _xScale, _yScale, 0, DARK_COLOR, 1);
	}
	
	// Render cells
	for (var i = 0; i < puzzleWidth; i++) {
		for (var j = 0; j < puzzleHeight; j++) {
			
			// Get the cell value => EMPTY or FILLED
			var _cellColor = playablePuzzle[# i, j].getValue() == CellValue.FILLED ? PRIMARY_COLOR : LIGHT_COLOR;
			
			/// Draw the cell
			var _worldCoords = gridToWorld(i, j);
			draw_sprite_ext(sCell, 0, _worldCoords.xWorld, _worldCoords.yWorld, global.SCALE_FACTOR, global.SCALE_FACTOR, 0, _cellColor, 1);
			
			// Flagged cell
			if (playablePuzzle[# i, j].getValue() == CellValue.FLAGGED) {
				draw_sprite_ext(sFlagIcon, 0, _worldCoords.xWorld, _worldCoords.yWorld, global.SCALE_FACTOR, global.SCALE_FACTOR, 0, SECONDARY_COLOR, 1);
			}
		}
	}
	
		
}

/// @function                        renderHints()
/// @description                     Display the hints on screen
/// @returns {void} 
function renderHints() {
	
	if (DRAW_ROWS_HINTS) renderRowsHints();
	if (DRAW_COLS_HINTS) renderColumnsHints();
}

/// @function                        renderRowsHints()
/// @description                     Display the rows hints on screen
/// @returns {void} 
function renderRowsHints() {

	// Iterate the puzzle vertically
	for (var j = 0; j < puzzleHeight; j++) {
		
		// Get the hints position
		var _hintCoord = gridToWorld(0, j);
		
		// Highlight hints that are at keyboard cursor
		var _highlighted = inputController.inputID == INPUT_MODE_ID.KEYBOARD && inputController.yGrid == j;
		
		// Render the hints strip background
		draw_sprite_ext(sCell, 0, _hintCoord.xWorld - 256, _hintCoord.yWorld, 8, global.SCALE_FACTOR, 0, _highlighted ? PRIMARY_COLOR : DARK_COLOR, 1);
		
		
		// Set text alignment
		draw_set_halign(fa_right);
		draw_set_valign(fa_middle);
		
		
		// Get both hints strip and playable grid strip (to make comparison)
		var _hintsArray  = string_split(hints.rowsString[j], " ");

				
		
		// Render hints numbers 
		for (var i = array_length(_hintsArray) - 1; i >= 0; i--) {
			
			// Default hint color
			var _hintNumberColour = c_white;		
	
			// Render text
			draw_set_color(_hintNumberColour);
		    draw_text_transformed(_hintCoord.xWorld - ROW_HINT_PADDING - (array_length(_hintsArray) - 1 - i) * lineHeight, _hintCoord.yWorld + (global.CELL_WIDTH / 2), _hintsArray[i], global.SCALE_FACTOR, global.SCALE_FACTOR, 0);
		
		}
		
		
		// Reset render values
		draw_set_color(c_white);
		draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
}

/// @function                        renderColumnsHints()
/// @description                     Display the columns hints on screen
/// @returns {void} 
function renderColumnsHints() {
	
	// Iterate the puzzle horizontally
	for (var i = 0; i < puzzleWidth; i++) {
		
		// Get the hints position
		var _hintCoord = gridToWorld(i, 0);
		
		// Highlight hints that are at keyboard cursor
		var _highlighted = inputController.inputID == INPUT_MODE_ID.KEYBOARD && inputController.xGrid == i;
		
		// Render the hints strip background
		draw_sprite_ext(sCell, 0, _hintCoord.xWorld, _hintCoord.yWorld - 256, global.SCALE_FACTOR, 8, 0, _highlighted ? PRIMARY_COLOR : DARK_COLOR, 1);
		
		
		// Set text alignment
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		
		// Get both hints strip and playable grid strip (to make comparison)
		var _hintsArray  = string_split(hints.columnsString[i], " ");
			
		
		// Render hints numbers 
		for (var j = array_length(_hintsArray) - 1; j >= 0; j--) {
			
			// Default hint color
			var _hintNumberColour = c_white;
			
		
			// Render text
			draw_set_color(_hintNumberColour);
		    draw_text_transformed(_hintCoord.xWorld + (global.CELL_WIDTH / 2),  _hintCoord.yWorld - COL_HINT_PADDING - (array_length(_hintsArray) - 1 - j) * lineHeight, _hintsArray[j], global.SCALE_FACTOR, global.SCALE_FACTOR, 0);
		}
	
		// Reset render values
		draw_set_color(c_white);
		draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
}

/// @function                        cleanUp()
/// @description                     Clean up resources to free up memory
/// @returns {void} 
function cleanUp() {
	
	// Clean puzzle data structures
	if (ds_exists(playablePuzzle, ds_type_grid)) {
		ds_grid_destroy(playablePuzzle);
	}
	
	if (ds_exists(targetPuzzle, ds_type_grid)) {
		ds_grid_destroy(targetPuzzle);
	}
}
	
/// @function                        isCellCorrect(xGrid, yGrid)
/// @param {number}  xGrid           The cell x position on the grid
/// @param {number}  yGrid           The cell y position on the grid
/// @description                     Check if a given cell has the correct value
/// @returns {bool} 
function isCellCorrect(xGrid, yGrid) {
	
	// Sanity Check
	if (isOutOfGridBounds(xGrid, yGrid, puzzleWidth, puzzleHeight)) {
		throw ($"Cannot check for errors as xGrid or yGrid value are outside the puzzle grid bounds. Receiving {xGrid} and {yGrid} as values");
	}
	
	// Only make the check if the player has filled the cell, otherwise always return true
	// You don't want to check for errors if the player has flagged (X) or cleared a cell
	if (playablePuzzle[# xGrid, yGrid].getValue() != CellValue.FILLED) return true;
	
	// Check for errors
	return (playablePuzzle[# xGrid, yGrid].getValue() == targetPuzzle[# xGrid, yGrid].getValue());
	
}	
	
/// @function                        fillCell(xGrid, yGrid)
/// @param {number}  xGrid           The cell x position on the grid
/// @param {number}  yGrid           The cell y position on the grid
/// @description                     Fill the cell at the given grid coordinates
/// @returns {void} 
function fillCell(xGrid, yGrid) {
	
	
	// Sanity check - Check that the mouse grid coordinates are inside the puzzle grid bounds
	if (isOutOfGridBounds(xGrid, yGrid, puzzleWidth, puzzleHeight)) return;
	
	// If puzzle is solved, return
	if (puzzleSolved) return;
	
	// Toggle puzzle grid cell fill state
	var _newCellValue;
	switch (playablePuzzle[# xGrid, yGrid].getValue()) {
		case CellValue.FLAGGED:
		case CellValue.FILLED:  _newCellValue = CellValue.EMPTY;   break;
		case CellValue.EMPTY:   _newCellValue = CellValue.FILLED;  break;
		default: _newCellValue = CellValue.EMPTY;

	}
	playablePuzzle[# xGrid, yGrid].setValue(_newCellValue);
	
	
	// Check for errors
	if (global.CHECK_FOR_ERRORS) {
		
		if (!isCellCorrect(xGrid, yGrid)) {
			
			// Increase the errors counter
			errorsCount++;
			
			// Do your own logic for errors
		}
		
	}
	
	
	
	// Check if the puzzle has been solved
	if (isPuzzleSolved()) {
		
		puzzleSolved = true;
		show_message("Puzzle Solved");
		
		// Do your own logic for when the puzzle has been solved
	}
	
	
	
}

/// @function                        flagCell(xGrid, yGrid)
/// @param {number}  xGrid           The cell x position on the grid
/// @param {number}  yGrid           The cell y position on the grid
/// @description                     Flag the cell at the given grid coordinates
/// @returns {void} 
function flagCell(xGrid, yGrid) {
	

	
	// Sanity check - Check that the mouse grid coordinates are inside the puzzle grid bounds
	if (isOutOfGridBounds(xGrid, yGrid, puzzleWidth, puzzleHeight)) return;
	
	// If puzzle is solved, return
	if (puzzleSolved) return;
	
	// Toggle puzzle grid cell fill state
	var _newCellValue;
	switch (playablePuzzle[# xGrid, yGrid].getValue()) {
		case CellValue.FLAGGED:
		case CellValue.FILLED:  _newCellValue = CellValue.EMPTY;   break;
		case CellValue.EMPTY:   _newCellValue = CellValue.FLAGGED;  break;
		default: _newCellValue = CellValue.EMPTY;

	}
	playablePuzzle[# xGrid, yGrid].setValue(_newCellValue);
	


}


/// @function                        isBoardSolved()
/// @description                     Check if the puzzle board has beed solved
/// @returns {bool} 
function isPuzzleSolved() {
	
	for (var i = 0; i < puzzleWidth; i++) {
		for (var j = 0; j < puzzleHeight; j++) {
			
			var _solutionCell = targetPuzzle[# i, j].getValue();
			
			// Only check for filled cell in puzzle solution to avoid reading in both ds_grid(s) each iteration
			if (_solutionCell != CellValue.FILLED) continue;
			
			// The filled cell in the solution does not match the player's
			if (playablePuzzle[# i, j].getValue() != _solutionCell) return false;
		}
	}
	
	return true;
}



#endregion

