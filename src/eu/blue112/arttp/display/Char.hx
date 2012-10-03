package eu.blue112.arttp.display;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.ui.Keyboard;
import flash.filters.GlowFilter;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import caurina.transitions.Tweener;

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
	public var saiyanMode:Bool;

	var talkText:PixelTextField;

	var hitbox:Sprite;

	static public var LEFT:String = "left";
	static public var RIGHT:String = "right";
	static public var DOWN:String = "down";
	static public var UP:String = "up";
	static public var STATIC:String = "static";

	static public var CENTER_POINT:Point = new Point(10, 45);

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

		hitbox = new Sprite();
		hitbox.graphics.beginFill(0xFF0000, 0.5);
		hitbox.graphics.drawRect(25, 70, 20, 20);
		hitbox.visible = false;
		addChild(hitbox);

		saiyanMode = false;
	}

	public function setSaiyanMode(active:Bool)
	{
		this.saiyanMode = active;

		if (saiyanMode)
		{
			this.filters = [new GlowFilter(0xFFD700, 0.5, 20, 20, 2, 3)];
		}
		else
		{
			this.filters = [];
		}
	}

	public function showLifeLeft(nb:Int)
	{
		var left = new PixelTextField("Agacement: <font color='#5297FE'>"+nb+"%</font>", {size:25, color:0xFFFFFF});
		left.filters = [new flash.filters.GlowFilter(0, 0.5, 5, 5, 10, 2)];
		left.x = 0;
		left.y = -left.height;
		addChild(left);

		Tweener.addTween(left, {delay:1, time:1, transition:"easeInQuad", y:left.y + 10, alpha:0, onComplete:callback(removeChild, left)});
	}

	public function say(text:String)
	{
		if (talkText != null && talkText.parent != null)
		{
			Tweener.removeTweens(talkText);
			Tweener.addTween(talkText, {time:1, alpha:0, transition:"easeOutQuint"});
		}

		talkText = new PixelTextField(text, {color:0xFFFFFF, size:20});
		talkText.width = 250;
		talkText.wordWrap = talkText.multiline = true;
		talkText.filters = [new flash.filters.GlowFilter(0, 0.5, 5, 5, 10, 2)];
		talkText.x = 70;
		talkText.y = 10;
		addChild(talkText);

		Tweener.addTween(talkText, {delay:2, time:2, transition:"easeInQuad", y:-30, alpha:0, onComplete:callback(removeChild, talkText)});
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
		hitbox.visible = KeyManager.isDown(Keyboard.CONTROL);

		if (currentDirection == STATIC)
			return;

		currentPlayingIndex++;
		if (Math.floor(currentPlayingIndex / 5) >= currentPlaying.length)
			currentPlayingIndex = 0;

		char.bitmapData = currentPlaying[Math.floor(currentPlayingIndex / 5)];
	}

	public inline function setPointFromCenter(pt:Point):Void
	{
		pt = pt.subtract(CENTER_POINT);

		this.x = pt.x;
		this.y = pt.y;
	}

	public function getCollisionPoints(?add_x:Int, ?add_y:Int):Array<Point>
	{
		var base = new Point(x + add_x, y + add_y);

		var baseX = 25 * scaleX;
		var baseY = 70 * scaleY;
		var w = 20 * scaleX;
		var h = 20 * scaleY;

		return [
			base.add(new Point(baseX, baseY)),
			base.add(new Point(baseX + w, baseY)),
			base.add(new Point(baseX, baseY + h)),
			base.add(new Point(baseX + w, baseY + h))
		];
	}

	public function getLaserHitBox():Rectangle
	{
		var baseX = 18 * scaleX;
		var baseY = 24 * scaleY;
		var w = 36 * scaleX;
		var h = 67 * scaleY;

		return new Rectangle(baseX + x, baseY + y, w, h);

	}
}
