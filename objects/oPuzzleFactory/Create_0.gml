/// @description Initialize puzzle factory


#region Methods

/// @function                                                        buildPuzzle(puzzleToSolve, config) 
/// @param {number[] Array}                          puzzleToSolve   The puzzle to solve in an Array format                  
/// @param {struct: inputMode, checkForErrors}       config          The puzzle configuration    
//  @return {instance_id}					                         The ID of the newly created puzzle
/// @description                                                     Builds a puzzle to solve
function buildPuzzle(puzzleToSolve, config = {}) {
	
	// Configuration
	if (variable_struct_exists(config, "inputMode"))      global.INPUT_MODE          = config[$ "inputMode"];	
	if (variable_struct_exists(config, "checkForErrors")) global.CHECK_FOR_ERRORS    = config[$ "checkForErrors"];	

	
	
	// Default configuration setup
	global.SCALE_FACTOR = calculateScaleFactor(array_length(puzzleToSolve), MIN_PUZZLE_WIDTH, MAX_PUZZLE_WIDTH, MIN_PUZZLE_SCALE, MAX_PUZZLE_SCALE);
	global.CELL_WIDTH   = round(global.CELL_WIDTH * global.SCALE_FACTOR);
	
	
	// Create an instance of a puzzle and build it
	var _puzzle = instance_create_depth(0, 0, -9999, oPuzzle);
	_puzzle.build(puzzleToSolve);
	
	
	return _puzzle;

}
	
#endregion
	

// Create a testing puzzle
// You can inject a configuration struct as second parameter
buildPuzzle(global.mockPuzzle, {
	inputMode: INPUT_MODE_ID.KEYBOARD,
	checkForErrors: false
}); 

