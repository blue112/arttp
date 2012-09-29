package eu.blue112.arttp.display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.ui.Keyboard;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import eu.blue112.arttp.engine.KeyManager;

@:bitmap("lib/gfx/main_char.png")
class CharGfx extends BitmapData {}

class Char extends Sprite
{
	var bitmap_data:Hash<Array<BitmapData>>;

	var currentPlaying:Array<BitmapData>;
	var currentPlayingIndex:Int;
	var currentDirection:String;

	var char:Bitmap;

	public var speed:Int;

	static public var LEFT:String = "left";
	static public var RIGHT:String = "right";
	static public var DOWN:String = "down";
	static public var UP:String = "up";
	static public var STATIC:String = "static";

	public function new()
	{
		super();

		bitmap_data = new Hash();
		char = new Bitmap();

		speed = 4;

		var charset = new CharGfx(0, 0, true, 0);

		var charW = 72;
		var charH = 96;

		var names = [UP, RIGHT, DOWN, LEFT];
		for (i in 0...names.length)
		{
			var a = [];
			var numFrame = 3;

			for (j in 0...numFrame)
			{
				var b = new BitmapData(charW, charH, true, 0);
				b.copyPixels(charset, new Rectangle(j * charW, i * charH, charW, charH), new Point(0, 0));

				a.push(b);
			}

			bitmap_data.set(names[i], a);
		}

		var m = new flash.geom.Matrix();
		m.createGradientBox(80, 30, 0, 0, 0);

		var shadow = new flash.display.Shape();
		shadow.graphics.beginGradientFill(flash.display.GradientType.RADIAL, [0x0, 0x0], [1, 0], [0, 255], m);
		shadow.graphics.drawEllipse(0, 0, 80, 30);

		shadow.x = -5;
		shadow.y = 70;

		addChild(shadow);
		addChild(char);

		playAnimation(DOWN);

		addEventListener(Event.ENTER_FRAME, animate);
		addEventListener(Event.REMOVED_FROM_STAGE, disable);
	}

	private function disable(_)
	{
		removeEventListener(Event.ENTER_FRAME, animate);
	}

	public function playAnimation(direction:String):Void
	{
		if (currentDirection == direction)
			return;

		currentPlayingIndex = 0;
		currentPlaying = bitmap_data.get(direction);
		currentDirection = direction;

		if (direction == STATIC)
			char.bitmapData = bitmap_data.get(DOWN)[0];
	}

	private function animate(e:Event):Void
	{
		if (KeyManager.isDown(Keyboard.UP))
		{
			playAnimation(UP);
			y -= speed;
		}
		else if (KeyManager.isDown(Keyboard.DOWN))
		{
			playAnimation(DOWN);
			y += speed;
		}
		else if (KeyManager.isDown(Keyboard.LEFT))
		{
			playAnimation(LEFT);
			x -= speed;
		}
		else if (KeyManager.isDown(Keyboard.RIGHT))
		{
			playAnimation(RIGHT);
			x += speed;
		}
		else
		{
			playAnimation(STATIC);
		}

		if (currentDirection == STATIC)
			return;

		currentPlayingIndex++;
		if (Math.floor(currentPlayingIndex / 5) >= currentPlaying.length)
			currentPlayingIndex = 0;

		char.bitmapData = currentPlaying[Math.floor(currentPlayingIndex / 5)];
	}
}
