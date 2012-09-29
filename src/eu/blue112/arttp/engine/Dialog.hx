package eu.blue112.arttp.engine;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

@:bitmap("lib/gfx/dialog.png")
class DialogBackground extends flash.bitmap.BitmapData {}

class Dialog extends Sprite
{
	public function new(text:String)
	{
		super();

		var bg = new Bitmap(new DialogBackground());
		addChild(bg);

		var tf = new flash.text.TextField();

		var format = new flash.text.TextFormat("Visitor TT1 BRK", 40);;

		tf.defaultTextFormat = format;
		tf.width = 529;
		tf.height = 213;

		tf.multiline = tf.wordWrap = true;

		tf.text = text;
		tf.textColor = 0xFFFFFF;
		tf.embedFonts = true;
		tf.background = true;

		tf.x = (tf.width - tf.textWidth) / 2;
		tf.y = (tf.height - tf.textHeight) / 2;

		addChild(tf);
	}

	public static function create(parent:Sprite, text:String):Dialog
	{
		var d = new Dialog();
		d.x = (Game.GAME_WIDTH - d.width) / 2;
		d.y = Game.GAME_HEIGHT - d.height - 50;

		parent.addChild(d);
		return d;
	}
}
