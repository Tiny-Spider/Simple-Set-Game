package;

import motion.Actuate;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import openfl.Lib;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.text.TextField;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author
 */
class Board extends Sprite
{
	private var deck:Array<Card> = new Array<Card>();
	private var board:Array<Card> = new Array<Card>();
	private var selectedCards:Array<Card> = new Array<Card>();

	private var columns:Int = 4;
	private var score:Int = 0;

	private var scoreTextField:TextField = new TextField();
	private var errorTextField:TextField = new TextField();
	private var addColumnButton:Sprite = new Sprite();
	private var endGameButton:Sprite = new Sprite();
	
	private var main:Main;

	public function new(_main:Main)
	{
		super();

		main = _main;
		
		// OPTIONAL: use textFormat for scoreTextField, same can be done for errorTextField
		// Remove if you don't know how it works
		// Example:
		/*
		scoreTextField.defaultTextFormat = new TextFormat("Arial", 20, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		*/

		// ((cardHeight + offset) * rows) + offset
		scoreTextField.y = ((150 + 20) * 3) + 20;
		scoreTextField.width = 300;
		scoreTextField.height = 20;

		// (RGB) Red: 00 Green: FF Blue: 00
		scoreTextField.textColor = 0x00FF00;
		scoreTextField.selectable = false;

		// Set default text for scoreTextField
		scoreTextField.text = "Score: 0";

		// ((cardHeight + offset) * rows) + offset + scoreTextField.height + offset
		errorTextField.y = ((150 + 20) * 3) + 20 + 20 + 20;
		errorTextField.width = 300;
		errorTextField.height = 50;

		// (RGB) Red: FF Green: 00 Blue: 00
		errorTextField.textColor = 0xFF0000;
		errorTextField.selectable = false;

		// Set 'add column' button size
		var addColumnImage:Bitmap = new Bitmap(Assets.getBitmapData("img/button_add.png"));
		addColumnImage.width = 190;
		addColumnImage.height = 45;
		addColumnButton.addChild(addColumnImage);

		// Set 'end game' button size
		var endGameImage:Bitmap = new Bitmap(Assets.getBitmapData("img/button_end.png"));
		endGameImage.width = 190;
		endGameImage.height = 45;
		endGameButton.addChild(endGameImage);

		// Create everything
		createDeck();
		drawCards();
		drawBoard();
	}

	private function createDeck()
	{
		var shapes:Array<String> = ["diamond", "pill", "wave"];
		var fills:Array<String> = ["filled", "open", "shaded"];
		var colors:Array<String> = ["blue", "green", "red"];
		var amounts:Array<String> = ["1", "2", "3"];

		// Every shape type
		for (shape in shapes)
		{
			// Every fill type
			for (fill in fills)
			{
				// Every color type
				for (color in colors)
				{
					// Every amount type
					for (amount in amounts)
					{
						// Create a card with each of these values
						var card:Card = new Card(shape, fill, color, amount);
						// Add it to a deck
						deck.push(card);
					}
				}
			}
		}

		// Shuffle deck
		for (i in 0...deck.length)
		{
			// Pick random place in the deck array
			var randomIndex = Std.random(deck.length);

			// Get card on 'i' and the random position
			var cardA:Card = deck[i];
			var cardB:Card = deck[randomIndex];

			// Then swap their places
			deck[randomIndex] = cardA;
			deck[i] = cardB;
		}
	}

	// Refill or add cards to our deck
	public function drawCards()
	{
		// Height is always 3, columns can be 3 or more
		var cardAmount = 3 * columns;

		for (index in 0...cardAmount)
		{
			// Bigger than our array
			if (index > board.length)
			{
				// Get one from deck
				var card:Card = deck.pop();
				board.push(card);
			}
			// Our spot is empty
			else if (board[index] == null)
			{
				// Get one from deck
				var card:Card = deck.pop();
				board[index] = card;
			}
		}
	}

	public function drawBoard()
	{
		removeChildren();

		for (column in 0...columns)
		{
			for (row in 0...3)
			{
				var index:Int = (3 * column) + row;
				var card:Card = board[index];

				// OPTIONAL: add animation using Actuate
				// You will have to remove code below where x and y are set
				// Please don't use if you don't know how it works
				// Example:
				/*
				var positionX:Float = (100 + 20) * column;
				var positionY:Float = (150 + 20) * row;

				Actuate.tween(card, 1.0, {x:positionX, y:positionY});
				//Actuate.tween(card, 1.0, {scaleX:1.2, scaleY:1.2});
				 */
				 
				// (cardWidth * offset) * row
				card.x = (100 + 20) * column;
				// (cardHeight * offset) * column
				card.y = (150 + 20) * row;

				addChild(card);

				card.addEventListener(MouseEvent.CLICK, onCardClick);
			}
		}

		addChild(scoreTextField);
		addChild(errorTextField);

		// ((cardWidth + offset) * columns) + offset
		addColumnButton.x = ((100 + 20) * columns) + 20;

		addColumnButton.addEventListener(MouseEvent.CLICK, onAddClick);
		addChild(addColumnButton);

		// ((cardWidth + offset) * columns) + offset
		endGameButton.x = ((100 + 20) * columns) + 20;
		// addColumnButton.height + offset
		endGameButton.y = 45 + 20;

		endGameButton.addEventListener(MouseEvent.CLICK, onEndClick);
		addChild(endGameButton);
	}

	private function onAddClick(event:MouseEvent)
	{
		columns += 1;
		drawCards();
		drawBoard();
	}

	private function onEndClick(event:MouseEvent)
	{
		main.endGame();
	}

	private function onCardClick(event:MouseEvent)
	{
		// Get card clicked on, by casting click target to Card
		var card:Card = cast(event.target, Card);

		// If it is selected then unselect it, and visa versa
		if (card.isSelected())
		{
			card.setSelected(false);
			selectedCards.remove(card);
		}
		else
		{
			card.setSelected(true);
			selectedCards.push(card);
		}

		// Remove error when new card is clicked
		errorTextField.text = "";

		// If there are 3 cards selected, see if its a set
		if (selectedCards.length == 3)
		{
			validateSelected();
		}
	}

	private function validateSelected()
	{
		// Check if shape matches
		if (!isMatch(selectedCards[0].shape, selectedCards[1].shape, selectedCards[2].shape))
		{
			errorTextField.text = "Error: the shape does not match!";
			deselectCards();
			return;
		}
		// Check if fill matches
		if (!isMatch(selectedCards[0].fill, selectedCards[1].fill, selectedCards[2].fill))
		{
			errorTextField.text = "Error: the fill does not match!";
			deselectCards();
			return;
		}
		// Check if color matches
		if (!isMatch(selectedCards[0].color, selectedCards[1].color, selectedCards[2].color))
		{
			errorTextField.text = "Error: the color does not match!";
			deselectCards();
			return;
		}
		// Check if amount matches
		if (!isMatch(selectedCards[0].amount, selectedCards[1].amount, selectedCards[2].amount))
		{
			errorTextField.text = "Error: the amount does not match!";
			deselectCards();
			return;
		}

		// Everything matches, so add score
		score += 1;
		scoreTextField.text = "Score: " + score;

		// Remove selected cards from board
		for (card in selectedCards)
		{
			// Find index of card in the board
			var index:Int = board.indexOf(card);

			// Set it to null
			board[index] = null;
		}

		// Clear selected card array
		selectedCards = new Array<Card>();

		// Refill the board
		drawCards();
		drawBoard();
	}

	// Return true if a, b and c are all equal or different
	private function isMatch(a:String, b:String, c:String):Bool
	{
		return (a == b && a == c && b == c) || (a != b && a != c && b != c);
	}

	private function deselectCards()
	{
		// Unselect all selected cards
		for (card in selectedCards)
		{
			card.setSelected(false);
		}

		// Clear selected card array
		selectedCards = new Array<Card>();
	}
}