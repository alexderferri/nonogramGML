/*
 __  __     ______   __     __         __     ______   __  __    
/\ \/\ \   /\__  _\ /\ \   /\ \       /\ \   /\__  _\ /\ \_\ \   
\ \ \_\ \  \/_/\ \/ \ \ \  \ \ \____  \ \ \  \/_/\ \/ \ \____ \  
 \ \_____\    \ \_\  \ \_\  \ \_____\  \ \_\    \ \_\  \/\_____\ 
  \/_____/     \/_/   \/_/   \/_____/   \/_/     \/_/   \/_____/ 
                                                                                                                                                                
*/



// (!) These are all helper functions. You shouldn't be editing those unless you know what you are doing (I mean, you can do whatever you want but you might break things up XD)
// If you think something could be improved/optimized, please reach me out at alexferrer96@gmail.com


/// @function                        worldToGridX(xWorld)
/// @param {number}  xWorld          The x world position to convert
/// @description                     Convert world x coordinates to grid x coordinates
/// @returns {number} 
function worldToGridX(xWorld) {
	
	// Sanity check. If the x position is outside the physical bounds of the grid, return -1
	if (xWorld < global.BOARD_PADDING_X) {
        return -1;
    }
	
	return (max(xWorld - global.BOARD_PADDING_X, 0) div global.CELL_WIDTH);
}

/// @function                        worldToGridY(yWorld)
/// @param {number}  yWorld          The y world position to convert
/// @description                     Convert world y coordinates to grid y coordinates
/// @returns {number} 
function worldToGridY(yWorld) {
	
	// Sanity check. If the y position is outside the physical bounds of the grid, return -1
	if (yWorld < global.BOARD_PADDING_Y) {
        return -1;
    }
	
	return (max(yWorld - global.BOARD_PADDING_Y, 0) div global.CELL_WIDTH);
}

/// @function                        worldToGrid(xWorld, yWorld)
/// @param {number}  xWorld          The x world position to convert
/// @param {number}  yWorld          The y world position to convert
/// @description                     Convert both world (x, y) coordinates to grid (x, y) coordinates
/// @returns { struct{xGrid, yGrid} } 
function worldToGrid(xWorld, yWorld) {
	
	
	return {
		xGrid: worldToGridX(xWorld),
		yGrid: worldToGridY(yWorld)
	}
}

/// @function                        gridToWorldX(xGrid)
/// @param {number}  xGrid           The x grid position to convert
/// @description                     Convert grid x coordinates to world x coordinates
/// @returns {number} 
function gridToWorldX(xGrid) {
	
	return (global.BOARD_PADDING_X + (xGrid * global.CELL_WIDTH));
}

/// @function                        gridToWorldY(yGrid)
/// @param {number}  yGrid           The y grid position to convert
/// @description                     Convert grid y coordinates to world y coordinates
/// @returns {number} 
function gridToWorldY(yGrid) {
	
	return (global.BOARD_PADDING_Y + (yGrid * global.CELL_WIDTH));
}

/// @function                        gridToWorld(xGrid, yGrid)
/// @param {number}  xGrid           The x world position to convert
/// @param {number}  yGrid           The y world position to convert
/// @description                     Convert both grid (x, y) coordinates to world (x, y) coordinates
/// @returns { struct{xWorld, yWorld} } 
function gridToWorld(xGrid, yGrid) {
	
	return {
		xWorld: gridToWorldX(xGrid),
		yWorld: gridToWorldY(yGrid)
	}
}
	
/// @function                        setBoardPaddingX(paddingX)
/// @param {number}  paddingX        The new padding x value
/// @description                     Set the board padding x (distance from left screen edge)
/// @returns {void} 
function setBoardPaddingX(paddingX) {
	global.BOARD_PADDING_X = paddingX;
}

/// @function                        setBoardPaddingY(paddingY)
/// @param {number}  paddingY        The new padding y value
/// @description                     Set the board padding y (distance from top screen edge)
/// @returns {void} 
function setBoardPaddingY(paddingY) {
	global.BOARD_PADDING_Y = paddingY;
}

/// @function                        calculateBoardCenterPaddingX(gridWidth, roomWidth)
/// @param {number}  gridWidth       The width of the grid
/// @param {number}  roomWidth       The width of the room
/// @description                     Calculate the board padding x (automatically) based on both grid and screen width
/// @returns {number} 
function calculateBoardCenterPaddingX(gridWidth, roomWidth) {
	return (roomWidth - (gridWidth * global.CELL_WIDTH)) / 2;
}

/// @function                        calculateBoardCenterPaddingY(gridHeight, roomHeight)
/// @param {number}  gridHeight      The height of the grid
/// @param {number}  roomHeight      The height of the room
/// @description                     Calculate the board padding y (automatically) based on both grid and screen height
/// @returns {number} 
function calculateBoardCenterPaddingY(gridHeight, roomHeight) {
	return (roomHeight - (gridHeight * global.CELL_WIDTH)) / 2;
}

/// @function                              centerBoard(gridWidth, gridHeight, roomWidth, roomHeight, autoSet = true)
/// @param {number}        gridWidth       The width of the grid
/// @param {number}        gridHeight      The height of the grid
/// @param {number}        roomWidth       The width of the room
/// @param {number}        roomHeight      The height of the room
/// @param {bool} [true]   autoSet		   Whether to set the padding automatically or not. Optional (default = true)
/// @description                           Calculate the board paddings based on both grid and screen size (width and height). If autoset is true it will automatically set the paddings variables
/// @returns { struct{paddingX, paddingY} } 
function centerBoard(gridWidth, gridHeight, roomWidth, roomHeight, autoSet = true) {
	
	// Calculate paddings
	var _paddingResult = {
		paddingX: calculateBoardCenterPaddingX(gridWidth,  roomWidth),
		paddingY: calculateBoardCenterPaddingY(gridHeight, roomHeight)
	}
	
	// Set paddings if autoset = true
	if (autoSet) {
		setBoardPaddingX(_paddingResult.paddingX);
		setBoardPaddingY(_paddingResult.paddingY);
	}
	
	
	return _paddingResult;
}

/// @function                             calculateHintStrip(data)
/// @param {number[]}      data           The data of a whole row or column. It must be an array of numbers which represent the state of each cell in the row or column
/// @description                          Calculate the hints of a given row or column. It returns an array of hints. Example: [2, 1, 5] => ■ ■ □ □ ■ □ ■ ■ ■ ■ ■
/// @returns {number[]} 
function calculateHintStrip(data) {

  
  var _hints = [];    // Output variable
  var _count    = 0;  // Count helper variable. It stores how many consecutive cells are found and then resets back to zero

  // Loop through each cell in the row array
  for (var i = 0; i < array_length(data); i++) {
	  
	 // The cell is filled - Increase the count (consecutive cells)
    if (data[i] == CellValue.FILLED) {
		
		_count++;  
		
    } else {
	// The cell is empty - If count is greater than zero (we previously encountered consecutive cells), add the count to the output array
	

      if (_count > 0) {
		  
		// It's time to push the count value to the hints array
		array_push(_hints, _count);
		
		// Reset the count and start over
        _count = 0; 
      }
    }
  }

  // If the row or column ends with a filled cell, add the last count to the hints
  if (_count > 0) {
	array_push(_hints, _count);
  }

  // Return the consecutive cells pattern. If no filled cells were found (it might be they are all empty), return a hint array of [0]. 
  return array_length(_hints) > 0 ? _hints : [0];


}

/// @function                             getHintsStringFormat(hintsDataArray)
/// @param {number[]}   hintsDataArray    The hints data of a whole row or column.
/// @description                          Returns the hints of a given row or column in string format. Example: "2 - 1 - 5" if input is: [2, 1, 5]
/// @returns {number[]} 
function getHintsStringFormat(hintsDataArray) {
	
	return string_join_ext(HINTS_DELIMITER, hintsDataArray);
}
	
/// @function                                getBoardRowData(board, colIndex, boardWidth)
/// @param {PuzzleCell[][]}   board          The puzzle board
/// @param {number}           colIndex       The index of the column you want to get board row data from
/// @param {number}           boardWidth     The width of the board
/// @description                             Calculate the chunks of a given row. It returns an array of chunks (0 | 1). Example: [1, 1, 0, 0, 0, 1]
/// @returns {number[]} 
function getBoardRowData(board, colIndex, boardWidth) {
	
	var _rowData = []; // Output varaible
	
	// Iterate the row
	for (var i = 0; i < boardWidth; i++) {
		
		// Get the cell value at that given column and row cell
		var _cellValue = ds_grid_get(board, i, colIndex).getValue();
		
		// Add the cell value to the output array
		array_push(_rowData, _cellValue);
	}
	
	return _rowData;
	
}
	
/// @function                                getBoardColumnData(board, rowIndex, boardHeight)
/// @param {PuzzleCell[][]}   board          The puzzle board
/// @param {number}           rowIndex       The index of the row you want to get board column data from
/// @param {number}           boardHeight    The height of the board
/// @description                             Calculate the chunks of a given column. It returns an array of chunks (0 | 1). Example: [0, 1, 1, 0, 1, 1]
/// @returns {number[]} 
function getBoardColumnData(board, rowIndex, boardHeight) {
	
	var _columnData = []; // Output varaible
	 
	// Iterate the column
	for (var i = 0; i < boardHeight; i++) {
		
		// Get the cell value at that given row and column cell
		var _cellValue = ds_grid_get(board, rowIndex, i).getValue();
		
		// Add the cell value to the output array
		array_push(_columnData, _cellValue);
	}
	
	return _columnData;
	
}
	
/// @function                                calculateBoardHints(board, boardWidth, boardHeight)
/// @param {PuzzleCell[][]}   board          The puzzle board
/// @param {number}           boardWidth     The width of the board
/// @param {number}           boardHeight    The height of the board
/// @description                             Returns the hints of a whole board as a HintData class instance
/// @returns {HintData} 
function calculateBoardHints(board, boardWidth, boardHeight) {

	
	var _rows             = [];  // Rows hints
	var _rowsString       = [];  // Rows hints - string format
	var _cols             = [];  // Columns hints
	var _colsString       = [];  // Columns hints - string format
	var _gridData         = [];  // Temporary grid data holder
	var _hints            = [];  // Temporary hints holder
	var _hintsFormatted   = "";  // Temporary hints (string format) holder

	
	// Rows
	for (var j = 0; j < boardHeight; j++) {
		
		// Get row data (ex. [1, 0, 1, 1, 1, 0, 1])
		_gridData  = getBoardRowData(board, j, boardWidth);
		
		// Calculate hints (ex. [1, 3, 1])
		_hints = calculateHintStrip(_gridData);
		
		// Calculate hints string format (ex. "1 - 3 - 1")
		_hintsFormatted = getHintsStringFormat(_hints);
		
		// Save hints in the output array
		array_push(_rows, _hints);
		array_push(_rowsString, _hintsFormatted);
	}
	
	// Columns
	for (var i = 0; i < boardWidth; i++) {
		
		// Get row data (ex. [1, 1, 0, 0, 1, 1, 1])
		_gridData  = getBoardColumnData(board, i, boardHeight);
		
		// Calculate hints (ex. [2, 3])
		_hints = calculateHintStrip(_gridData);
		
		// Calculate hints string format (ex. "2 - 3")
		_hintsFormatted = getHintsStringFormat(_hints);
		
		// Save hints in the output array
		array_push(_cols, _hints);
		array_push(_colsString, _hintsFormatted);
	}


	
	return new HintData(_rows, _cols, _rowsString, _colsString);
}
	
/// @function                                isOutOfGridBounds(xVal, yVal, width, height)
/// @param {number}           xVal           The x value to check
/// @param {number}           yVal           The y value to check
/// @param {number}           width          The x limit value
/// @param {number}           height         The y limit value
/// @description                             Returns whether a given grid coordinate (x, y) is inside the board bounds ([0 - boardWidth], [0 - boardHeight])
/// @returns {bool} 
function isOutOfGridBounds(xVal, yVal, width, height) {
    return xVal > width - 1 || yVal > height - 1 || xVal < 0 || yVal < 0;
}
	
/// @function                                calculateScaleFactor(xVal, xMin, xMax, yMin, yMax)
/// @param {number}           xVal           The input value for which the scale factor is calculated
/// @param {number}           xMin           The minimum value of the input range
/// @param {number}           xMax           The maximum value of the input range
/// @param {number}           yMin           The minimum value of the output range
/// @param {number}           yMax           The maximum value of the output range
/// @description                             Maps a value from one range ([xMin, xMax]) to another range ([yMin, yMax]) using linear interpolation.
/// @returns {number} 
function calculateScaleFactor(xVal, xMin, xMax, yMin, yMax) {

	return yMin + ((yMax - yMin) * (xMax - xVal) / (xMax - xMin));
}	
	
	
/// @function                        generateRandomPuzzle(width, height)
/// @param {number}  width           The width of the puzzle to generate
/// @param {number}  height          The height of the puzzle to generate
/// @description                     Generate a puzzle of given width and height
/// @returns {number[][]} 
function generateRandomPuzzle(width, height) {
	randomize();
	
	var _puzzle = [];
	
	for (var i = 0; i < width; i++) {
		for (var j = 0; j < height; j++) {
			_puzzle[i][j] = choose(0, 1);
		}
	}
	
	return _puzzle;

}