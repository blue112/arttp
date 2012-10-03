package eu.blue112.arttp.loader;

import flash.display.Sprite;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;

import eu.blue112.arttp.display.Char;
import eu.blue112.arttp.display.PixelTextField;
import eu.blue112.arttp.engine.KeyManager;

class GameLoader extends Sprite
{
	static var char:Char;
	static var game:Loader;

	static public function main()
	{
		var stage = flash.Lib.current.stage;

		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;

		new KeyManager(); //Init KeyManager

		var percent = new PixelTextField("00%");

		char = new Char();
		stage.addChild(char);

		char.x = stage.stageWidth * 0.1;
		char.y = (stage.stageHeight - char.height) / 2;
		char.playAnimation(Char.RIGHT);

		game = new Loader();
		game.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadComplete);
		game.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		game.load(new URLRequest("arttp.swf"));
	}

	static private function onProgress(e:ProgressEvent):Void
	{
		var percent:Float = e.bytesLoaded / e.bytesTotal;

		char.x = ((percent * 0.8) + 0.1) * flash.Lib.current.stage.stageWidth;
	}

	static private function onSWFLoadComplete(e:Event):Void
	{
		vayu.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSWFLoadComplete);
		vayu.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onSWFLoadComplete);

	}
}
