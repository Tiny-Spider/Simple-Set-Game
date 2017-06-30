package;

import openfl.Lib;
import openfl.Assets;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author
 */
class Card extends Sprite
{
	public var shape:String;
	public var fill:String;
	public var color:String;
	public var amount:String;
	
	private var selection:Bitmap;
	private var selected:Bool = false;

	public function new(_shape:String, _fill:String, _color:String, _amount:String)
	{
		super();

		shape = _shape;
		fill = _fill;
		color = _color;
		amount = _amount;

		// Card
		// Load card image
		var fileName:String = "img/cards/" + amount + "_" + color + "_" + fill + "_" + shape + ".png";
		var cardImage:Bitmap = new Bitmap(Assets.getBitmapData(fileName));

		// Set card size
		cardImage.width = 100;
		cardImage.height = 150;

		addChild(cardImage);

		// Selection
		// Load selection overlay
		selection = new Bitmap(Assets.getBitmapData("img/selection.png"));

		// Set overlay size
		selection.width = 100;
		selection.height = 150;
	}

	public function setSelected(_selected:Bool)
	{
		selected = _selected;
		
		// Add or remove the overlay
		if (selected)
		{
			addChild(selection);
		}
		else
		{
			removeChild(selection);
		}
	}
	
	public function isSelected():Bool {
		return selected;
	}
}