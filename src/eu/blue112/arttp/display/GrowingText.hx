package eu.blue112.arttp.display;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import caurina.transitions.Tweener;

class GrowingText extends Sprite
{
	public var tf:TextField;

	static private var queue:Array<GrowingText> = [];

	public function new(text:String, ?color:Int = 0xFFFFFF, ?time:Int = 2, ?size:Int = 25):Void
	{
		super();

		flash.Lib.current.stage.addChild(this);

		var format:TextFormat = new TextFormat("Arial", size, color, true);
		tf = new TextField();
		tf.filters = [new GlowFilter(0, 0.5, 5, 5, 10, 2)];
		tf.selectable = false;
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.defaultTextFormat = format;
		tf.htmlText = text;

		addChild(tf);

		y = (stage.stageHeight - this.height) / 2;
		x = (stage.stageWidth - this.width) / 2;

		this.visible = false;

		y += queue.length * 30;
		start(time);

		queue.push(this);
	}

	private function start(time:Int):Void
	{
		visible = true;
		Tweener.addTween(this, {y:y - 150, onComplete:onComplete, alpha:0, time:time, transition:"easeInQuart"});
	}

	static public function add(text:String):GrowingText
	{
		return new GrowingText(text);
	}

	static public function addColor(text:String, color:Int):GrowingText
	{
		return new GrowingText(text, color);
	}

	private function onComplete():Void
	{
		this.parent.removeChild(this);
		queue.remove(this);
	}

}

