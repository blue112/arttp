package eu.blue112.arttp.display;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flash.events.Event;

import eu.blue112.arttp.engine.KeyManager;

import haxe.Timer;

@:bitmap("lib/gfx/dialog.png")
class DialogBackground extends flash.display.BitmapData {}

class Dialog extends Sprite
{
	var espace:TextField;
	var blinkTimer:Timer;

	public function new(text:String)
	{
		super();

		var bg = new Bitmap(new DialogBackground(0, 0, true));
		addChild(bg);

		var tf = new PixelTextField(text);
		tf.width = 529;
		tf.height = 213;

		tf.multiline = tf.wordWrap = true;
		tf.x = 205 + (tf.width - tf.textWidth) / 2;
		tf.y = 11 + (tf.height - tf.textHeight) / 2;

		addChild(tf);

		espace = new PixelTextField("Espace", {size:20});
		espace.x = 655;
		espace.y = 200;
		addChild(espace);

		blinkTimer = new Timer(500);
		blinkTimer.run = blinkEspace;

		addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);

		KeyManager.blockUntil(Keyboard.SPACE, onSpace);
	}

	private function onSpace()
	{
		this.parent.removeChild(this);
	}

	private function onDestroy(_)
	{
		blinkTimer.stop();
	}

	private function blinkEspace()
	{
		espace.visible = !espace.visible;
	}

	public static function create(parent:Sprite, text:String):Dialog
	{
		var d = new Dialog(text);
		d.x = (Game.GAME_WIDTH - 745) / 2;
		d.y = Game.GAME_HEIGHT - 235 - 50;

		parent.addChild(d);
		return d;
	}
}
