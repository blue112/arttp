package eu.blue112.arttp;

import flash.display.Sprite;
import flash.display.Shape;
import flash.events.KeyboardEvent;
import flash.events.Event;

import haxe.Timer;

import eu.blue112.arttp.sound.Sound;
import flash.media.SoundTransform;

import eu.blue112.arttp.engine.RhythmManager;
import eu.blue112.arttp.engine.KeyManager;
import eu.blue112.arttp.display.Char;
import eu.blue112.arttp.display.TitleScreen;
import eu.blue112.arttp.display.GrowingText;
import eu.blue112.arttp.display.MapRenderer;
import eu.blue112.arttp.display.Dialog;

using eu.blue112.arttp.tools.EventTools;

class Game extends Sprite
{
	static public inline var GAME_WIDTH:Int = 800;
	static public inline var GAME_HEIGHT:Int = 600;

	var manager:RhythmManager;

	var tickSound:Sound;
	var waitFrame:Bool;

	var map:MapRenderer;

	static private var inst:Game;

	public function new()
	{
		super();

		inst = this;

		flash.Lib.current.addChild(this);

		var gameMask = new Shape();
		gameMask.graphics.beginFill(0xFF0000, 0.5);
		gameMask.graphics.drawRect(0, 0, GAME_WIDTH, GAME_HEIGHT);


		this.mask = gameMask;
		addChild(gameMask);


		flash.Boot.__set_trace_color(0xFFFFFF);

		new KeyManager(); //Init KeyManager

		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;

		stage.addEventListener(Event.RESIZE, onResize);
		onResize(null);

		manager = new RhythmManager(1000, 25);

		if (false)
		{
			var title = new TitleScreen();
			title.addEventListener(Event.COMPLETE, startGame);
			addChild(title);
		}
		else
		{
			startGame(null);
		}

		//Dialog.create(this, "Salut, ca farte ?");
		//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private function onResize(_)
	{
		this.x = (stage.stageWidth - GAME_WIDTH) / 2;
		this.y = (stage.stageHeight - GAME_HEIGHT) / 2;
	}

	static public function tick()
	{
		inst._tick();
	}

	private function _tick()
	{
		shake();

		if (map != null)
		{
			map.tick();
		}
	}

	private function shake()
	{
		x += 2;
		y += 2;

		waitFrame = true;
		addEventListener(Event.ENTER_FRAME, backToNormal);
	}

	private function backToNormal(_)
	{
		if (waitFrame)
		{
			waitFrame = false;
		}
		else
		{
			x -= 2;
			y -= 2;
			removeEventListener(Event.ENTER_FRAME, backToNormal);
		}
	}

	private function startGame(e:Event):Void
	{
		//var s = new Bgm();
		//s.play(0, 0xFFFF, new SoundTransform(0.5));

		while (numChildren > 0) removeChildAt(0);
		addChild(mask);

		tickSound = new Sound();
		loadLevel(0);
	}

	private function loadLevel(id:Int):Void
	{
		map = new MapRenderer(id);
		addChild(map);

		Dialog.create(this, "Mais qu'est ce que je fous la, moi ?");
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
