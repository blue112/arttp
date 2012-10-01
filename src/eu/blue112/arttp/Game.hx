package eu.blue112.arttp;

import flash.display.Sprite;
import flash.display.Shape;
import flash.events.KeyboardEvent;
import flash.events.Event;

import haxe.Timer;

import eu.blue112.arttp.sound.Sound;
import flash.media.SoundTransform;

import caurina.transitions.Tweener;

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
	var whiteFlash:Sprite;
	var curlevel:Int;

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

		whiteFlash = new Sprite();
		whiteFlash.graphics.beginFill(0xFFFFFF);
		whiteFlash.graphics.drawRect(0, 0, GAME_WIDTH, GAME_HEIGHT);

		//manager = new RhythmManager(1000, 25);

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

	static public function die()
	{
		inst.map.onDead();
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

	private function shake(?force:Int = 1)
	{
		x += 2 * force;
		y += 2 * force;

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
			onResize(null);
			removeEventListener(Event.ENTER_FRAME, backToNormal);
		}
	}

	private function startGame(e:Event):Void
	{
		//var s = new Bgm();
		//s.play(0, 0xFFFF, new SoundTransform(0.3));

		while (numChildren > 0) removeChildAt(0);
		addChild(mask);

		curlevel = 0;

		tickSound = new Sound();
		loadLevel(5);
	}

	private function unloadLevel():Void
	{
		if (map != null)
		{
			map.stop();
			removeChild(map);
			map.removeEventListener(MapRenderer.DEAD, onCharDead);
			map.removeEventListener(MapRenderer.WIN, onLevelWin);
			map = null;
		}
	}

	private function loadLevel(id:Int):Void
	{
		map = new MapRenderer(id);
		map.addEventListener(MapRenderer.DEAD, onCharDead);
		map.addEventListener(MapRenderer.WIN, onLevelWin);
		addChild(map);
	}

	private function onLevelWin(_)
	{
		curlevel++;

		/*addChild(whiteFlash);
		whiteFlash.alpha = 1;

		Tweener.addTween(whiteFlash, {delay:1, alpha:0, time:1, transition:"linear", onComplete:callback(removeChild, whiteFlash)});*/

		unloadLevel();
		loadLevel(curlevel);
	}

	private function onCharDead(_)
	{
		var sentences = [
			"J'ai pris bien cher",
			"J'ai vu toute ma vie défiler devant mes yeux, c'était chouette",
			"Engagez vous, qu'ils disaient",
			"J'espère que je fais pas tout ca pour rien",
			"L'enfoiré qui m'a mis là dedans...",
			"Je déteste ce niveau",
			//"Mais d'où ils viennent ces monstres ?",
			"Y a pas des cheat codes ?",
			"Moi qui pensait que ce serait facile",
			"C'est reparti pour un tour...",
			"Ca m'a pas l'air si compliqué pourtant...",
			"Vivement le royaume des ombres...",
			"C'est quoi ces pièges complètement stupides ?",
			"On se croirait dans Cube.",
			"J'en suis à combien de morts, là ?",
			"C'était plus tranquille dans le jeu avec la Princesse",
			"Si j'avais la Master Sword, ce serait vite réglé.",
			"Pas de petite fée pour me guider cette fois.",
			"Franchement, qu'est ce que je fous là ?",
			"Pour mon père, le roi !",
			"J'aurai jamais dû choisir Salamèche...",
			"Manque plus que les zombies, et on est dans Hordes",
			"Où sont mes chocapics ?",
			"Une fois sorti, je balance une Antiville sur ce truc.",
			"Encore un coup du docteur Eggman.",
			"Il faut *éviter* les pièges...",
			"En tant que Prince des Ombres, je devrais avoir des clones d'ombres...",
			"Y a pas intérêt à ce qu'elle soit dans un autre château... ",
			"Y a des princes qui marchent sur les murs, moi je me juste fais troncher... ",
			"Du travail, encore du travail",
			"I'm still alive !",
			"Lache le clavier maintenant, tu sais pas t'y prendre",
			"Où j'ai posé mon cube de voyage ?",
			"Faudrait que je trouve la Warp Zone",
			"Alors, ça va la forme ? Parce que moi je suis une patate !",
		];

		var text = sentences[Std.random(sentences.length)];

		map.char.say(text);

		shake(10);
		addChild(whiteFlash);
		whiteFlash.alpha = 1;

		Tweener.addTween(whiteFlash, {alpha:0, time:1, transition:"linear", onComplete:callback(removeChild, whiteFlash)});
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
