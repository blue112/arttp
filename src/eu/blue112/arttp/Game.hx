package eu.blue112.arttp;

import flash.display.Sprite;
import flash.display.Shape;
import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.filters.GlowFilter;

import haxe.Timer;

import eu.blue112.arttp.sound.Sound;
import flash.media.SoundTransform;
import flash.media.SoundChannel;

import caurina.transitions.Tweener;

import eu.blue112.arttp.engine.RhythmManager;
import eu.blue112.arttp.engine.KeyManager;
import eu.blue112.arttp.display.Char;
import eu.blue112.arttp.display.TitleScreen;
import eu.blue112.arttp.display.GrowingText;
import eu.blue112.arttp.display.MapRenderer;
import eu.blue112.arttp.display.PixelTextField;

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

	var bgm:SoundChannel;

	var endGame:Bool;

	var map:MapRenderer;
	var deathCounter:PixelTextField;
	var numberDeath:Int;

	static private var inst:Game;

	public function new()
	{
		super();

		init();
	}

	private function init()
	{
		flash.Lib.current.addChild(this);

		inst = this;

		var gameMask = new Shape();
		gameMask.graphics.beginFill(0xFF0000, 0.5);
		gameMask.graphics.drawRect(0, 0, GAME_WIDTH, GAME_HEIGHT);

		this.mask = gameMask;
		addChild(gameMask);

		new KeyManager(); //Init KeyManager

		stage.addEventListener(Event.RESIZE, onResize);
		onResize(null);

		whiteFlash = new Sprite();
		whiteFlash.graphics.beginFill(0xFFFFFF);
		whiteFlash.graphics.drawRect(0, 0, GAME_WIDTH, GAME_HEIGHT);

		if (true)
		{
			var title = new TitleScreen();
			title.addEventListener(Event.COMPLETE, startGame);
			addChild(title);
		}
		else
		{
			startGame(null);
		}
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
		if (endGame)
			return;

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
		var s = new Bgm();
		bgm = s.play(0, 0xFFFF, new SoundTransform(0.3));

		while (numChildren > 0) removeChildAt(0);
		addChild(mask);

		curlevel = 0;

		loadLevel(curlevel);

		numberDeath = 0;
		deathCounter = new PixelTextField("Morts: 000", {color:0x999999, size:25});
		deathCounter.x = GAME_WIDTH - deathCounter.width - 10;
		deathCounter.y = (32 - deathCounter.height) / 2;
		addChild(deathCounter);
		updateDeathCounter();

		tickSound = new Sound(curlevel);
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
		addChildAt(map, 0);
	}

	private function onLevelWin(_)
	{
		if (endGame)
			return;

		curlevel++;

		/*addChild(whiteFlash);
		whiteFlash.alpha = 1;

		Tweener.addTween(whiteFlash, {delay:1, alpha:0, time:1, transition:"linear", onComplete:callback(removeChild, whiteFlash)});*/

		if (curlevel == 9)
		{
			endGame = true;

			addChild(whiteFlash);
			whiteFlash.alpha = 0;

			for (i in 0...20)
			{
				haxe.Timer.delay(callback(shake, Std.random(10) + 5), 250 * i);
			}

			bgm.stop();
			var e = new EndTitle();
			e.play();

			var endText = new PixelTextField("Vous avez gagné", {color:0x000000, size:70});
			endText.filters = [new GlowFilter(0xFFFFFF, 0.5, 20, 20, 2, 3)];
			endText.x = (GAME_WIDTH - endText.width) / 2;
			endText.y = (GAME_HEIGHT - endText.height) / 2;
			addChild(endText);

			Tweener.addTween(whiteFlash, {delay:0, alpha:1, time:4, transition:"linear"});

			var countDown = new PixelTextField("30", {size:70, color:0x000000});
			countDown.x = 60;
			countDown.filters = [new GlowFilter(0xFFD700, 0.5, 20, 20, 2, 3)];
			countDown.y = GAME_HEIGHT - countDown.height - 10;
			addChild(countDown);

			var cd = 30;

			var t = new haxe.Timer(1000);
			t.run = function()
			{
				cd--;
				countDown.text = StringTools.lpad(Std.string(cd), "0", 2);

				if (cd <= 0)
				{
					t.stop();
					removeChild(countDown);
				}
			}

			haxe.Timer.delay(onEndEnds, 31000);
			return;
		}

		unloadLevel();
		loadLevel(curlevel);
	}

	private function onEndEnds():Void
	{
		var c = new Char();
		c.playAnimation(Char.STATIC);
		c.x = 60;
		c.y = GAME_HEIGHT - c.height - 10;
		addChild(c);

		c.say("Bon...");
		haxe.Timer.delay(callback(c.say, "Y'a quelqu'un ?"), 1000);
		haxe.Timer.delay(callback(c.say, "Je fais quoi maintenant ?"), 5000);
		haxe.Timer.delay(callback(c.say, "Et puis coupez moi ce son, quoi !"), 10000);
		haxe.Timer.delay(callback(c.say, "Alloooooo ?"), 17000);
		haxe.Timer.delay(callback(shake, 20), 22000);
		haxe.Timer.delay(callback(c.say, "Allez, on se motive !"), 22000);
		haxe.Timer.delay(callback(c.say, "On va pas y passer la journée, non ?"), 27000);
		haxe.Timer.delay(callback(c.say, "Il était sensé y avoir une princesse à la fin."), 32000);
		haxe.Timer.delay(callback(c.say, "Une vraie princesse, pas celles du royaume des ombres..."), 35000);
		haxe.Timer.delay(callback(c.say, "Bon, bon..."), 38000);
		haxe.Timer.delay(callback(c.say, "Tu es mort "+numberDeath+" fois."), 42000);
		haxe.Timer.delay(callback(c.say, "Mon commentaire à ce sujet, tu dis ?"), 46000);

		var commentaire =
			if (numberDeath == 0)
				"IMPOSSIBRU";
			else if (numberDeath <= 2)
				"Digne du prince des ombres";
			else if (numberDeath <= 5)
				"Excellent.";
			else if (numberDeath <= 10)
				"Très bien !";
			else if (numberDeath <= 15)
				"T'as le coup de main, c'est sûr !";
			else if (numberDeath <= 25)
				"Pas trop mal, écoute.";
			else if (numberDeath <= 50)
				"J'ai déjà vu mieux.";
			else if (numberDeath <= 75)
				"Tu me laisseras faire la prochaine fois.";
			else if (numberDeath <= 150)
				"C'était pas joli-joli.";
			else
				"On va éviter de commenter ce désastre.";

		haxe.Timer.delay(callback(shake, 10), 50000);
		haxe.Timer.delay(callback(c.say, commentaire), 50000);
		haxe.Timer.delay(callback(c.say, "Ah et en fait, enchanté, je suis le prince des ombres"), 55000);
		haxe.Timer.delay(callback(shake, 10), 60000);
		haxe.Timer.delay(callback(c.say, "Blue."), 60000);
		haxe.Timer.delay(callback(c.say, "Si tu veux rejouer, actualise ta page."), 65000);
		haxe.Timer.delay(callback(c.say, "Ravi de t'avoir connu..."), 70000);
		haxe.Timer.delay(function()
		{
			Tweener.addTween(c, {alpha:0, time:3, transition:"linear"});
		}, 70000);
	}

	private function onCharDead(_)
	{
		if (endGame)
			return;

		var sentences = [
			"J'ai pris bien cher",
			"J'ai vu toute ma vie défiler devant mes yeux, c'était chouette",
			"Engagez vous, qu'ils disaient",
			"J'espère que je fais pas tout ca pour rien",
			"L'enfoiré qui m'a mis là dedans...",
			"Je déteste ce niveau",
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

		numberDeath++;
		updateDeathCounter();

		Tweener.addTween(whiteFlash, {alpha:0, time:1, transition:"linear", onComplete:callback(removeChild, whiteFlash)});
	}

	private function updateDeathCounter()
	{
		var txt = "<font color='#FFFFFF'>Morts: </font>";
		var len = Std.string(numberDeath).length;
		txt += "<font color='#999999'>"+StringTools.lpad("", "0", 3 - len)+"</font>";
		txt += "<font color='#FFFFFF'>"+numberDeath+"</font>";

		deathCounter.htmlText = txt;
	}

	static public function main()
	{
		new Game();
	}
}
