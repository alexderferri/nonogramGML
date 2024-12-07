/// @description Rendering

// Set the puzzle UI font
draw_set_font(fntGame);

// Render the puzzle
render();

// Render the input controller (Ex. keyboard navigation cursor)
if (inputController != -1) inputController.render();



/*
 _____     ______     ______     __  __     ______    
/\  __-.  /\  ___\   /\  == \   /\ \/\ \   /\  ___\   
\ \ \/\ \ \ \  __\   \ \  __<   \ \ \_\ \  \ \ \__ \  
 \ \____-  \ \_____\  \ \_____\  \ \_____\  \ \_____\ 
  \/____/   \/_____/   \/_____/   \/_____/   \/_____/ 
                                                      
*/
if (DEBUG) {
	
	draw_set_font(fntDebug);
	
	var _debugXStart = 32;
	var _debugYStart = 32;
	var _debugY      = 0;
	
	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(0, 0, 256, room_height, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	draw_set_color(c_yellow);
	draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart),  "mouse_x_grid: " + string(worldToGrid(mouse_x, mouse_y).xGrid));
	draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart),  "mouse_y_grid: " + string(worldToGrid(mouse_x, mouse_y).yGrid));
	draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart),  "mouse_x_real: " + string(mouse_x));
	draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart),  "mouse_y_real: " + string(mouse_y));
	draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart),  "scale_factor: " + string(global.SCALE_FACTOR));
	draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart),  "errorsCount: "  + string(errorsCount));
	
	
	if (inputController != -1) {
		draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart), "cursor_x_grid: " + string(inputController.xGrid));
		draw_text(_debugXStart, _debugYStart + (_debugY++ * _debugYStart), "cursor_y_grid: " + string(inputController.yGrid));
	}
	
	
	draw_set_color(c_white);
	draw_set_font(fntGame);
}
	
