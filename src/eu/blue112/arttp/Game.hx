package eu.blue112.arttp;

import flash.display.Sprite;
import flash.display.Shape;
import flash.events.KeyboardEvent;

import eu.blue112.arttp.sound.Sound;

import eu.blue112.arttp.engine.RhythmManager;
import eu.blue112.arttp.engine.KeyManager;
import eu.blue112.arttp.display.Char;
import eu.blue112.arttp.display.TitleScreen;
import eu.blue112.arttp.display.GrowingText;

class Game extends Sprite
{
	static public inline var GAME_WIDTH:Int = 800;
	static public inline var GAME_HEIGHT:Int = 600;

	var manager:RhythmManager;

	public function new()
	{
		super();

		flash.Lib.current.addChild(this);

		var gameMask = new Shape();
		gameMask.graphics.beginFill(0xFF0000, 0.5);
		gameMask.graphics.drawRect(0, 0, GAME_WIDTH, GAME_HEIGHT);

		this.mask = gameMask;
		addChild(gameMask);

		//var s = new Bgm();
		//s.play();

		new KeyManager(); //Init KeyManager

		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;

		this.y = (stage.stageHeight - GAME_HEIGHT) / 2;
		this.x = (stage.stageWidth - GAME_WIDTH) / 2;

		manager = new RhythmManager(1000, 25);

		addChild(new TitleScreen());

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private function onKeyDown(e:KeyboardEvent):Void
	{
		if (e.keyCode == flash.ui.Keyboard.SPACE)
		{
			if (!manager.is_inited())
			{
				manager.init();
				GrowingText.add("Encore une fois pour démarrer.");
			}
			else
			{
				var result = manager.check();
				switch (result)
				{
					case GOOD: GrowingText.addColor("Bien !", 0xAEFFB4);
					case TOO_SOON(diff): GrowingText.addColor("Trop rapide de "+diff+" ms !", 0xFF9F9B);
					case TOO_LATE(diff): GrowingText.addColor("Trop lent de "+diff+" ms !", 0xFF9F9B);
				}
			}
		}
	}

	static public function main()
	{
		new Game();
	}
}
