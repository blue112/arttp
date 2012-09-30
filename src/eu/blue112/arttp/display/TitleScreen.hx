package eu.blue112.arttp.display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.events.Event;
import flash.ui.Keyboard;

import eu.blue112.arttp.engine.KeyManager;

@:bitmap("lib/gfx/titlescreen.png")
class TitleScreenBmp extends BitmapData {}

class TitleScreen extends Sprite
{
	var char:Char;
	var background:Bitmap;

	public function new()
	{
		super();

		background = new Bitmap(new TitleScreenBmp(0, 0));
		addChild(background);

		char = new Char();
		char.scaleX = char.scaleY = 4;
		char.speed = 7;
		char.filters = [new GlowFilter(0xFFFFFF, 0.2, 10, 10, 2, 3)];
		char.x = (Game.GAME_WIDTH - char.width) / 2;
		char.y = Game.GAME_HEIGHT - char.height - 50;
		addChild(char);

		addEventListener(Event.ENTER_FRAME, followChar);
	}

	private function moveChar()
	{
		var add_x = 0;
		var add_y = 0;

		if (KeyManager.isDown(Keyboard.LEFT))
		{
			char.playAnimation(Char.LEFT);
			add_x -= char.speed;
		}
		else if (KeyManager.isDown(Keyboard.RIGHT))
		{
			char.playAnimation(Char.RIGHT);
			add_x += char.speed;
		}
		else
		{
			char.playAnimation(Char.STATIC);
		}

		if (char.x + add_x > 0)
		{
			char.x += add_x;
		}
	}

	private function followChar(e:Event):Void
	{
		moveChar();

		var min_x = Game.GAME_WIDTH - background.width;
		var max_x = 0;

		var end_x = 1000;

		x = -(char.x - (Game.GAME_WIDTH - char.width) / 2);
		x = Math.max(x, min_x);
		x = Math.min(x, max_x);

		if (char.x > end_x - 700)
		{
			background.alpha = (end_x - char.x) / 700;
		}

		if (char.x > end_x)
		{
			removeEventListener(Event.ENTER_FRAME, followChar);
			removeChild(char);

			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
