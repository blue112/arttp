package eu.blue112.arttp.display;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.events.Event;

@:bitmap("lib/gfx/laser.png")
class RedLaserBitmap extends flash.display.BitmapData {}

@:bitmap("lib/gfx/green_laser.png")
class GreenLaserBitmap extends flash.display.BitmapData {}

class Laser extends Sprite
{
	var speedX:Float;
	var speedY:Float;

	var char:Char;

	static var activeLasers:Array<Laser> = [];

	public function new(red:Bool)
	{
		super();

		if (red)
		{
			addChild(new Bitmap(new RedLaserBitmap(0, 0)));
		}
		else
		{
			addChild(new Bitmap(new GreenLaserBitmap(0, 0)));
		}
	}

	static public function clean()
	{
		for (i in activeLasers.copy())
		{
			i.stop();
		}
	}

	public function directTo(char:Char):Void
	{
		var charCoord = char.getCollisionPoints()[0];

		this.char = char;

		var diffX = charCoord.x - this.x;
		var diffY = charCoord.y - this.y;

		var speed = 15;

		var angle = Math.atan2(diffY, diffX);

		speedX = Math.cos(angle) * speed;
		speedY = Math.sin(angle) * speed;

		rotation = Math.floor((angle / Math.PI) * 180);

		addEventListener(Event.ENTER_FRAME, move);

		activeLasers.push(this);
	}

	private function stop()
	{
		removeEventListener(Event.ENTER_FRAME, move);

		if (parent != null)
			parent.removeChild(this);

		activeLasers.remove(this);
	}

	private function move(_):Void
	{
		x += speedX;
		y += speedY;

		var charRect = char.getLaserHitBox();

		if (x < 0 || y < 0 || x > Game.GAME_WIDTH || y > Game.GAME_HEIGHT)
		{
			stop();
		}
		else if (charRect.contains(x, y))
		{
			Game.die();
			stop();
		}
	}
}
