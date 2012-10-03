package eu.blue112.arttp.display;

import eu.blue112.arttp.engine.KeyManager;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

class Credits extends Sprite
{
	var container:Sprite;

	public function new()
	{
		super();

		graphics.beginFill(0);
		graphics.drawRect(0, 0, Game.GAME_WIDTH, Game.GAME_HEIGHT);

		var creditsText = haxe.Resource.getString("credits").split("\n");

		var posY:Float = Game.GAME_HEIGHT + 10;

		container = new Sprite();

		for (i in 0...creditsText.length)
		{
			if (creditsText[i].length == 0)
				continue;

			var tf = new PixelTextField(creditsText[i], {color:0xB1CAFF, size:30});
			tf.x = (Game.GAME_WIDTH - tf.width) / 2;
			tf.y = posY;

			var blue = new PixelTextField("Blue112", {color:0xFFFFFF, size:20});
			blue.x = (Game.GAME_WIDTH - blue.width) / 2;
			blue.y = tf.y + tf.height + 5;

			container.addChild(tf);
			container.addChild(blue);

			posY = blue.y + blue.height + 50;
		}

		var tf = new PixelTextField("Special Thanks", {color:0xB1CAFF, size:30});
		tf.x = (Game.GAME_WIDTH - tf.width) / 2;
		tf.y = posY;

		posY += tf.height + 5;

		var nick1 = new PixelTextField("jr", {color:0xFFFFFF, size:20});
		nick1.x = (Game.GAME_WIDTH - nick1.width) / 2;
		nick1.y = posY;

		posY += nick1.height + 5;

		var nick2 = new PixelTextField("Mikazuki", {color:0xFFFFFF, size:20});
		nick2.x = (Game.GAME_WIDTH - nick2.width) / 2;
		nick2.y = posY;

		posY += nick2.height + 5;

		var nick3 = new PixelTextField("Lucie", {color:0xFFFFFF, size:20});
		nick3.x = (Game.GAME_WIDTH - nick3.width) / 2;
		nick3.y = posY;

		posY += nick3.height + 5;

		var nick4 = new PixelTextField("Clo", {color:0xFFFFFF, size:20});
		nick4.x = (Game.GAME_WIDTH - nick4.width) / 2;
		nick4.y = posY;

		posY += nick1.height + 5;

		var nick5 = new PixelTextField("Reclad", {color:0xFFFFFF, size:20});
		nick5.x = (Game.GAME_WIDTH - nick5.width) / 2;
		nick5.y = posY;

		container.addChild(tf);
		container.addChild(nick1);
		container.addChild(nick2);
		container.addChild(nick3);
		container.addChild(nick4);
		container.addChild(nick5);

		addEventListener(Event.ENTER_FRAME, scroll);
		flash.Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKey);

		addChild(container);

		KeyManager.is_lock = true;
	}

	private function scroll(_)
	{
		if (container.y <= -(container.height + Game.GAME_HEIGHT))
		{
			this.stop();
		}

		container.y -= 3;
	}

	private function onKey(e:KeyboardEvent)
	{
		if (e.keyCode == Keyboard.ESCAPE)
		{
			this.stop();
		}
	}

	private function stop()
	{
		removeEventListener(Event.ENTER_FRAME, scroll);
		removeEventListener(KeyboardEvent.KEY_UP, onKey);

		this.parent.removeChild(this);
		KeyManager.is_lock = false;
	}
}
