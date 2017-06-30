package;

import openfl.Lib;
import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author
 */
class Main extends Sprite
{
	public function new()
	{
		super();

		showMenu();
	}

	public function showMenu()
	{
		removeChildren();
		
		var menu:Menu = new Menu(this);
		addChild(menu);
	}

	public function startGame()
	{
		removeChildren();
		
		var board:Board = new Board(this);
		addChild(board);
	}

	public function endGame()
	{
		removeChildren();
		
		var end:End = new End(this);
		addChild(end);
	}
}
