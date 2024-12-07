


/*
 ______     __         ______     ______     ______     ______     ______    
/\  ___\   /\ \       /\  __ \   /\  ___\   /\  ___\   /\  ___\   /\  ___\   
\ \ \____  \ \ \____  \ \  __ \  \ \___  \  \ \___  \  \ \  __\   \ \___  \  
 \ \_____\  \ \_____\  \ \_\ \_\  \/\_____\  \/\_____\  \ \_____\  \/\_____\ 
  \/_____/   \/_____/   \/_/\/_/   \/_____/   \/_____/   \/_____/   \/_____/ 
                                                                             
*/																			 
	
/// @function                 CellCoord : class;
/// @param {number}  xGrid    The x position in the grid
/// @param {number}  yGrid    The y position in the grid
/// @description              Represents the coordinates of a cell relative to the grid (xGrid = 0, yGrid = 0 represents the very first top-left cell inside the grid)
function CellCoord(xGrid, yGrid) constructor {
	

	#region Private members - (!) Do not touch directly, use getters and setters instead
	__xGrid = xGrid;
	__yGrid = yGrid;
	#endregion
	
	#region Getters
	getXGrid = function() {
		return __xGrid;
	}
	
	getYGrid = function() {
		return __yGrid;
	}
	
	getCoords = function() {
		return {xGrid: __xGrid, yGrid: __yGrid};
	}
	#endregion
	
	#region Setters
	setXGrid = function(xGrid) {
		if (!is_numeric(xGrid)) {
			throw ($"Cannot set xGrid value as method parameter is not a number. Receiving {xGrid} as value")
		}

		
		__xGrid = xGrid;
	}
	
	setYGrid = function(yGrid) {
		
		if (!is_numeric(yGrid)) {
			throw ($"Cannot set yGrid value as method parameter is not a number. Receiving {yGrid} as value")
		}
		
		__yGrid = yGrid;
	}
	
	setCoords = function(coords) {
		
		// TODO: Check that coords is a valid struct
		
		
		setXGrid(coords.xGrid);
		setYGrid(coords.yGrid);
	}
	#endregion
	
	
}

/// @function                        PuzzleCell : class;
/// @param {number}  defaultValue    The default value of the given cell
/// @param {number}  xGrid           The x grid position of the cell
/// @param {number}  yGrid           The y grid position of the cell
/// @description                     Represents a cell of the puzzle board
function PuzzleCell(defaultValue, xGrid, yGrid) constructor {
	
	#region Private members -  (!) Do not touch directly, use getters and setters instead
	__value  = defaultValue;
	__coords = new CellCoord(xGrid, yGrid);
	#endregion
	
	#region Getters
	static getValue = function() {
		return __value;
	}
	
	static getCoord = function() {
		return __coords;
	}
	#endregion
	
	#region Setters
	static setValue = function(newValue) {
		if (!is_numeric(newValue)) {
			throw ($"Cannot set cell's value as method parameter is not a number. Receiving {newValue} as value")
		}
		
		
		__value = newValue;
	}
	#endregion
	
    
}
	
/// @function                                HintData : class; 
/// @param {number[] Array}  r               The rows hints list                    Ex: [ [2, 1, 1],   [3],   [5, 1] ]
/// @param {number[] Array}  c               The columns hints list                 Ex: [ [5],   [1, 1, 1],   [5 - 3]]
/// @param {string[] Array}  rString         The rows hints list (string format)    Ex: ["2 - 1 - 1",   "3",   "5 - 1"]
/// @param {string[] Array}  cString         The columns hints list (string format) Ex: ["5",   "1 - 1 - 1",   "5 - 3"]
/// @description                     Represents the hints of a puzzle
function HintData(r, c, rString, cString) constructor {
	
	rows          = r;
	columns       = c;
	rowsString    = rString;
	columnsString = cString;
}
	
/// @function                                InputController : class; 
/// @description							 Represents the base input class
function InputController(puzzleWidth, puzzleHeight, puzzleManager) constructor {
	
	#region Public members
	
	xWorld  = -1;
	yWorld  = -1;
	xGrid   = 0;
	yGrid   = 0;
	inputID = -1;
	
	#endregion
	
	#region Private members
	
	__puzzleManager      = puzzleManager;
	__puzzleWidth        = puzzleWidth;
	__puzzleHeight       = puzzleHeight;
	
	#endregion
	
	
	doAction = function() {};
	
	update = function() {};
	
	render = function() {};
	
	
}

/// @function                                   MouseInput : class - inherits from InputController class
/// @param {number}       puzzleWidth           The width of the puzzle (dependency)
/// @param {number}       puzzleHeight          The height of the puzzle (dependency)
/// @param {instance_id}  puzzleManager         Reference to the puzzle manager
/// @description                                Mouse input controller
function MouseInput(puzzleWidth, puzzleHeight, puzzleManager) : InputController(puzzleWidth, puzzleHeight, puzzleManager) constructor {
	
	#region Public members
		/* Inherited from InputController */
		inputID = INPUT_MODE_ID.MOUSE;
	#endregion
	
	#region Private members
		/* Inherited from InputController */
	#endregion
	
	/// @function                                   doAction(action = "fill")
	/// @param {string}  ["fill"]   action          The action to perform
	/// @description                                Execute a specific action
	/// @returns {void} 
	doAction = function (action = "fill") {
		
		

	    // Fill the cell
	    if (action == "fill") {
			__puzzleManager.fillCell(xGrid, yGrid);
		} else if (action == "flag") {
			__puzzleManager.flagCell(xGrid, yGrid);
		}
	    
	};

	/// @function                                   update()
	/// @description                                Cursor logic
	/// @returns {void} 
	update = function () {
		

		var _mouseGridCoords = worldToGrid(mouse_x, mouse_y);
		xGrid = _mouseGridCoords.xGrid;
		yGrid = _mouseGridCoords.yGrid;
		
		// Mouse input actions
	    if (mouse_check_button_pressed(mb_left)) {
			doAction("fill");
		} else if (mouse_check_button_pressed(mb_right)) {
			doAction("flag");
		}

	   
	};

	/// @function                                   render()
	/// @description                                Display cursor on screen
	/// @returns {void} 
	render = function () {};
	
}
	
/// @function                                   PuzzleCursor : class; 
/// @param {number}       puzzleWidth           The width of the puzzle (dependency)
/// @param {number}       puzzleHeight          The height of the puzzle (dependency)
/// @param {instance_id}  puzzleManager         Reference to the puzzle manager
/// @description                                Represents the puzzle cursor (used in keyboard input mode)
function KeyboardInput(puzzleWidth, puzzleHeight, puzzleManager) : InputController(puzzleWidth, puzzleHeight, puzzleManager) constructor {
	
	#region Public members
	
	/* Inherited from InputController */
	inputID = INPUT_MODE_ID.KEYBOARD;
	
	#endregion
	
	#region Private members
	
	/* Inherited from InputController */
	__keyHeldDirection   = -1;                   // Tracks currently held direction ("right" | "left" | "up" | "down")
	__lastMoveTime       = 0;                    // Time since the last move
    __baseSpeed          = 0.2;                  // Initial steps per second
	__currentSpeed       = __baseSpeed;          // Steps per second
    __maxSpeed           = 25;                   // Maximum steps per second
	__keyHoldTime        = 0;                    // Tracks how long the key is held
	__inputAcceleration  = 0.002;                // Acceleration of the navigation when key is held
	__lastFilledCell     = { x: -1, y: -1 };     // Tracks the last filled cell coordinates
	__firstCellValue     = -1;                   /* Value of the first cell when the action key is pressed. 
												    This helps doing a series of actions of the same typology (Ex. whole row fill without affecting flagged cells)
												 */
	
	#endregion
	
	#region Methods
	

	/// @function                                   doAction(action = "fill")
	/// @param {string}  ["fill"]   action          The action to perform
	/// @description                                Execute a specific action
	/// @returns {void} 
	doAction = function (action = "fill") {
		
		if (__puzzleManager.playablePuzzle[# xGrid, yGrid].getValue() != __firstCellValue) return;
		
	    // Check if the cell can be filled
	    if (__lastFilledCell.x != xGrid || __lastFilledCell.y != yGrid) {
			
			//if (exists(puzzleManager) && puzzleManager.playablePuzzle[# __lastFilledCell.x, __lastFilledCell.y].getValue()) 
	        // Fill the cell
	        if (action == "fill") {
				__puzzleManager.fillCell(xGrid, yGrid);
			} else if (action == "flag") {
				__puzzleManager.flagCell(xGrid, yGrid);
			}
			
	        // Update the last filled cell and reset cooldown timer
	        __lastFilledCell = { x: xGrid, y: yGrid };
	
	    }
	};

	/// @function                                   move(xMove, yMove)
	/// @param {string}    xMove                    Grid x movement amount
    /// @param {string}    yMove                    Grid y movement amount
	/// @description                                Moves the cursor by a given x and y amount
	/// @returns {void} 
	move = function (xMove, yMove) {
	    xGrid = clamp(xGrid + xMove, 0, __puzzleWidth - 1);
	    yGrid = clamp(yGrid + yMove, 0, __puzzleHeight - 1);
	};

	/// @function                                   resetHoldState()
	/// @description                                Resets movement state. Used when switching or releasing keys
	/// @returns {void} 
	resetHoldState = function () {
	    __keyHoldTime      = 0;
	    __currentSpeed     = __baseSpeed;
	    __keyHeldDirection = -1;
		__lastMoveTime     = 0;
	};

	/// @function                                   update()
	/// @description                                Cursor logic
	/// @returns {void} 
	update = function () {
		
		
	    var _currentTime  = current_time;  
	    var _xMove        = 0;             // x component of the move direction (1 = right, -1 = left)
	    var _yMove        = 0;             // y component of the move direction (1 = down,  -1 = up)
	    var _newDirection = -1;            // The new direction string where we are moving towards ("right" | "left" | "up" | "down")

	    // Detect directional input
	    if (keyboard_check(vk_left) || gamepad_button_check(0, gp_padl)) {
	        _xMove = -1;
	        _newDirection = "left";
	    } else if (keyboard_check(vk_right) || gamepad_button_check(0, gp_padr)) {
	        _xMove = 1;
	        _newDirection = "right";
	    } else if (keyboard_check(vk_up) || gamepad_button_check(0, gp_padu)) {
	        _yMove = -1;
	        _newDirection = "up";
	    } else if (keyboard_check(vk_down) || gamepad_button_check(0, gp_padd)) {
	        _yMove = 1;
	        _newDirection = "down";
	    }

	    // Check if the direction changed
	    if (_newDirection != __keyHeldDirection) {
			
			// Reset hold variables
	        resetHoldState();
			
			// Update to new direction
	        __keyHeldDirection = _newDirection;
	    }

		// Check if we are moving
	    if (__keyHeldDirection != -1) {
			
	        // Increase hold time and increase navigation speed
	        __keyHoldTime += delta_time / 1000; // Time held in seconds
	        __currentSpeed = clamp(1 + power(__keyHoldTime * __inputAcceleration, 4), 1, __maxSpeed);

	        // Move cursor if enough time has elapsed
			var _canMoveCursor = _currentTime - __lastMoveTime >= (1000 / __currentSpeed);
			
	        if (_canMoveCursor) {
				
				// Move to new grid location
	            move(_xMove, _yMove);
				
				// Update last move time
	            __lastMoveTime = _currentTime; 
				
				// Execute Actions if an action key is held
	            if (keyboard_check(ord("Z")) || gamepad_button_check(0, gp_face2)) {
					doAction("fill");
	            }
				
				
				if (keyboard_check(ord("X")) || gamepad_button_check(0, gp_face1)) {
					doAction("flag");
	            }
				
				
	        }
	    } else {
			
			// No directional input, reset hold state
	        resetHoldState(); 
	    }

	    // Handle stationary actions (just pressing)
	    if (keyboard_check_pressed(ord("Z")) || gamepad_button_check_pressed(0, gp_face2)) {
			
			// Store the state of the first cell where action is executed on
			__firstCellValue = __puzzleManager.playablePuzzle[# xGrid, yGrid].getValue();
			
			// Execute action
	        doAction("fill");

	    } 
		
		// Handle stationary actions (just pressing)
		 if (keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(0, gp_face1)) {
			 
			 // Store the state of the first cell where action is executed on
			 __firstCellValue = __puzzleManager.playablePuzzle[# xGrid, yGrid].getValue();
			 
			 // Execute action
	           doAction("flag");
	    }
		
		
		// Reset vairables on action key released
		if (keyboard_check_released(ord("Z")) || gamepad_button_check_released(0, gp_face2) || keyboard_check_released(ord("X")) || gamepad_button_check_released(0, gp_face1)) {
			__firstCellValue = -1;
			__lastFilledCell = { x: -1, y: -1 };
		}

	   
	};
	
	/// @function                                   render()
	/// @description                                Display cursor on screen
	/// @returns {void} 
	render = function () {
	    var _worldCoords = gridToWorld(xGrid, yGrid);
	    var _xReal = _worldCoords.xWorld + (global.CELL_WIDTH / 2);
	    var _yReal = _worldCoords.yWorld + (global.CELL_WIDTH / 2);
	    draw_sprite_ext(sCursor, 0, _xReal, _yReal, global.SCALE_FACTOR, global.SCALE_FACTOR, 0, SECONDARY_COLOR, 1);
		
		/* DEBUG
		draw_set_halign(fa_right);
		draw_text(room_width - 8, 32, "keyHeldDirection: " + string(__keyHeldDirection));
		draw_text(room_width - 8, 64, "lastMoveTime: "     + string(__lastMoveTime));
		draw_text(room_width - 8, 96, "currentSpeed: "     + string(__currentSpeed) + " / " + string(__maxSpeed));
		draw_text(room_width - 8, 128, "keyHoldTime: "     + string(__keyHoldTime));
		draw_text(room_width - 8, 160, "fillKeyHeldTime: " + string(__fillKeyHeldTime));
		draw_text(room_width - 8, 192, "lastFilledCell: "  + string(__lastFilledCell));
		draw_set_halign(fa_left);
		*/
	};
	
	#endregion

}