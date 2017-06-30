package;

import openfl.Lib;
import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.events.MouseEvent;

/**
 * ...
 * @author 
 */
class Menu extends Sprite
{
	private var main:Main;

	public function new(_main:Main)
	{
		super();

		main = _main;
		
		// OPTIONAL: add logo
		/*
		var logo:Bitmap = new Bitmap(Assets.getBitmapData("img/logo.png"));
		
		logo.width = 500;
		logo.height = 300;
		
		// (screenWidth / 2.0) - (logo.width / 2)
		logo.x = (Lib.current.stage.stageWidth / 2.0) - 250;
		// (screenHeight / 2.0) - (logo.height + buttonImage.height + offset)
		logo.y = (Lib.current.stage.stageHeight / 2.0) - (300 + 45 + 20);
		
		addChild(logo);
		*/
		
		// Create sprite and image
		var button:Sprite = new Sprite();
		var buttonImage:Bitmap = new Bitmap(Assets.getBitmapData("img/button_start.png"));
		
		// Set size
		buttonImage.width = 190;
		buttonImage.height = 45;
		
		// (screenWidth / 2.0) - (buttonImage.width / 2)
		button.x = (Lib.current.stage.stageWidth / 2.0) - 95;
		// (screenHeight / 2.0) - buttonImage.height
		button.y = (Lib.current.stage.stageHeight / 2.0) - 45;
		
		// Add image to button and add event
		button.addChild(buttonImage);
		button.addEventListener(MouseEvent.CLICK, onStartClick);
		
		addChild(button);
	}
	
	private function onStartClick(event:MouseEvent) {
		main.startGame();
	}
}