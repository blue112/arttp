package eu.blue112.arttp.loader;

import flash.display.Sprite;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLRequest;

import eu.blue112.arttp.display.Char;
import eu.blue112.arttp.display.PixelTextField;
import eu.blue112.arttp.engine.KeyManager;

import caurina.transitions.Tweener;


class GameLoader extends Sprite
{
	static var char:Char;
	static var percent:PixelTextField;
	static var game:Loader;

	static public function main()
	{
		var stage = flash.Lib.current.stage;

		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;

		new KeyManager(); //Init KeyManager

		char = new Char();
		stage.addChild(char);

		char.x = stage.stageWidth * 0.1;
		char.y = (stage.stageHeight - char.height) / 2;
		char.playAnimation(Char.RIGHT);

		percent = new PixelTextField("00%", {color:0xFFFFFF, size:50});
		percent.x = (stage.stageWidth - percent.width) / 2;
		percent.y = char.y - percent.height - 20;
		stage.addChild(percent);

		game = new Loader();
		game.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadComplete);
		game.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		game.load(new URLRequest("arttp.swf"));

		flash.Boot.__set_trace_color(0xFFFFFF);
	}

	static private function onProgress(e:ProgressEvent):Void
	{
		var p:Float = e.bytesLoaded / e.bytesTotal;

		percent.text = Math.round(p * 100)+"%";

		char.x = ((p * 0.8) + 0.1) * flash.Lib.current.stage.stageWidth;
	}

	static private function onSWFLoadComplete(e:Event):Void
	{
		game.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSWFLoadComplete);
		game.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onSWFLoadComplete);

		char.playAnimation(Char.STATIC);
		showGame();
	}

	static private function showGame()
	{
		var stage = flash.Lib.current.stage;
		stage.removeChild(char);
		stage.removeChild(percent);

		char = null;
		percent = null;

		stage.addChild(game);
	}
}
