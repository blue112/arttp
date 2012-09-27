package eu.blue112.arttp;

import flash.display.Sprite;
import flash.events.KeyboardEvent;

import eu.blue112.arttp.sound.Sound;

import eu.blue112.arttp.engine.RhythmManager;

class Game extends Sprite
{
	static public inline var GAME_WIDTH:Int = 800;
	static public inline var GAME_HEIGHT:Int = 600;

	var manager:RhythmManager;

	public function new()
	{
		super();

		flash.Lib.current.addChild(this);

		var s = new Bgm();
		s.play();

		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;

		manager = new RhythmManager(1000);

		trace("Appuyez sur espace toutes les secondes !");

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private function onKeyDown(e:KeyboardEvent):Void
	{
		if (e.keyCode == flash.ui.Keyboard.SPACE)
		{
			if (!manager.is_inited())
			{
				manager.init();
				trace("Encore une fois pour démarrer.");
			}
			else
			{
				var result = manager.check();
				switch (result)
				{
					case GOOD: trace("Bien !");
					case TOO_SOON(diff): trace("Trop rapide de "+diff+" ms !");
					case TOO_LATE(diff): trace("Trop lent de "+diff+" ms !");
				}
			}
		}
	}

	static public function main()
	{
		new Game();
	}
}
